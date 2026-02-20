import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../state/auth_provider.dart';
import '../../../state/expense_provider.dart';
import '../../../state/product_provider.dart';
import '../../../state/transaction_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static String _formatValue(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    }
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    String t(String key) => AppLocalizations.tr(context, key);
    final theme = Theme.of(context);
    final auth = context.watch<AuthProvider>();
    final productProvider = context.watch<ProductProvider>();
    final transactionProvider = context.watch<TransactionProvider>();
    final expenseProvider = context.watch<ExpenseProvider>();

    final totalProducts = productProvider.totalProductsCount;
    final lowStockCount = productProvider.lowStockProducts.length;
    final stockValue = productProvider.products.fold<double>(
      0,
      (sum, p) => sum + (p.purchasePrice * p.stock),
    );
    final monthExpenses = expenseProvider.totalExpenses;
    final recentTransactions =
        transactionProvider.transactions.take(8).toList();

    return AppScaffold(
      title: t('dashboard'),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // —— Welcome hero ——
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.primary,
                      AppTheme.primaryDark,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withValues(alpha: 0.35),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.waving_hand_rounded,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                t('welcomeBack'),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                auth.userName ?? 'User',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  fontSize: 20,
                                  letterSpacing: -0.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      t('overview'),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // —— KPI cards ——
              Row(
                children: [
                  Expanded(
                    child: _DashboardStatCard(
                      title: t('totalProducts'),
                      value: totalProducts.toString(),
                      icon: Icons.inventory_2_rounded,
                      color: AppTheme.primary,
                      onTap: () => Navigator.pushReplacementNamed(
                          context, AppRouter.products),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _DashboardStatCard(
                      title: t('lowStock'),
                      value: lowStockCount.toString(),
                      icon: Icons.warning_amber_rounded,
                      color: AppTheme.warning,
                      onTap: () => Navigator.pushReplacementNamed(
                          context, AppRouter.products),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _DashboardStatCard(
                      title: t('stockValue'),
                      value: stockValue > 0 ? '\$${_formatValue(stockValue)}' : '—',
                      icon: Icons.trending_up_rounded,
                      color: AppTheme.success,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _DashboardStatCard(
                      title: t('monthExpenses'),
                      value: monthExpenses > 0
                          ? '\$${_formatValue(monthExpenses)}'
                          : '—',
                      icon: Icons.receipt_long_rounded,
                      color: AppTheme.gold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // —— Quick actions ——
              Text(
                t('quickActions'),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _QuickActionChip(
                      label: t('stockIn'),
                      icon: Icons.add_rounded,
                      color: AppTheme.primary,
                      onTap: () => Navigator.pushReplacementNamed(
                          context, AppRouter.stock),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _QuickActionChip(
                      label: t('stockOut'),
                      icon: Icons.remove_rounded,
                      color: AppTheme.gold,
                      onTap: () => Navigator.pushReplacementNamed(
                          context, AppRouter.stock),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _QuickActionChip(
                      label: t('addProduct'),
                      icon: Icons.add_box_rounded,
                      color: AppTheme.success,
                      onTap: () => Navigator.pushReplacementNamed(
                          context, AppRouter.products),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // —— Recent activity ——
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    t('recentActivity'),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  if (recentTransactions.isNotEmpty)
                    TextButton(
                      onPressed: () => Navigator.pushReplacementNamed(
                          context, AppRouter.stock),
                      child: Text(
                        t('viewAll'),
                        style: TextStyle(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              if (recentTransactions.isEmpty)
                EmptyState(
                  message: t('noActivityYet'),
                  icon: Icons.history_rounded,
                )
              else
                Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  elevation: 0,
                  shadowColor: Colors.black.withValues(alpha: 0.06),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: recentTransactions.length,
                      separatorBuilder: (_, __) => Divider(
                        height: 1,
                        indent: 56,
                        endIndent: 16,
                        color: AppTheme.surfaceVariant,
                      ),
                      itemBuilder: (context, i) {
                        final tx = recentTransactions[i];
                        final isIn = tx.type == 'IN';
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          leading: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isIn
                                  ? AppTheme.success.withValues(alpha: 0.12)
                                  : AppTheme.warning.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              isIn
                                  ? Icons.arrow_downward_rounded
                                  : Icons.arrow_upward_rounded,
                              size: 20,
                              color: isIn
                                  ? AppTheme.success
                                  : AppTheme.warning,
                            ),
                          ),
                          title: Text(
                            tx.productName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          subtitle: Text(
                            '${tx.type} • ${tx.quantity} ${t('quantity')} • ${_formatTxDate(tx.createdAt, t)}',
                            style: TextStyle(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontSize: 12,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  static String _formatTxDate(DateTime d, String Function(String) t) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dDate = DateTime(d.year, d.month, d.day);
    if (dDate == today) return t('today');
    if (dDate == yesterday) return t('yesterday');
    return '${d.day}/${d.month}/${d.year}';
  }
}

class _DashboardStatCard extends StatelessWidget {
  const _DashboardStatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.onTap,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 0,
      shadowColor: Colors.black.withValues(alpha: 0.06),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: color.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(height: 14),
              Text(
                title,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1E293B),
                  fontSize: 20,
                  letterSpacing: -0.4,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionChip extends StatelessWidget {
  const _QuickActionChip({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Column(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 6),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
