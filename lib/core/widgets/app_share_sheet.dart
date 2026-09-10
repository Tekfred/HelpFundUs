import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_colors.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';

class ShareSheetData {
  const ShareSheetData({
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.link,
    required this.iconGradient,
  });

  final String title;
  final String subtitle;
  final String emoji;
  final String link;
  final Gradient iconGradient;
}

void showAppShareSheet(BuildContext context, ShareSheetData data) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => AppShareSheet(data: data),
  );
}

class AppShareSheet extends StatelessWidget {
  const AppShareSheet({super.key, required this.data});

  final ShareSheetData data;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => SafeArea(
      top: false,
      child: SizedBox(
        width: constraints.maxWidth,
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD1DB),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              const SizedBox(height: 14),
              _ShareCampaignSummary(data: data),
              const SizedBox(height: 16),
              const Row(
                children: [
                  Expanded(
                    child: _ShareOption(label: 'WhatsApp', emoji: '💬'),
                  ),
                  Expanded(
                    child: _ShareOption(label: 'X (Twitter)', emoji: '𝕏'),
                  ),
                  Expanded(
                    child: _ShareOption(label: 'Facebook', emoji: '📘'),
                  ),
                  Expanded(
                    child: _ShareOption(label: 'Email', emoji: '📧'),
                  ),
                  Expanded(
                    child: _ShareOption(label: 'Messages', emoji: '📩'),
                  ),
                  Expanded(
                    child: _ShareOption(label: 'More...', emoji: '🔗'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        data.link,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodyMd.copyWith(fontSize: 14),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 42,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Campaign link copied.'),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          side: const BorderSide(color: Color(0xFFCBD1DB)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: const Icon(Icons.copy_outlined, size: 17),
                        label: Text(
                          'Copy',
                          style: AppTextStyles.buttonMd.copyWith(fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Sharing this link does not reveal your donation history or personal details.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySm.copyWith(
                  fontSize: 12,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _ShareCampaignSummary extends StatelessWidget {
  const _ShareCampaignSummary({required this.data});

  final ShareSheetData data;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: AppColors.background,
      borderRadius: BorderRadius.circular(18),
    ),
    child: Row(
      children: [
        Container(
          width: 60,
          height: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: data.iconGradient,
            borderRadius: BorderRadius.circular(17),
          ),
          child: Text(data.emoji, style: const TextStyle(fontSize: 29)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.h3.copyWith(fontSize: 16),
              ),
              const SizedBox(height: 3),
              Text(
                data.subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyMd.copyWith(fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _ShareOption extends StatelessWidget {
  const _ShareOption({required this.label, required this.emoji});

  final String label;
  final String emoji;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final tileSize = constraints.maxWidth < 54 ? constraints.maxWidth : 54.0;
      return Column(
        children: [
          Container(
            width: tileSize,
            height: tileSize,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(17),
            ),
            child: Text(emoji, style: const TextStyle(fontSize: 22)),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(fontSize: 10),
          ),
        ],
      );
    },
  );
}
