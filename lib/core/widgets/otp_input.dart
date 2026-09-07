import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';

/// Six-box OTP entry. Each box springs in on focus and shows a blinking
/// text cursor while empty and active. Calls [onCompleted] once all boxes
/// are filled, and [onChanged] on every keystroke (handy for clearing an
/// error state as soon as the person starts retyping).
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
  late final List<TextEditingController> _controllers =
      List.generate(widget.length, (_) => TextEditingController());
  late final List<FocusNode> _nodes = List.generate(widget.length, (_) => FocusNode());

  String get value => _controllers.map((c) => c.text).join();
  String get _value => value;

  void clear() {
    for (final c in _controllers) {
      c.clear();
    }
    _nodes.first.requestFocus();
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final n in _nodes) {
      n.dispose();
    }
    super.dispose();
  }

  void _onChanged(int index, String value) {
    if (value.isNotEmpty) {
      if (index < widget.length - 1) {
        _nodes[index + 1].requestFocus();
      } else {
        _nodes[index].unfocus();
      }
    }
    widget.onChanged?.call(_value);
    if (_value.length == widget.length) widget.onCompleted(_value);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(widget.length, (i) {
        return _OtpBox(
          controller: _controllers[i],
          node: _nodes[i],
          hasError: widget.hasError,
          onChanged: (v) => _onChanged(i, v),
          onBackspaceEmpty: () {
            if (i > 0) {
              _controllers[i - 1].clear();
              _nodes[i - 1].requestFocus();
              setState(() {});
            }
          },
        );
      }),
    );
  }
}

class _OtpBox extends StatefulWidget {
  const _OtpBox({
    required this.controller,
    required this.node,
    required this.onChanged,
    required this.onBackspaceEmpty,
    required this.hasError,
  });

  final TextEditingController controller;
  final FocusNode node;
  final ValueChanged<String> onChanged;
  final VoidCallback onBackspaceEmpty;
  final bool hasError;

  @override
  State<_OtpBox> createState() => _OtpBoxState();
}

class _OtpBoxState extends State<_OtpBox> {
  final _keyboardFocus = FocusNode(skipTraversal: true);

  @override
  void initState() {
    super.initState();
    widget.node.addListener(_onFocusChanged);
  }

  void _onFocusChanged() => setState(() {});

  @override
  void dispose() {
    widget.node.removeListener(_onFocusChanged);
    _keyboardFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filled = widget.controller.text.isNotEmpty;
    final focused = widget.node.hasFocus;
    return AnimatedContainer(
      duration: AppMotion.fast,
      curve: Curves.easeOut,
      width: 46,
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: widget.hasError
              ? AppColors.danger
              : focused
                  ? AppColors.primary
                  : AppColors.borderStrong,
          width: focused || widget.hasError ? 1.8 : 1.2,
        ),
        boxShadow: focused
            ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.15), blurRadius: 10, spreadRadius: 1)]
            : null,
      ),
      alignment: Alignment.center,
      child: KeyboardListener(
        focusNode: _keyboardFocus,
        onKeyEvent: (event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.backspace &&
              widget.controller.text.isEmpty) {
            widget.onBackspaceEmpty();
          }
        },
        child: TextField(
          controller: widget.controller,
          focusNode: widget.node,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          style: AppTextStyles.h3,
          showCursor: true,
          cursorColor: AppColors.primary,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(counterText: '', border: InputBorder.none),
          onChanged: widget.onChanged,
        ),
      ),
    );
  }
}

/// "Resend code in 0:45" label that counts down and flips to a tappable
/// "Resend code" link once it hits zero. Call [reset] after a successful
/// resend to restart the countdown.
class ResendCountdown extends StatefulWidget {
  const ResendCountdown({super.key, required this.onResend, this.seconds = 60});
  final VoidCallback onResend;
  final int seconds;

  @override
  State<ResendCountdown> createState() => _ResendCountdownState();
}

class _ResendCountdownState extends State<ResendCountdown> {
  late int _remaining = widget.seconds;
  Timer? _timer;

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

  @override
  Widget build(BuildContext context) {
    if (_remaining == 0) {
      return GestureDetector(
        onTap: () {
          widget.onResend();
          setState(_start);
        },
        child: Text('Resend code', style: AppTextStyles.buttonMd.copyWith(color: AppColors.primary)),
      );
    }
    final m = _remaining ~/ 60;
    final s = (_remaining % 60).toString().padLeft(2, '0');
    return Text('Resend code in $m:$s', style: AppTextStyles.bodyMd);
  }
}
