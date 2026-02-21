import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/router/app_router.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/theme/app_theme.dart';
import '../../../state/product_provider.dart';
import '../../../state/transaction_provider.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  String _query = '';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = (String key) => AppLocalizations.tr(context, key);
    final productProvider = context.watch<ProductProvider>();
    final transactionProvider = context.watch<TransactionProvider>();
    var list = productProvider.products;
    if (_query.isNotEmpty) {
      list = list
          .where((p) =>
              p.name.toLowerCase().contains(_query.toLowerCase()) ||
              (p.sku?.toLowerCase().contains(_query.toLowerCase()) ?? false))
          .toList();
    }

    return AppScaffold(
      title: t('products'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: t('search'),
                prefixIcon: const Icon(Icons.search_rounded, size: 20, color: Color(0xFF94A3B8)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          Expanded(
            child: list.isEmpty
                ? EmptyState(
                    message: t('noProductsYet'),
                    subtitle: t('tapToAdd'),
                    actionLabel: t('addProduct'),
                    onAction: () => Navigator.pushNamed(
                      context,
                      AppRouter.productForm,
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    itemCount: list.length,
                    itemBuilder: (context, i) {
                final p = list[i];
                final profit = transactionProvider.profitForProduct(p.id);
                return AppCard(
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRouter.productForm,
                    arguments: {'productId': p.id},
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p.name,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            if (p.sku != null && p.sku!.isNotEmpty)
                              Text(
                                p.sku!,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: p.isLowStock
                                        ? const Color(0xFFFEF3C7)
                                        : const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${t('currentStock')}: ${p.stockWithUnit()}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color: p.isLowStock
                                          ? const Color(0xFFB45309)
                                          : const Color(0xFF475569),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  p.sellingPrice.toStringAsFixed(0),
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF1E293B),
                                      ),
                                ),
                              ],
                            ),
                            if (profit != 0) ...[
                              const SizedBox(height: 4),
                              Text(
                                profit > 0
                                    ? '${t('profit')}: ${profit.toStringAsFixed(2)}'
                                    : '${t('loss')}: ${(-profit).toStringAsFixed(2)}',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: profit > 0 ? AppTheme.success : AppTheme.error,
                                    ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, size: 20),
                    ],
                  ),
                );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AppRouter.productForm),
        child: const Icon(Icons.add),
      ),
    );
  }
}

