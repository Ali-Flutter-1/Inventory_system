import 'package:flutter/material.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_scaffold.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // State variables for switches
  bool _lowStockAlerts = true;
  bool _dailySummary = false;
  bool _expenseReminders = true;
  bool _appUpdates = true;

  @override
  Widget build(BuildContext context) {
    String t(String key) => AppLocalizations.tr(context, key);

    return AppScaffold(
      showDrawer: false,
      title: t('notifications'),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        children: [
          _buildSectionHeader(context, t('inventory')),
          _buildCard([
            _buildSwitchTile(
              context,
              title: t('lowStockAlerts'),
              subtitle: t('lowStockAlertsDesc'),
              value: _lowStockAlerts,
              icon: Icons.inventory_2_outlined,
              iconColor: Colors.orange,
              onChanged: (v) => setState(() => _lowStockAlerts = v),
            ),
          ]),
          
          const SizedBox(height: 24),
          _buildSectionHeader(context, t('reports')),
          _buildCard([
            _buildSwitchTile(
              context,
              title: t('dailySummary'),
              subtitle: t('dailySummaryDesc'),
              value: _dailySummary,
              icon: Icons.summarize_outlined,
              iconColor: Colors.blue,
              onChanged: (v) => setState(() => _dailySummary = v),
            ),
            const Divider(height: 1, indent: 60, endIndent: 20),
            _buildSwitchTile(
              context,
              title: t('expenseReminders'),
              subtitle: t('expenseRemindersDesc'),
              value: _expenseReminders,
              icon: Icons.receipt_long_outlined,
              iconColor: Colors.purple,
              onChanged: (v) => setState(() => _expenseReminders = v),
            ),
          ]),

          const SizedBox(height: 24),
          _buildSectionHeader(context, t('general')),
          _buildCard([
            _buildSwitchTile(
              context,
              title: t('appUpdates'),
              subtitle: t('appUpdatesDesc'),
              value: _appUpdates,
              icon: Icons.system_update_outlined,
              iconColor: Colors.green,
              onChanged: (v) => setState(() => _appUpdates = v),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: const Color(0xFF64748B),
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04), // Replaced withValues(alpha: ...) for compatibility if needed, or stick to opacity
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildSwitchTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
    required Color iconColor,
  }) {
    return SwitchListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      secondary: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Color(0xFF1E293B),
          fontSize: 15,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Text(
          subtitle,
          style: const TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 13,
          ),
        ),
      ),
      activeColor: AppTheme.primary,
      value: value,
      onChanged: onChanged,
    );
  }
}
