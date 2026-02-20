import 'package:flutter/material.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_scaffold.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String t(String key) => AppLocalizations.tr(context, key);
    final theme = Theme.of(context);

    return AppScaffold(
      showDrawer: false,
      title: t('privacyPolicy'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: SelectionArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                t('privacyPolicy'),
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _placeholderPrivacy(),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF475569),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  static String _placeholderPrivacy() {
    return '''
Last updated: [Date]

1. Information We Collect
We collect information you provide directly (account details, company and product data, expenses, transactions) and automatically (device information, usage data) to provide and improve the Service.

2. How We Use Your Information
We use your information to operate the Service, process transactions, send you relevant notifications (e.g. low stock alerts), provide support, and improve our products. We do not sell your personal data to third parties.

3. Data Storage and Security
Your data is stored securely. We use industry-standard measures to protect your information. You are responsible for keeping your login credentials secure.

4. Data Sharing
We may share data with service providers that help us operate the Service (e.g. hosting, analytics), under strict confidentiality. We may disclose information if required by law or to protect our rights and safety.

5. Your Rights
Depending on your jurisdiction, you may have rights to access, correct, delete, or export your data. You can manage your account and preferences in the app. Contact us for data requests.

6. Cookies and Similar Technologies
We may use cookies and similar technologies for authentication, preferences, and analytics. You can manage cookie settings in your device or browser.

7. Children's Privacy
The Service is not intended for users under 16. We do not knowingly collect data from children.

8. International Transfers
Your data may be processed in countries other than your own. We ensure appropriate safeguards where required by law.

9. Changes to This Policy
We may update this Privacy Policy. We will notify you of material changes via the app or email. Continued use after changes constitutes acceptance.

10. Contact Us
For privacy questions or requests, contact us at the support email provided in the app or on our website.
''';
  }
}
