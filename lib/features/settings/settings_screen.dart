import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../state/auth_provider.dart';
import '../../../state/locale_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const Map<String, String> _languageNames = {
    'en': 'english',
    'en_SG': 'singapore',
    'de': 'german',
    'es': 'spanish',
    'fr': 'french',
    'ar': 'arabic',
    'hi': 'hindi',
    'pt': 'portuguese',
    'it': 'italian',
    'ru': 'russian',
    'ja': 'japanese',
    'tr': 'turkish',
    'ms': 'malay',
  };

  @override
  Widget build(BuildContext context) {
    String t(String key) => AppLocalizations.tr(context, key);
    final localeProvider = context.watch<LocaleProvider>();
    final currentLocaleKey =
        AppLocalizations.localeToNameKey(localeProvider.locale);

    return AppScaffold(
      title: t('settings'),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          _SectionHeader(title: t('company')),
          _SettingsTile(
            icon: Icons.business_rounded,
            title: t('company'),
            subtitle: 'Company name • Default currency',
            onTap: () => Navigator.pushNamed(context, AppRouter.settingsCompany),
          ),
          const SizedBox(height: 10),
          _SectionHeader(title: t('subscription')),
          _SettingsTile(
            icon: Icons.credit_card_rounded,
            title: t('subscription'),
            subtitle: 'Free plan • Upgrade',
            onTap: () => Navigator.pushNamed(context, AppRouter.settingsSubscription),
          ),
          const SizedBox(height: 10),
          _SectionHeader(title: t('notifications')),
          _SettingsTile(
            icon: Icons.notifications_rounded,
            title: t('notifications'),
            subtitle: 'Low stock alerts',
            onTap: () => Navigator.pushNamed(context, AppRouter.settingsNotifications),
          ),
          const SizedBox(height: 10),
          _SectionHeader(title: t('language')),
          _SettingsTile(
            icon: Icons.language_rounded,
            title: t('language'),
            subtitle: t(_languageNames[currentLocaleKey] ?? 'english'),
            onTap: () => _showLanguageSheet(context, localeProvider, t),
          ),
          const SizedBox(height: 10),
          _SectionHeader(title: t('account')),
          _SettingsTile(
            icon: Icons.person_rounded,
            title: t('account'),
            subtitle: 'Email • Change password',
            onTap: () => Navigator.pushNamed(context, AppRouter.settingsAccount),
          ),
          const SizedBox(height: 10),
          _SectionHeader(title: t('legal')),
          _SettingsTile(
            icon: Icons.description_rounded,
            title: t('termsOfService'),
            subtitle: t('termsOfService'),
            onTap: () => Navigator.pushNamed(context, AppRouter.terms),
          ),
          _SettingsTile(
            icon: Icons.privacy_tip_rounded,
            title: t('privacyPolicy'),
            subtitle: t('privacyPolicy'),
            onTap: () => Navigator.pushNamed(context, AppRouter.privacy),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.logout_rounded,
                    color: Theme.of(context).colorScheme.error,
                    size: 20,
                  ),
                ),
                title: Text(
                  t('logOut'),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 14,
                  ),
                ),
                onTap: () async {
                  await context.read<AuthProvider>().signOut();
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRouter.login,
                      (r) => false,
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageSheet(
    BuildContext context,
    LocaleProvider localeProvider,
    String Function(String) t,
  ) {
    final maxSheetHeight = MediaQuery.of(context).size.height * 0.7;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: maxSheetHeight,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  t('language'),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: AppLocalizations.supportedLocales.length,
                  itemBuilder: (context, index) {
                    final locale =
                        AppLocalizations.supportedLocales[index];
                    final nameKey =
                        _languageNames[AppLocalizations.localeToNameKey(locale)] ??
                            'english';
                    final isSelected =
                        localeProvider.locale.languageCode == locale.languageCode &&
                            localeProvider.locale.countryCode == locale.countryCode;
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      title: Text(
                        t(nameKey),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle_rounded,
                              color: AppTheme.primary)
                          : null,
                      onTap: () {
                        localeProvider.setLocale(locale);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: const Color(0xFF94A3B8),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: AppTheme.primary),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
              fontSize: 14,
            ),
          ),
          subtitle: subtitle != null
              ? Text(
                  subtitle!,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 12,
                  ),
                )
              : null,
          trailing: const Icon(Icons.chevron_right_rounded, size: 20,
              color: Color(0xFF94A3B8)),
          onTap: onTap,
        ),
      ),
    );
  }
}
