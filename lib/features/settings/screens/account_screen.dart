import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../state/auth_provider.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String t(String key) => AppLocalizations.tr(context, key);
    final auth = context.watch<AuthProvider>();

    return AppScaffold(
      showDrawer: false,
      title: t('account'),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            child: Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.email_rounded,
                      size: 20,
                      color: AppTheme.primary,
                    ),
                  ),
                  title: Text(
                    t('email'),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: const Color(0xFF94A3B8),
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  subtitle: Text(
                    auth.userName != null
                        ? '${auth.userName!.toLowerCase().replaceAll(' ', '.')}@example.com'
                        : 'Not signed in with email',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF1E293B),
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.lock_rounded,
                      size: 20,
                      color: AppTheme.primary,
                    ),
                  ),
                  title: Text(
                    t('changePassword'),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1E293B),
                        ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: Color(0xFF94A3B8),
                  ),
                  onTap: () => Navigator.pushNamed(context, AppRouter.settingsChangePassword),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Delete Account Button
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            child: ListTile(
              onTap: () => _showDeleteConfirmation(context, t),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.delete_forever_rounded,
                  color: AppTheme.error,
                  size: 20,
                ),
              ),
              title: Text(
                t('deleteAccount'),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.error,
                  fontSize: 14,
                ),
              ),
              trailing: const Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: Color(0xFF94A3B8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String Function(String) t) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t('deleteAccount')),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Text('${t('deleteAccountConfirmation')}\n\n${t('deleteAccountWarning')}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              t('cancel'),
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement actual deletion logic here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Account deletion requested'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Text(
              t('deleteAccountAction'),
              style: const TextStyle(
                color: AppTheme.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
