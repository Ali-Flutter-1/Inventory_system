import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/summary_card.dart';
import '../../../state/auth_provider.dart';
import '../../../state/expense_provider.dart';
import '../../../state/product_provider.dart';
import '../../../state/transaction_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String t(String key) => AppLocalizations.tr(context, key);
    final auth = context.watch<AuthProvider>();
    final productProvider = context.watch<ProductProvider>();
    final transactionProvider = context.watch<TransactionProvider>();
    final expenseProvider = context.watch<ExpenseProvider>();

    final totalProducts = productProvider.totalProductsCount;
    final lowStockCount = productProvider.lowStockProducts.length;
    final recentTransactions =
        transactionProvider.transactions.take(10).toList();
    final monthExpenses = expenseProvider.totalExpenses;

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
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.primaryContainer,
                      Colors.white,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${t('hi')}, ${auth.userName ?? 'User'}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1E293B),
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      t('dashboard'),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF64748B),
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.95,
                children: [
                  SummaryCard(
                    title: t('totalProducts'),
                    value: totalProducts.toString(),
                    icon: Icons.inventory_2_rounded,
                    onTap: () => Navigator.pushReplacementNamed(
                        context, AppRouter.products),
                  ),
                  SummaryCard(
                    title: t('lowStock'),
                    value: lowStockCount.toString(),
                    icon: Icons.warning_amber_rounded,
                    color: AppTheme.warning,
                    onTap: () => Navigator.pushReplacementNamed(
                        context, AppRouter.products),
                  ),
                  SummaryCard(
                    title: t('stockValue'),
                    value: '—',
                    icon: Icons.attach_money_rounded,
                  ),
                  SummaryCard(
                    title: t('monthExpenses'),
                    value: monthExpenses > 0
                        ? monthExpenses.toStringAsFixed(0)
                        : '—',
                    icon: Icons.receipt_long_rounded,
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                t('recentActivity'),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1E293B),
                    ),
              ),
              const SizedBox(height: 8),
              if (recentTransactions.isEmpty)
                EmptyState(
                  message: t('noActivityYet'),
                  icon: Icons.history_rounded,
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recentTransactions.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, i) {
                    final tx = recentTransactions[i];
                    final isIn = tx.type == 'IN';
                    return Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isIn
                                ? AppTheme.success.withValues(alpha: 0.12)
                                : AppTheme.warning.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            isIn
                                ? Icons.arrow_downward_rounded
                                : Icons.arrow_upward_rounded,
                            size: 18,
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
                          '${tx.type} • ${tx.quantity} • ${tx.createdAt.toString().substring(0, 10)}',
                          style: const TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton.extended(
              heroTag: 'dashboard_stock_in',
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, AppRouter.stock),
              icon: const Icon(Icons.add_rounded, size: 20),
              label: Text(t('stockIn'), style: const TextStyle(fontSize: 13, color: Colors.white)),
            ),
            const SizedBox(width: 8),
            FloatingActionButton.extended(
              heroTag: 'dashboard_stock_out',
              backgroundColor: AppTheme.gold,
              foregroundColor: Colors.white,
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, AppRouter.stock),
              icon: const Icon(Icons.remove_rounded, size: 20),
              label: Text(t('stockOut'), style: const TextStyle(fontSize: 13, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
