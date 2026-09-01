// import 'package:flutter/material.dart';
// import '../theme/app_colors.dart';
// import '../theme/app_dimens.dart';
// import '../theme/app_text_styles.dart';

// /// One tappable pill in the debug screen navigator.
// class DevNavEntry {
//   const DevNavEntry(this.label, this.onTap, {this.selected = false});
//   final String label;
//   final VoidCallback onTap;
//   final bool selected;
// }

// class DevNavGroup {
//   const DevNavGroup(this.label, this.entries);
//   final String label;
//   final List<DevNavEntry> entries;
// }

// /// A floating "Screens" button that opens a bottom sheet grouping every
// /// screen in the app for quick demo traversal — debug/demo tooling only,
// /// not part of the real user-facing product.
// class DevScreenNav extends StatelessWidget {
//   const DevScreenNav({super.key, required this.groups});
//   final List<DevNavGroup> groups;

//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       right: 16,
//       bottom: 16,
//       child: SafeArea(
//         child: Material(
//           color: Colors.transparent,
//           child: InkWell(
//             borderRadius: BorderRadius.circular(AppRadius.pill),
//             onTap: () => _open(context),
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//               decoration: BoxDecoration(
//                 color: AppColors.textPrimary,
//                 borderRadius: BorderRadius.circular(AppRadius.pill),
//                 boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 12, offset: const Offset(0, 4))],
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Icon(Icons.dashboard_customize_outlined, size: 16, color: Colors.white),
//                   const SizedBox(width: 6),
//                   Text('Screens', style: AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void _open(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: AppColors.surface,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg))),
//       builder: (context) {
//         return SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.lg),
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Center(
//                     child: Container(
//                       width: 40,
//                       height: 4,
//                       margin: const EdgeInsets.only(bottom: AppSpacing.md),
//                       decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(99)),
//                     ),
//                   ),
//                   Text('Screen navigator — demo mode', style: AppTextStyles.h3),
//                   const SizedBox(height: AppSpacing.md),
//                   for (final group in groups) ...[
//                     Text(group.label.toUpperCase(), style: AppTextStyles.caption),
//                     const SizedBox(height: AppSpacing.xs),
//                     Wrap(
//                       spacing: AppSpacing.xs,
//                       runSpacing: AppSpacing.xs,
//                       children: group.entries.map((e) {
//                         return GestureDetector(
//                           onTap: () {
//                             Navigator.of(context).pop();
//                             e.onTap();
//                           },
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 8),
//                             decoration: BoxDecoration(
//                               color: e.selected ? AppColors.primary : AppColors.background,
//                               borderRadius: BorderRadius.circular(AppRadius.pill),
//                               border: Border.all(color: e.selected ? AppColors.primary : AppColors.border),
//                             ),
//                             child: Text(
//                               e.label,
//                               style: AppTextStyles.bodySm.copyWith(
//                                 color: e.selected ? AppColors.surface : AppColors.textSecondary,
//                                 fontWeight: e.selected ? FontWeight.w600 : FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                         );
//                       }).toList(),
//                     ),
//                     const SizedBox(height: AppSpacing.md),
//                   ],
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
