import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../state/expense_provider.dart';
import '../../../state/product_provider.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = (String key) => AppLocalizations.tr(context, key);
    final products = context.watch<ProductProvider>().products;
    final expenses = context.watch<ExpenseProvider>().expenses;
    final totalExpenses = context.watch<ExpenseProvider>().totalExpenses;

    return AppScaffold(
      title: t('reports'),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              tabs: [
                Tab(text: t('stockReport')),
                Tab(text: t('expenseReport')),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  ListView(
                    padding: const EdgeInsets.all(12),
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                t('stockReport'),
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              if (products.isEmpty)
                                Text(
                                  t('noProductsYet'),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                )
                              else
                                Table(
                                  columnWidths: const {
                                    0: FlexColumnWidth(2),
                                    1: FlexColumnWidth(1),
                                    2: FlexColumnWidth(1),
                                  },
                                  children: [
                                    TableRow(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 6),
                                          child: Text(
                                            t('products'),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 6),
                                          child: Text(
                                            t('currentStock'),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 6),
                                          child: Text(
                                            t('stockValue'),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13),
                                          ),
                                        ),
                                      ],
                                    ),
                                    ...products.map(
                                      (p) => TableRow(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 6),
                                            child: Text(p.name, style: const TextStyle(fontSize: 13)),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 6),
                                            child: Text('${p.stock}', style: const TextStyle(fontSize: 13)),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 6),
                                            child: Text(
                                              (p.stock * p.purchasePrice)
                                                  .toStringAsFixed(0),
                                              style: const TextStyle(fontSize: 13),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  ListView(
                    padding: const EdgeInsets.all(12),
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                t('expenseReport'),
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${t('monthExpenses')}: ${totalExpenses.toStringAsFixed(0)}',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              if (expenses.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                ...expenses.take(20).map(
                                      (e) => ListTile(
                                        title: Text(e.description),
                                        subtitle: Text(e.employeeName ?? '—'),
                                        trailing: Text(
                                          '${e.amount.toStringAsFixed(0)} ${e.currency}',
                                        ),
                                      ),
                                    ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
