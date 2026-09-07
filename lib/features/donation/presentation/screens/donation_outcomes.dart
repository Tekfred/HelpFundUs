import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class DonationSuccessScreen extends StatelessWidget {
  const DonationSuccessScreen({super.key});
  @override
  Widget build(BuildContext context) => _Outcome(
    icon: Icons.check_circle,
    color: AppColors.primary,
    title: 'Thank you for your donation!',
    message: 'Your \$25 donation is confirmed. Reference: HF-A3F8B2',
    actions: const ['View receipt', 'Share campaign', 'Return home'],
  );
}

class DonationPendingScreen extends StatelessWidget {
  const DonationPendingScreen({super.key});
  @override
  Widget build(BuildContext context) => _Outcome(
    icon: Icons.schedule,
    color: AppColors.warning,
    title: 'Payment pending',
    message: 'HF-A3F8B2 awaits confirmation. Do not submit another payment.',
    actions: const ['Refresh status', 'Contact support'],
  );
}

class DonationFailedScreen extends StatelessWidget {
  const DonationFailedScreen({super.key});
  @override
  Widget build(BuildContext context) => _Outcome(
    icon: Icons.cancel,
    color: AppColors.danger,
    title: 'Payment was not completed',
    message: 'If you were debited, contact support before retrying.',
    actions: const ['Retry payment', 'Change method', 'Contact support'],
  );
}

class DonationReceiptScreen extends StatelessWidget {
  const DonationReceiptScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Donation receipt')),
    body: const Padding(
      padding: EdgeInsets.all(20),
      child: Card(
        child: ListTile(
          title: Text('HelpFundUs receipt'),
          subtitle: Text(
            'HF-A3F8B2\nHelp rebuild our community centre\nJane Doe · \$25.73 USD · Card\nCompleted today',
          ),
          trailing: Icon(Icons.share),
        ),
      ),
    ),
  );
}

class MyDonationsScreen extends StatelessWidget {
  const MyDonationsScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('My donations')),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: const [
        ListTile(title: Text('\$147 total donated')),
        TextField(
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: 'Search donations',
          ),
        ),
        ListTile(
          title: Text('Help rebuild our community centre'),
          subtitle: Text('\$25 · Completed'),
          trailing: Icon(Icons.receipt_long),
        ),
        ListTile(
          title: Text('Clean water wells'),
          subtitle: Text('\$100 · Completed'),
          trailing: Icon(Icons.receipt_long),
        ),
      ],
    ),
  );
}

class DonationDetailScreen extends StatelessWidget {
  const DonationDetailScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Donation details')),
    body: const ListTile(
      title: Text('Help rebuild our community centre'),
      subtitle: Text('HF-A3F8B2 · \$25.73 · Card · Completed'),
    ),
  );
}

class _Outcome extends StatelessWidget {
  const _Outcome({
    required this.icon,
    required this.color,
    required this.title,
    required this.message,
    required this.actions,
  });
  final IconData icon;
  final Color color;
  final String title, message;
  final List<String> actions;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 72),
              const SizedBox(height: 20),
              Text(title, textAlign: TextAlign.center, style: AppTextStyles.h2),
              const SizedBox(height: 10),
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              ...actions.map(
                (action) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: FilledButton(onPressed: () {}, child: Text(action)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
