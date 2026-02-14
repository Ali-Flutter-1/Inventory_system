import 'package:flutter/material.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/widgets/app_scaffold.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _lowStockAlerts = true;
  bool _dailySummary = false;
  bool _expenseReminders = true;

  @override
  Widget build(BuildContext context) {
    String t(String key) => AppLocalizations.tr(context, key);

    return AppScaffold(
      showDrawer: false,
      title: t('notifications'),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            child: Column(
              children: [
                SwitchListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  title: Text(
                    'Low stock alerts',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF1E293B),
                        ),
                  ),
                  subtitle: Text(
                    'Get notified when product stock is low',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF94A3B8),
                        ),
                  ),
                  value: _lowStockAlerts,
                  onChanged: (v) => setState(() => _lowStockAlerts = v),
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                SwitchListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  title: Text(
                    'Daily summary',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF1E293B),
                        ),
                  ),
                  subtitle: Text(
                    'Receive a daily summary of activity',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF94A3B8),
                        ),
                  ),
                  value: _dailySummary,
                  onChanged: (v) => setState(() => _dailySummary = v),
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                SwitchListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  title: Text(
                    'Expense reminders',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF1E293B),
                        ),
                  ),
                  subtitle: Text(
                    'Remind to log expenses at month end',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF94A3B8),
                        ),
                  ),
                  value: _expenseReminders,
                  onChanged: (v) => setState(() => _expenseReminders = v),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
