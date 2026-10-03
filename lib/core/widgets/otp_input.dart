import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme_colors.dart';

/// Six-box OTP entry backed by one text field. A single editing source keeps
/// paste, deletion and cursor placement reliable while retaining visual cells.
class OtpInput extends StatefulWidget {
  const OtpInput({
    super.key,
    this.length = 6,
    required this.onCompleted,
    this.onChanged,
    this.hasError = false,
  });

  final int length;
  final ValueChanged<String> onCompleted;
  final ValueChanged<String>? onChanged;
  final bool hasError;

  @override
  State<OtpInput> createState() => OtpInputState();
}

class OtpInputState extends State<OtpInput> {
  late final TextEditingController _controller = TextEditingController();
  late final FocusNode _focusNode = FocusNode()..addListener(_onFocusChanged);

  String get value => _controller.text;

  void clear() {
    _controller.clear();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_onFocusChanged)
      ..dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onFocusChanged() => setState(() {});

  void _onChanged(String value) {
    widget.onChanged?.call(value);
    if (value.length == widget.length) widget.onCompleted(value);
    setState(() {});
  }

  void _focusAt(Offset position, double cellWidth) {
    final index = (position.dx / (cellWidth + AppSpacing.sm)).floor().clamp(
      0,
      widget.length - 1,
    );
    _focusNode.requestFocus();
    _controller.selection = TextSelection.collapsed(
      offset: index.clamp(0, _controller.text.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cellWidth =
            ((constraints.maxWidth - (widget.length - 1) * AppSpacing.sm) /
                    widget.length)
                .clamp(38.0, 54.0)
                .toDouble();
        final selection = _controller.selection.baseOffset.clamp(
          0,
          _controller.text.length,
        );
        final activeIndex = selection.clamp(0, widget.length - 1);

        return Semantics(
          textField: true,
          label: '${widget.length}-digit verification code',
          value:
              '${_controller.text.length} of ${widget.length} digits entered',
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (details) => _focusAt(details.localPosition, cellWidth),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(widget.length, (index) {
                    final character = index < _controller.text.length
                        ? _controller.text[index]
                        : '';
                    return _OtpBox(
                      width: cellWidth,
                      value: character,
                      active: _focusNode.hasFocus && index == activeIndex,
                      hasError: widget.hasError,
                    );
                  }),
                ),
                IgnorePointer(
                  child: Opacity(
                    opacity: 0,
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.oneTimeCode],
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(widget.length),
                      ],
                      onChanged: _onChanged,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _OtpBox extends StatelessWidget {
  const _OtpBox({
    required this.width,
    required this.value,
    required this.active,
    required this.hasError,
  });

  final double width;
  final String value;
  final bool active;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppMotion.fast,
      curve: Curves.easeOut,
      width: width,
      height: 56,
      decoration: BoxDecoration(
        color: context.appInput,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: hasError
              ? AppColors.danger
              : active
              ? AppColors.primary
              : context.appBorderStrong,
          width: active || hasError ? 1.8 : 1.2,
        ),
        boxShadow: active
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      alignment: Alignment.center,
      child: Text(
        value,
        style: AppTextStyles.h3.copyWith(color: context.appTextPrimary),
      ),
    );
  }
}

/// "Resend code in 0:45" label that counts down and flips to a tappable
/// "Resend code" link once it hits zero. Call [reset] after a successful
/// resend to restart the countdown.
class ResendCountdown extends StatefulWidget {
  const ResendCountdown({
    super.key,
    required this.onResend,
    this.onResendAsync,
    this.seconds = 60,
  });
  final VoidCallback onResend;
  final Future<bool> Function()? onResendAsync;
  final int seconds;

  @override
  State<ResendCountdown> createState() => _ResendCountdownState();
}

class _ResendCountdownState extends State<ResendCountdown> {
  late int _remaining = widget.seconds;
  Timer? _timer;
  bool _isResending = false;

  @override
  void initState() {
    super.initState();
    _start();
  }

  void _start() {
    _timer?.cancel();
    _remaining = widget.seconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_remaining == 0) {
        t.cancel();
      } else {
        setState(() => _remaining--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _resend() async {
    if (_isResending || _remaining != 0) return;
    setState(() => _isResending = true);
    final succeeded =
        await (widget.onResendAsync?.call() ?? Future.value(true));
    if (!mounted) return;
    setState(() => _isResending = false);
    if (succeeded) {
      widget.onResend();
      setState(_start);
    }
  }

  @override
  Widget build(BuildContext context) {
    final minutes = _remaining ~/ 60;
    final seconds = (_remaining % 60).toString().padLeft(2, '0');
    final canResend = _remaining == 0 && !_isResending;
    return TextButton(
      onPressed: canResend ? _resend : null,
      child: Text(
        _isResending
            ? 'Sending code…'
            : canResend
            ? 'Resend code'
            : 'Resend code in $minutes:$seconds',
        style: AppTextStyles.buttonMd.copyWith(
          color: canResend ? AppColors.primary : context.appTextMuted,
        ),
      ),
    );
  }
}
