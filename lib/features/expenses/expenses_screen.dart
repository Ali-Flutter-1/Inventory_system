import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../state/expense_provider.dart';

class ExpensesScreen extends StatelessWidget {
  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = (String key) => AppLocalizations.tr(context, key);
    final expenses = context.watch<ExpenseProvider>().expenses;

    return AppScaffold(
      title: t('expenses'),
      body: expenses.isEmpty
          ? EmptyState(
              message: t('noExpensesYet'),
              subtitle: t('tapToAdd'),
              actionLabel: t('addExpense'),
              onAction: () =>
                  Navigator.pushNamed(context, AppRouter.expenseForm),
            )
          : ListView.builder(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: expenses.length,
              itemBuilder: (context, i) {
                final e = expenses[i];
                return _ExpenseCard(expense: e);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.pushNamed(context, AppRouter.expenseForm),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ExpenseCard extends StatelessWidget {
  const _ExpenseCard({required this.expense});

  final ExpenseModel expense;

  IconData _categoryIcon(String? category) {
    switch (category) {
      case 'Office Supplies':
        return Icons.edit_outlined;
      case 'Travel':
        return Icons.flight_outlined;
      case 'Utilities':
        return Icons.bolt_outlined;
      case 'Rent':
        return Icons.home_outlined;
      case 'Salary':
        return Icons.people_outline;
      case 'Marketing':
        return Icons.campaign_outlined;
      case 'Maintenance':
        return Icons.build_outlined;
      case 'Food & Beverages':
        return Icons.restaurant_outlined;
      case 'Transportation':
        return Icons.directions_car_outlined;
      default:
        return Icons.receipt_outlined;
    }
  }

  Color _categoryColor(String? category) {
    switch (category) {
      case 'Office Supplies':
        return const Color(0xFF6366F1);
      case 'Travel':
        return const Color(0xFF0EA5E9);
      case 'Utilities':
        return const Color(0xFFF59E0B);
      case 'Rent':
        return const Color(0xFFEF4444);
      case 'Salary':
        return const Color(0xFF8B5CF6);
      case 'Marketing':
        return const Color(0xFFEC4899);
      case 'Maintenance':
        return const Color(0xFF14B8A6);
      case 'Food & Beverages':
        return const Color(0xFFF97316);
      case 'Transportation':
        return const Color(0xFF06B6D4);
      default:
        return AppTheme.accent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _categoryColor(expense.category);
    final dateStr =
        '${expense.date.day.toString().padLeft(2, '0')} ${_monthName(expense.date.month)} ${expense.date.year}';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => Navigator.pushNamed(
          context,
          AppRouter.expenseForm,
          arguments: {'expenseId': expense.id},
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Category icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(_categoryIcon(expense.category),
                    color: color, size: 22),
              ),
              const SizedBox(width: 14),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      expense.description,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        if (expense.category != null) ...[
                          Text(
                            expense.category!,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: color),
                          ),
                          const Text(' · ',
                              style: TextStyle(color: Colors.grey)),
                        ],
                        Text(
                          dateStr,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    if (expense.employeeName != null) ...[
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(Icons.person_outline,
                              size: 12, color: Colors.grey[400]),
                          const SizedBox(width: 3),
                          Text(
                            expense.employeeName!,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(fontSize: 11),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Amount
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${expense.amount.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primary,
                        ),
                  ),
                  Text(
                    expense.currency,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(fontSize: 10),
                  ),
                  if (expense.isRecurring)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Icon(Icons.repeat,
                          size: 14, color: Colors.grey[400]),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return months[month - 1];
  }
}
