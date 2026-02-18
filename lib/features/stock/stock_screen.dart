import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../state/product_provider.dart';
import '../../../state/transaction_provider.dart';

class StockScreen extends StatefulWidget {
  const StockScreen({super.key});

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = (String key) => AppLocalizations.tr(context, key);

    return AppScaffold(
      title: t('stock'),
      body: Column(
        children: [
          // ── Custom Tab Bar ──
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppTheme.primaryContainer,
              borderRadius: BorderRadius.circular(14),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(11),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelColor: AppTheme.primary,
              unselectedLabelColor: AppTheme.accent,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.arrow_downward_rounded, size: 16),
                      const SizedBox(width: 6),
                      Text(t('stockIn')),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.arrow_upward_rounded, size: 16),
                      const SizedBox(width: 6),
                      Text(t('stockOut')),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                _StockForm(type: 'IN'),
                _StockForm(type: 'OUT'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StockForm extends StatefulWidget {
  const _StockForm({required this.type});

  final String type;

  @override
  State<_StockForm> createState() => _StockFormState();
}

class _StockFormState extends State<_StockForm> {
  final _quantityController = TextEditingController(text: '1');
  final _referenceController = TextEditingController();
  final _notesController = TextEditingController();
  String? _selectedProductId;

  @override
  void dispose() {
    _quantityController.dispose();
    _referenceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_selectedProductId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select a product')),
      );
      return;
    }
    final qty = int.tryParse(_quantityController.text) ?? 0;
    if (qty <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter quantity')),
      );
      return;
    }
    final productProvider = context.read<ProductProvider>();
    final product = productProvider.getById(_selectedProductId!);
    if (product == null) return;
    if (widget.type == 'OUT' && product.stock < qty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Insufficient stock')),
      );
      return;
    }
    final newStock =
        widget.type == 'IN' ? product.stock + qty : product.stock - qty;
    productProvider.updateProduct(ProductModel(
      id: product.id,
      name: product.name,
      sku: product.sku,
      purchasePrice: product.purchasePrice,
      sellingPrice: product.sellingPrice,
      stock: newStock,
      lowStockLimit: product.lowStockLimit,
      imagePath: product.imagePath,
      description: product.description,
      category: product.category,
    ));
    context.read<TransactionProvider>().addTransaction(TransactionModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          productId: product.id,
          productName: product.name,
          type: widget.type,
          quantity: qty,
          reference: _referenceController.text.isEmpty
              ? null
              : _referenceController.text,
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
          createdAt: DateTime.now(),
        ));

    // Reset
    _quantityController.text = '1';
    _referenceController.clear();
    _notesController.clear();
    _selectedProductId = null;
    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              widget.type == 'IN'
                  ? Icons.arrow_downward_rounded
                  : Icons.arrow_upward_rounded,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text('Stock ${widget.type} recorded successfully'),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor:
            widget.type == 'IN' ? AppTheme.success : AppTheme.warning,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = (String key) => AppLocalizations.tr(context, key);
    final products = context.watch<ProductProvider>().products;
    final isIn = widget.type == 'IN';

    // Selected product info
    ProductModel? selectedProduct;
    if (_selectedProductId != null) {
      selectedProduct = context.read<ProductProvider>().getById(_selectedProductId!);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Select Product ──
          _buildSectionHeader(
            context,
            isIn ? t('selectProductToReceive') : t('selectProductToIssue'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _selectedProductId,
            decoration: InputDecoration(
              labelText: t('products'),
              prefixIcon: const Icon(Icons.inventory_2_outlined),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: AppTheme.primary, width: 2),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 12),
            ),
            items: products
                .map((p) => DropdownMenuItem(
                      value: p.id,
                      child: Text('${p.name} (${p.stock})'),
                    ))
                .toList(),
            onChanged: (v) => setState(() => _selectedProductId = v),
          ),

          // ── Product Info Card ──
          if (selectedProduct != null) ...[
            const SizedBox(height: 12),
            _buildProductInfoCard(context, selectedProduct, t),
          ],

          const SizedBox(height: 24),

          // ── Quantity ──
          _buildSectionHeader(context, t('quantityDetails')),
          const SizedBox(height: 12),
          Row(
            children: [
              // Quick buttons
              _buildQuickQtyButton('-', () {
                final current =
                    int.tryParse(_quantityController.text) ?? 1;
                if (current > 1) {
                  setState(() => _quantityController.text =
                      (current - 1).toString());
                }
              }),
              const SizedBox(width: 12),
              Expanded(
                child: AppTextField(
                  controller: _quantityController,
                  label: t('quantity'),
                  keyboardType: TextInputType.number,
                  prefixIcon: const Icon(Icons.numbers),
                ),
              ),
              const SizedBox(width: 12),
              _buildQuickQtyButton('+', () {
                final current =
                    int.tryParse(_quantityController.text) ?? 0;
                setState(() => _quantityController.text =
                    (current + 1).toString());
              }),
            ],
          ),

          const SizedBox(height: 24),

          // ── Reference & Notes ──
          _buildSectionHeader(context, t('additional')),
          const SizedBox(height: 12),
          AppTextField(
            controller: _referenceController,
            label: t('reference'),
            prefixIcon: const Icon(Icons.tag),
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _notesController,
            label: t('notes'),
            maxLines: 2,
            prefixIcon: const Icon(Icons.notes_outlined),
          ),

          const SizedBox(height: 32),

          // ── Submit Button ──
          AppButton(
            label: isIn ? t('confirmStockIn') : t('confirmStockOut'),
            onPressed: _submit,
            expand: true,
          ),

          const SizedBox(height: 24),

          // ── Recent Transactions ──
          _buildRecentTransactions(context, t),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppTheme.primary,
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildProductInfoCard(
      BuildContext context, ProductModel product, String Function(String) t) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          // Product image or placeholder
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppTheme.primaryContainer,
              borderRadius: BorderRadius.circular(10),
              image: product.imagePath != null
                  ? DecorationImage(
                      image: FileImage(File(product.imagePath!)),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: product.imagePath == null
                ? Icon(Icons.inventory_2_outlined,
                    color: AppTheme.primary.withValues(alpha: 0.4), size: 22)
                : null,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                if (product.sku != null)
                  Text(
                    'SKU: ${product.sku}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
          ),
          // Stock info
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                t('currentStock'),
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(fontSize: 10),
              ),
              const SizedBox(height: 2),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: product.isLowStock
                      ? AppTheme.error.withValues(alpha: 0.1)
                      : AppTheme.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${product.stock}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color:
                        product.isLowStock ? AppTheme.error : AppTheme.success,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickQtyButton(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppTheme.primaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppTheme.primary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentTransactions(
      BuildContext context, String Function(String) t) {
    final transactions = context
        .watch<TransactionProvider>()
        .transactions
        .where((tx) => tx.type == widget.type)
        .take(5)
        .toList();

    if (transactions.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t('recentActivity'),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 10),
        ...transactions.map((tx) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: tx.type == 'IN'
                          ? AppTheme.success.withValues(alpha: 0.1)
                          : AppTheme.warning.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      tx.type == 'IN'
                          ? Icons.arrow_downward_rounded
                          : Icons.arrow_upward_rounded,
                      size: 18,
                      color: tx.type == 'IN'
                          ? AppTheme.success
                          : AppTheme.warning,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tx.productName,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '${tx.createdAt.day.toString().padLeft(2, '0')} ${_monthName(tx.createdAt.month)} ${tx.createdAt.year}  •  ${tx.createdAt.hour.toString().padLeft(2, '0')}:${tx.createdAt.minute.toString().padLeft(2, '0')}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${tx.type == 'IN' ? '+' : '-'}${tx.quantity}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: tx.type == 'IN'
                          ? AppTheme.success
                          : AppTheme.warning,
                    ),
                  ),
                ],
              ),
            )),
      ],
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
