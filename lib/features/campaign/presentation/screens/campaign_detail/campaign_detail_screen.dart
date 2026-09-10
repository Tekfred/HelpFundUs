import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_colors.dart';
import 'package:helpfundus/core/theme/app_dimens.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';
import 'package:helpfundus/core/widgets/app_share_sheet.dart';
import 'package:helpfundus/features/campaign/data/campaign_catalog.dart';
import 'package:helpfundus/features/donation/presentation/screens/choose_donation_amount/choose_donation_amount_screen.dart';
import 'campaign_milestones_screen.dart';
import 'campaign_updates_screen.dart';

class CampaignDetailScreen extends StatelessWidget {
  const CampaignDetailScreen({
    super.key,
    required this.campaign,
    this.onGuestDonate,
  });
  final CampaignData campaign;
  final VoidCallback? onGuestDonate;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.background,
    body: SafeArea(
      bottom: false,
      child: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: _CampaignHeroDelegate(child: _hero(context)),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 108),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (campaign.status != CampaignStatus.active) _statusBanner(),
                  Text(
                    campaign.title,
                    style: AppTextStyles.h1.copyWith(
                      fontSize: 24,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _fundraiser(),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 19,
                        color: Color(0xFF9AA4B5),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        campaign.location,
                        style: AppTextStyles.bodyMd.copyWith(
                          fontSize: 15,
                          color: const Color(0xFF687386),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _fundingSummary(),
                  const SizedBox(height: 22),
                  Text(
                    'Campaign story',
                    style: AppTextStyles.h2.copyWith(fontSize: 20),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    campaign.story,
                    style: AppTextStyles.bodyMd.copyWith(
                      fontSize: 15,
                      color: const Color(0xFF687386),
                      height: 1.52,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _sectionHeader(
                    context,
                    'Milestones',
                    'View all ${campaign.milestones.length}',
                    () => _openMilestones(context),
                  ),
                  const SizedBox(height: 10),
                  ...campaign.milestones.take(2).map(_milestoneTile),
                  const SizedBox(height: 22),
                  _sectionHeader(
                    context,
                    'Latest update',
                    'All updates (${campaign.updates.length})',
                    () => _openUpdates(context),
                  ),
                  const SizedBox(height: 10),
                  if (campaign.updates.isNotEmpty)
                    _updateTile(campaign.updates.first),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
    bottomNavigationBar: _bottomActions(context),
  );

  Widget _hero(BuildContext context) => Container(
    height: 300,
    decoration: BoxDecoration(gradient: campaign.gradient),
    child: Stack(
      children: [
        Positioned(
          top: 12,
          left: 20,
          child: _roundAction(
            Icons.arrow_back_ios_new_rounded,
            () => Navigator.of(context).pop(),
          ),
        ),
        Positioned(
          top: 12,
          right: 72,
          child: _roundAction(
            Icons.share_outlined,
            () => _showShareSheet(context),
          ),
        ),
        Positioned(
          top: 12,
          right: 18,
          child: _roundAction(
            Icons.outlined_flag_rounded,
            () => _showReport(context),
          ),
        ),
        Center(
          child: Text(
            campaign.icon,
            style: const TextStyle(
              fontSize: 60,
              shadows: [
                Shadow(
                  color: Color(0x44000000),
                  offset: Offset(0, 8),
                  blurRadius: 10,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 20,
          right: 20,
          bottom: 16,
          child: Row(
            children: [
              const Icon(
                Icons.verified_outlined,
                color: AppColors.primary,
                size: 18,
              ),
              const SizedBox(width: 7),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xCE1B2355),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(
                  campaign.category,
                  style: AppTextStyles.buttonMd.copyWith(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
              const Spacer(),
              ...campaign.gallery
                  .take(2)
                  .map(
                    (emoji) => Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: _galleryThumb(context, emoji),
                    ),
                  ),
              Container(
                width: 44,
                height: 44,
                margin: const EdgeInsets.only(left: 6),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white70, width: 2),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Text(
                  '+${campaign.gallery.length - 2}',
                  style: AppTextStyles.buttonMd.copyWith(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _roundAction(IconData icon, VoidCallback onTap) => Material(
    color: Colors.white.withValues(alpha: .22),
    shape: const CircleBorder(),
    child: InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: SizedBox(
        width: 42,
        height: 42,
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    ),
  );

  Widget _galleryThumb(BuildContext context, String emoji) => Material(
    color: Colors.white.withValues(alpha: .16),
    borderRadius: BorderRadius.circular(13),
    child: InkWell(
      onTap: () => _openGallery(context, campaign.gallery.indexOf(emoji)),
      borderRadius: BorderRadius.circular(13),
      child: Container(
        width: 38,
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white70, width: 2),
          borderRadius: BorderRadius.circular(13),
        ),
        child: Text(emoji, style: const TextStyle(fontSize: 23)),
      ),
    ),
  );

  Widget _fundraiser() => Row(
    children: [
      CircleAvatar(
        radius: 23,
        backgroundColor: _avatarColor(),
        child: Text(
          _initials(campaign.fundraiser),
          style: AppTextStyles.buttonMd.copyWith(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: RichText(
          text: TextSpan(
            style: AppTextStyles.bodyMd.copyWith(
              fontSize: 15,
              color: const Color(0xFF687386),
            ),
            children: [
              const TextSpan(text: 'by '),
              TextSpan(
                text: campaign.fundraiser,
                style: AppTextStyles.buttonMd.copyWith(
                  fontSize: 15,
                  color: AppColors.textPrimary,
                ),
              ),
              if (campaign.organisation)
                TextSpan(
                  text: '  Org',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                  ),
                ),
            ],
          ),
        ),
      ),
    ],
  );

  Widget _fundingSummary() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      boxShadow: const [
        BoxShadow(
          color: Color(0x120A6038),
          blurRadius: 14,
          offset: Offset(0, 6),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              campaign.amount,
              style: AppTextStyles.h1.copyWith(
                fontSize: 29,
                color: AppColors.primary,
              ),
            ),
            const Spacer(),
            Text(
              'of ${campaign.goal}',
              style: AppTextStyles.bodyMd.copyWith(
                fontSize: 15,
                color: const Color(0xFF687386),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: LinearProgressIndicator(
            value: campaign.progress,
            minHeight: 10,
            backgroundColor: const Color(0xFFE1E4E9),
            valueColor: const AlwaysStoppedAnimation(AppColors.primary),
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            _stat('${campaign.donors}', 'Donors'),
            _stat('${(campaign.progress * 100).round()}%', 'Progress'),
            _stat('${campaign.daysLeft}', 'Days left'),
          ],
        ),
      ],
    ),
  );

  Widget _stat(String value, String label) => Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: AppTextStyles.h2.copyWith(fontSize: 22)),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.bodyMd.copyWith(
            fontSize: 14,
            color: const Color(0xFF9AA4B5),
          ),
        ),
      ],
    ),
  );
  Widget _sectionHeader(
    BuildContext context,
    String title,
    String action,
    VoidCallback onTap,
  ) => Row(
    children: [
      Expanded(
        child: Text(title, style: AppTextStyles.h2.copyWith(fontSize: 22)),
      ),
      TextButton(
        onPressed: onTap,
        child: Text(
          action,
          style: AppTextStyles.buttonMd.copyWith(
            color: AppColors.primary,
            fontSize: 15,
          ),
        ),
      ),
    ],
  );
  Widget _milestoneTile(CampaignMilestone milestone) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
    ),
    child: Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: milestone.completed
              ? AppColors.primary
              : AppColors.warning,
          child: Icon(
            milestone.completed ? Icons.check : Icons.circle,
            color: Colors.white,
            size: 18,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                milestone.title,
                style: AppTextStyles.h3.copyWith(fontSize: 17),
              ),
              const SizedBox(height: 5),
              Text(
                milestone.dateAmount,
                style: AppTextStyles.bodyMd.copyWith(
                  fontSize: 14,
                  color: const Color(0xFF9AA4B5),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
  Widget _updateTile(CampaignUpdate update) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(update.emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    update.title,
                    style: AppTextStyles.h3.copyWith(fontSize: 17),
                  ),
                  Text(
                    update.when,
                    style: AppTextStyles.bodyMd.copyWith(
                      fontSize: 14,
                      color: const Color(0xFF9AA4B5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Text(
          update.message,
          style: AppTextStyles.bodyMd.copyWith(
            fontSize: 15,
            color: const Color(0xFF687386),
            height: 1.45,
          ),
        ),
      ],
    ),
  );
  Widget _statusBanner() => Container(
    margin: const EdgeInsets.only(bottom: 18),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: campaign.status == CampaignStatus.suspended
          ? const Color(0xFFFFECEC)
          : const Color(0xFFFFF5DB),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Text(
      campaign.status == CampaignStatus.suspended
          ? 'This campaign is currently suspended while we review it.'
          : 'This campaign is closed and is no longer accepting donations.',
    ),
  );

  Widget _bottomActions(BuildContext context) => SafeArea(
    top: false,
    child: Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
      color: AppColors.background,
      child: Row(
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: OutlinedButton(
              onPressed: () => _showShareSheet(context),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.zero,
                side: const BorderSide(color: Color(0xFFCBD1DB)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: const Icon(Icons.share_outlined, color: Color(0xFF687386)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SizedBox(
              height: 60,
              child: FilledButton(
                onPressed: campaign.status == CampaignStatus.active
                    ? () => _donate(context)
                    : null,
                child: const Text('Donate Now'),
              ),
            ),
          ),
        ],
      ),
    ),
  );
  void _donate(BuildContext context) {
    if (onGuestDonate != null) {
      onGuestDonate!();
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ChooseDonationAmountScreen(
          campaignTitle: campaign.title,
          campaignEmoji: campaign.icon,
        ),
      ),
    );
  }

  void _openGallery(BuildContext context, int initialIndex) =>
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          fullscreenDialog: true,
          builder: (_) =>
              _GalleryViewer(campaign: campaign, initialIndex: initialIndex),
        ),
      );
  void _openMilestones(BuildContext context) => Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => CampaignMilestonesScreen(campaign: campaign),
    ),
  );
  void _openUpdates(BuildContext context) => Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => CampaignUpdatesScreen(campaign: campaign),
    ),
  );
  void _showReport(BuildContext context) =>
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Thanks — our team will review this campaign.'),
        ),
      );
  void _showShareSheet(BuildContext context) => showAppShareSheet(
    context,
    ShareSheetData(
      title: campaign.title,
      subtitle: '${campaign.amount} raised · ${campaign.donors} donors',
      emoji: campaign.icon,
      link: 'https://helpfundus.app/c/${campaign.id}',
      iconGradient: campaign.gradient,
    ),
  );
  Color _avatarColor() => campaign.gradient.colors.first.withValues(alpha: 1);
  String _initials(String name) =>
      name.split(' ').take(2).map((part) => part.isEmpty ? '' : part[0]).join();
}

class _CampaignHeroDelegate extends SliverPersistentHeaderDelegate {
  const _CampaignHeroDelegate({required this.child});

  final Widget child;

  @override
  double get minExtent => 300;

  @override
  double get maxExtent => 300;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => child;

  @override
  bool shouldRebuild(covariant _CampaignHeroDelegate oldDelegate) =>
      oldDelegate.child != child;
}

class _GalleryViewer extends StatefulWidget {
  const _GalleryViewer({required this.campaign, required this.initialIndex});
  final CampaignData campaign;
  final int initialIndex;
  @override
  State<_GalleryViewer> createState() => _GalleryViewerState();
}

class _GalleryViewerState extends State<_GalleryViewer> {
  late final PageController _controller = PageController(
    initialPage: widget.initialIndex,
  );
  late int _index = widget.initialIndex;
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: widget.campaign.gradient.colors.last,
    body: SafeArea(
      child: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: widget.campaign.gallery.length,
            onPageChanged: (value) => setState(() => _index = value),
            itemBuilder: (_, index) => Center(
              child: InteractiveViewer(
                child: Text(
                  widget.campaign.gallery[index],
                  style: const TextStyle(fontSize: 150),
                ),
              ),
            ),
          ),
          Positioned(
            top: 12,
            left: 18,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close, color: Colors.white),
            ),
          ),
          Positioned(
            bottom: 28,
            left: 0,
            right: 0,
            child: Text(
              'Photo ${_index + 1} of ${widget.campaign.gallery.length}',
              textAlign: TextAlign.center,
              style: AppTextStyles.buttonLg.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    ),
  );
}

@Deprecated(
  'Use CampaignMilestonesScreen from campaign_milestones_screen.dart.',
)
class LegacyCampaignMilestonesScreen extends StatelessWidget {
  const LegacyCampaignMilestonesScreen({super.key, required this.campaign});
  final CampaignData campaign;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.background,
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
        children: [
          _pageHeader(context, 'Milestones', titleFontSize: 22),
          const SizedBox(height: 14),
          _summary(),
          const SizedBox(height: 20),
          ...List.generate(
            campaign.milestones.length,
            (index) => _timelineItem(index),
          ),
        ],
      ),
    ),
  );

  Widget _summary() => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              campaign.amount,
              style: AppTextStyles.h2.copyWith(
                fontSize: 24,
                color: AppColors.primary,
              ),
            ),
            const Spacer(),
            Text(
              'of ${campaign.goal} goal',
              style: AppTextStyles.bodyMd.copyWith(
                fontSize: 14,
                color: const Color(0xFF8E99AA),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: LinearProgressIndicator(
            value: campaign.progress,
            minHeight: 7,
            backgroundColor: const Color(0xFFE1E4E9),
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${(campaign.progress * 100).round()}% funded · ${campaign.donors} donors',
          style: AppTextStyles.bodyMd.copyWith(
            fontSize: 14,
            color: const Color(0xFF687386),
          ),
        ),
      ],
    ),
  );

  Widget _timelineItem(int index) {
    final milestone = campaign.milestones[index];
    final completed = milestone.completed;
    final inProgress =
        !completed &&
        index == campaign.milestones.indexWhere((item) => !item.completed);
    final color = completed
        ? AppColors.primary
        : inProgress
        ? AppColors.warning
        : const Color(0xFFCBD1DB);
    final label = completed
        ? 'COMPLETED'
        : inProgress
        ? 'IN PROGRESS'
        : 'UPCOMING';
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 58,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: completed || inProgress
                      ? color
                      : Colors.white,
                  child: Icon(
                    completed ? Icons.check : Icons.circle_outlined,
                    color: completed || inProgress
                        ? Colors.white
                        : const Color(0xFF9AA4B5),
                    size: 19,
                  ),
                ),
                if (index != campaign.milestones.length - 1)
                  Expanded(
                    child: Container(width: 2, color: const Color(0xFFE2E5EA)),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          milestone.title,
                          style: AppTextStyles.h3.copyWith(fontSize: 15),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: .15),
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Text(
                          label,
                          style: AppTextStyles.caption.copyWith(
                            fontSize: 11,
                            color: color,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _milestoneDescription(milestone.title),
                    style: AppTextStyles.bodyMd.copyWith(
                      fontSize: 12,
                      color: const Color(0xFF687386),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        'Target: ${milestone.dateAmount.split(' · ').last}',
                        style: AppTextStyles.bodyMd.copyWith(
                          fontSize: 12,
                          color: const Color(0xFF9AA4B5),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(
                        Icons.calendar_month_outlined,
                        size: 15,
                        color: Color(0xFF9AA4B5),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        milestone.dateAmount.split(' · ').first,
                        style: AppTextStyles.bodyMd.copyWith(
                          fontSize: 12,
                          color: const Color(0xFF9AA4B5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _milestoneDescription(String title) {
    if (title.toLowerCase().contains('repair')) {
      return 'Repair roof and load-bearing walls';
    }
    if (title.toLowerCase().contains('hall')) {
      return 'Restore the primary community space';
    }
    if (title.toLowerCase().contains('library')) {
      return 'Restock books and repair play equipment';
    }
    return 'Move this campaign closer to its goal';
  }
}

@Deprecated('Use CampaignUpdatesScreen from campaign_updates_screen.dart.')
class LegacyCampaignUpdatesScreen extends StatelessWidget {
  const LegacyCampaignUpdatesScreen({super.key, required this.campaign});
  final CampaignData campaign;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.background,
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
        children: [
          _pageHeader(context, 'Campaign Updates', titleFontSize: 22),
          const SizedBox(height: 12),
          ...campaign.updates.map(_updateCard),
        ],
      ),
    ),
  );

  Widget _updateCard(CampaignUpdate update) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0C0A6038),
          blurRadius: 12,
          offset: Offset(0, 5),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Text(update.emoji, style: const TextStyle(fontSize: 22)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    update.title,
                    style: AppTextStyles.h3.copyWith(fontSize: 15),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'by ${campaign.fundraiser} · ${update.when}',
                    style: AppTextStyles.bodyMd.copyWith(
                      fontSize: 12,
                      color: const Color(0xFF9AA4B5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          update.message,
          style: AppTextStyles.bodyLg.copyWith(
            fontSize: 14,
            color: const Color(0xFF687386),
            height: 1.48,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 88,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: _attachmentGradient(),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE0E3E8)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.image_outlined,
                color: Color(0xFF8E99AA),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '1 photo attached',
                style: AppTextStyles.bodyMd.copyWith(
                  fontSize: 12,
                  color: const Color(0xFF8E99AA),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Gradient _attachmentGradient() => LinearGradient(
    colors: [
      campaign.gradient.colors.first.withValues(alpha: .22),
      campaign.gradient.colors.last.withValues(alpha: .18),
    ],
  );
}

Widget _pageHeader(
  BuildContext context,
  String title, {
  double titleFontSize = 24,
}) => Row(
  children: [
    Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: () => Navigator.of(context).pop(),
        customBorder: const CircleBorder(),
        child: const SizedBox(
          width: 52,
          height: 52,
          child: Icon(Icons.arrow_back_ios_new_rounded, size: 22),
        ),
      ),
    ),
    Expanded(
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: AppTextStyles.h2.copyWith(fontSize: titleFontSize),
      ),
    ),
    const SizedBox(width: 52),
  ],
);
