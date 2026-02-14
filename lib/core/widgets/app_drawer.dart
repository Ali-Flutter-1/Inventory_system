import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../router/app_router.dart';
import '../../state/auth_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    String t(String key) => AppLocalizations.tr(context, key);

    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 14,
              left: 14,
              right: 14,
              bottom: 14,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.primary,
                  AppTheme.primaryDark,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.inventory_2_rounded,
                    size: 22,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  t('appName'),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  context.watch<AuthProvider>().userName ?? '',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          _DrawerTile(
            icon: Icons.dashboard_rounded,
            label: t('dashboard'),
            route: AppRouter.dashboard,
          ),
          _DrawerTile(
            icon: Icons.inventory_2_rounded,
            label: t('products'),
            route: AppRouter.products,
          ),
          _DrawerTile(
            icon: Icons.swap_horiz_rounded,
            label: t('stock'),
            route: AppRouter.stock,
          ),
          _DrawerTile(
            icon: Icons.people_rounded,
            label: t('employees'),
            route: AppRouter.employees,
          ),
          _DrawerTile(
            icon: Icons.receipt_long_rounded,
            label: t('expenses'),
            route: AppRouter.expenses,
          ),
          _DrawerTile(
            icon: Icons.assessment_rounded,
            label: t('reports'),
            route: AppRouter.reports,
          ),
          const Divider(height: 12, indent: 14, endIndent: 14),
          _DrawerTile(
            icon: Icons.settings_rounded,
            label: t('settings'),
            route: AppRouter.settings,
          ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
            leading: Icon(Icons.logout_rounded, size: 20, color: Theme.of(context).colorScheme.error),
            title: Text(
              t('logOut'),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            onTap: () async {
              Navigator.pop(context);
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
        ],
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  const _DrawerTile({
    required this.icon,
    required this.label,
    required this.route,
  });

  final IconData icon;
  final String label;
  final String route;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      leading: Icon(icon, size: 18, color: const Color(0xFF475569)),
      title: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 13,
          color: Color(0xFF1E293B),
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, route);
      },
    );
  }
}
