import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../state/expense_provider.dart';
import '../../../state/product_provider.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen>
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

  Future<void> _exportPdf(BuildContext context, String Function(String) t) async {
    final productProvider = context.read<ProductProvider>();
    final expenseProvider = context.read<ExpenseProvider>();
    final isStockReport = _tabController.index == 0;
    final dateStr = _formatPdfDate(DateTime.now());

    final pdf = pw.Document();
    if (isStockReport) {
      final products = productProvider.products;
      final totalValue = products.fold<double>(
          0, (sum, p) => sum + (p.stock * p.purchasePrice));
      final lowCount = products.where((p) => p.isLowStock).length;

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(24),
          header: (ctx) => pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 12),
            child: pw.Text(
              t('stockReport'),
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          footer: (ctx) => pw.Padding(
            padding: const pw.EdgeInsets.only(top: 12),
            child: pw.Text(
              '${t('reportGeneratedOn')} $dateStr • Page ${ctx.pageNumber}/${ctx.pagesCount}',
              style: const pw.TextStyle(fontSize: 8),
            ),
          ),
          build: (ctx) => [
            pw.Text('${t('reportGeneratedOn')} $dateStr',
                style: const pw.TextStyle(fontSize: 10)),
            pw.SizedBox(height: 16),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('${t('stockValue')}: ${totalValue.toStringAsFixed(2)}',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text('${t('lowStock')}: $lowCount'),
              ],
            ),
            pw.SizedBox(height: 20),
            if (products.isEmpty)
              pw.Text(t('noProductsYet'))
            else
              pw.Table(
                border: pw.TableBorder.all(width: 0.5),
                columnWidths: {
                  0: const pw.FlexColumnWidth(2.5),
                  1: const pw.FlexColumnWidth(1.5),
                  2: const pw.FlexColumnWidth(1),
                  3: const pw.FlexColumnWidth(1),
                  4: const pw.FlexColumnWidth(1.2),
                },
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                    children: [
                      _cell(t('products'), bold: true),
                      _cell(t('sku'), bold: true),
                      _cell(t('currentStock'), bold: true),
                      _cell(t('purchasePrice'), bold: true),
                      _cell(t('stockValue'), bold: true),
                    ],
                  ),
                  ...products.map((p) {
                    final value = p.stock * p.purchasePrice;
                    return pw.TableRow(
                      children: [
                        _cell(p.name),
                        _cell(p.sku ?? '—'),
                        _cell('${p.stock}'),
                        _cell(p.purchasePrice.toStringAsFixed(2)),
                        _cell(value.toStringAsFixed(2)),
                      ],
                    );
                  }),
                ],
              ),
            ],
          ),

      );
    } else {
      final expenses = expenseProvider.expenses;
      final total = expenseProvider.totalExpenses;

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(24),
          header: (ctx) => pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 12),
            child: pw.Text(
              t('expenseReport'),
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          footer: (ctx) => pw.Padding(
            padding: const pw.EdgeInsets.only(top: 12),
            child: pw.Text(
              '${t('reportGeneratedOn')} $dateStr • Page ${ctx.pageNumber}/${ctx.pagesCount}',
              style: const pw.TextStyle(fontSize: 8),
            ),
          ),
          build: (ctx) => [
            pw.Text('${t('reportGeneratedOn')} $dateStr',
                style: const pw.TextStyle(fontSize: 10)),
            pw.SizedBox(height: 16),
            pw.Text(
              '${t('monthExpenses')}: ${total.toStringAsFixed(2)}',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 20),
            if (expenses.isEmpty)
              pw.Text(t('noExpensesYet'))
            else
              pw.Table(
                border: pw.TableBorder.all(width: 0.5),
                columnWidths: {
                  0: const pw.FlexColumnWidth(1),
                  1: const pw.FlexColumnWidth(2.5),
                  2: const pw.FlexColumnWidth(1.2),
                  3: const pw.FlexColumnWidth(0.8),
                },
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                    children: [
                      _cell(t('date'), bold: true),
                      _cell(t('description'), bold: true),
                      _cell(t('amount'), bold: true),
                      _cell(t('category'), bold: true),
                    ],
                  ),
                  ...expenses.take(100).map((e) => pw.TableRow(
                        children: [
                          _cell('${e.date.day}/${e.date.month}/${e.date.year}'),
                          _cell(e.description),
                          _cell('${e.amount.toStringAsFixed(2)} ${e.currency}'),
                          _cell(e.category ?? '—'),
                        ],
                      )),
                ],
              ),
            ],
          ),

      );
    }

    final bytes = await pdf.save();
    final filename = isStockReport ? 'stock-report.pdf' : 'expense-report.pdf';
    if (context.mounted) {
      await Printing.sharePdf(bytes: bytes, filename: filename);
    }
  }

  static String _formatPdfDate(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  static pw.Widget _cell(String text, {bool bold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 9,
          fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = (String key) => AppLocalizations.tr(context, key);

    return AppScaffold(
      title: t('reports'),
      actions: [
        IconButton(
          icon: const Icon(Icons.picture_as_pdf_rounded),
          onPressed: () => _exportPdf(context, t),
          tooltip: t('exportPdf'),
        ),
      ],
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
                      const Icon(Icons.inventory_2_outlined, size: 18),
                      const SizedBox(width: 8),
                      Text(t('stockReport')),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.receipt_long_rounded, size: 18),
                      const SizedBox(width: 8),
                      Text(t('expenseReport')),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Tab Views ──
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                _StockReportView(),
                _ExpenseReportView(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StockReportView extends StatelessWidget {
  const _StockReportView();

  @override
  Widget build(BuildContext context) {
    final t = (String key) => AppLocalizations.tr(context, key);
    final products = context.watch<ProductProvider>().products;
    
    // Calculate totals
    final totalStockValue = products.fold(
        0.0, (sum, item) => sum + (item.stock * item.purchasePrice));
    final lowStockCount = products.where((p) => p.isLowStock).length;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // ── Summary Cards ──
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                title: t('stockValue'),
                value: totalStockValue.toStringAsFixed(0),
                icon: Icons.monetization_on_outlined,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                title: t('lowStock'),
                value: lowStockCount.toString(),
                icon: Icons.warning_amber_rounded,
                color: AppTheme.warning,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // ── Products List Header ──
        Text(
          t('products'),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),

        if (products.isEmpty)
          _buildEmptyState(t('noProductsYet'))
        else
          ...products.map((product) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.inventory_2_outlined,
                        color: AppTheme.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          if (product.sku != null)
                            Text(
                              'SKU: ${product.sku}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${t('stock')}: ${product.stock}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: product.isLowStock
                                ? AppTheme.error
                                : AppTheme.primary,
                          ),
                        ),
                        Text(
                          (product.stock * product.purchasePrice).toStringAsFixed(0),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.05),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Icon(Icons.inbox_outlined, size: 48, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpenseReportView extends StatelessWidget {
  const _ExpenseReportView();

  @override
  Widget build(BuildContext context) {
    final t = (String key) => AppLocalizations.tr(context, key);
    final expenses = context.watch<ExpenseProvider>().expenses;
    final totalExpenses = context.watch<ExpenseProvider>().totalExpenses;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // ── Summary Card ──
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppTheme.primary, Color(0xFF2B6CB0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primary.withValues(alpha: 0.3),
                offset: const Offset(0, 8),
                blurRadius: 16,
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                t('monthExpenses'),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                totalExpenses.toStringAsFixed(0),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // ── Expense List Header ──
        Text(
          t('history'),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),

        if (expenses.isEmpty)
          _buildEmptyState(t('noExpensesYet'))
        else
          ...expenses.take(50).map((expense) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppTheme.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.receipt_long,
                        color: AppTheme.error,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            expense.description,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          if (expense.employeeName != null)
                            Text(
                              expense.employeeName!,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${expense.amount.toStringAsFixed(0)} ${expense.currency}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        Text(
                          '${expense.date.day}/${expense.date.month}',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
      ],
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Icon(Icons.inbox_outlined, size: 48, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }
}
