import 'package:flutter/material.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_scaffold.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String t(String key) => AppLocalizations.tr(context, key);
    final theme = Theme.of(context);

    return AppScaffold(
      showDrawer: false,
      title: t('termsOfService'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: SelectionArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                t('termsOfService'),
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _placeholderTerms(),
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

  static String _placeholderTerms() {
    return '''
Last updated: [Date]

1. Acceptance of Terms
By accessing or using the Inventory app ("Service"), you agree to be bound by these Terms of Service. If you do not agree, do not use the Service.

2. Description of Service
The Service provides inventory management, stock tracking, expense management, and related business tools. We reserve the right to modify or discontinue the Service at any time.

3. Account and Data
You are responsible for maintaining the confidentiality of your account and password. You are responsible for all activity under your account. You must provide accurate and complete information.

4. Acceptable Use
You agree not to use the Service for any unlawful purpose or in any way that could damage, disable, or impair the Service. You must comply with all applicable laws.

5. Subscription and Payment
Paid plans are subject to the pricing and terms displayed at the time of purchase. Fees are non-refundable unless otherwise required by law. We may change pricing with notice.

6. Intellectual Property
The Service and its original content (excluding user content) are owned by us and protected by copyright and other intellectual property laws.

7. Limitation of Liability
To the maximum extent permitted by law, the Service is provided "as is" without warranties. We shall not be liable for any indirect, incidental, or consequential damages.

8. Changes
We may update these Terms from time to time. We will notify you of material changes. Continued use of the Service after changes constitutes acceptance.

9. Contact
For questions about these Terms, contact us at the support email provided in the app or on our website.
''';
  }
}
