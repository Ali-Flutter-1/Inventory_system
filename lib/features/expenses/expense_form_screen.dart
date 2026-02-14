import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../state/employee_provider.dart';
import '../../../state/expense_provider.dart';

const List<String> _paymentMethods = [
  'Cash',
  'Bank Transfer',
  'Credit Card',
  'Debit Card',
  'Cheque',
  'Online Payment',
];

class ExpenseFormScreen extends StatefulWidget {
  const ExpenseFormScreen({super.key, this.expenseId});

  final String? expenseId;

  @override
  State<ExpenseFormScreen> createState() => _ExpenseFormScreenState();
}

class _ExpenseFormScreenState extends State<ExpenseFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late TextEditingController _amountController;
  late TextEditingController _descriptionController;
  late TextEditingController _categoryController;
  late TextEditingController _notesController;
  late TextEditingController _dateController;

  // State
  String _currency = AppConstants.supportedCurrencyCodes.first;
  String? _selectedEmployeeId;
  String? _selectedPaymentMethod;
  DateTime _date = DateTime.now();
  String? _receiptImagePath;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _descriptionController = TextEditingController();
    _categoryController = TextEditingController();
    _notesController = TextEditingController();
    _dateController = TextEditingController(text: _formatDate(_date));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.expenseId != null) {
      final e = context.read<ExpenseProvider>().getById(widget.expenseId!);
      if (e != null && _amountController.text.isEmpty) {
        _amountController.text = e.amount.toString();
        _descriptionController.text = e.description;
        _categoryController.text = e.category ?? '';
        _notesController.text = e.notes ?? '';
        _currency = e.currency;
        _selectedEmployeeId = e.employeeId;
        _selectedPaymentMethod = e.paymentMethod;
        _date = e.date;
        _dateController.text = _formatDate(_date);
        setState(() {
          _receiptImagePath = e.receiptImagePath;
        });
      }
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _notesController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _date = picked;
        _dateController.text = _formatDate(picked);
      });
    }
  }

  Future<void> _pickReceipt() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: Text(AppLocalizations.tr(context, 'camera')),
                onTap: () => Navigator.pop(ctx, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: Text(AppLocalizations.tr(context, 'gallery')),
                onTap: () => Navigator.pop(ctx, ImageSource.gallery),
              ),
            ],
          ),
        ),
      ),
    );
    if (source == null) return;
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _receiptImagePath = image.path;
      });
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final amount = double.tryParse(_amountController.text) ?? 0;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid amount')),
      );
      return;
    }
    final employees = context.read<EmployeeProvider>().employees;
    EmployeeModel? emp;
    if (_selectedEmployeeId != null) {
      try {
        emp = employees.firstWhere((x) => x.id == _selectedEmployeeId);
      } catch (_) {}
    }
    final id =
        widget.expenseId ?? DateTime.now().millisecondsSinceEpoch.toString();
    final expense = ExpenseModel(
      id: id,
      amount: amount,
      currency: _currency,
      description: _descriptionController.text.trim(),
      employeeId: _selectedEmployeeId,
      employeeName: emp?.name,
      category: _categoryController.text.trim().isEmpty
          ? null
          : _categoryController.text.trim(),
      date: _date,
      paymentMethod: _selectedPaymentMethod,
      receiptImagePath: _receiptImagePath,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );
    if (widget.expenseId != null) {
      context.read<ExpenseProvider>().updateExpense(expense);
    } else {
      context.read<ExpenseProvider>().addExpense(expense);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final t = (String key) => AppLocalizations.tr(context, key);
    final employees = context.watch<EmployeeProvider>().employees;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.expenseId != null ? t('expenses') : t('addExpense'),
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: _save,
            child: Text(t('save'),
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Amount Hero ──
              _buildAmountHero(t),
              const SizedBox(height: 24),

              // ── Expense Details ──
              _buildSectionHeader(t('expenseDetails')),
              const SizedBox(height: 12),
              AppTextField(
                controller: _descriptionController,
                label: t('description'),
                prefixIcon: const Icon(Icons.short_text),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _categoryController,
                label: t('category'),
                prefixIcon: const Icon(Icons.category_outlined),
              ),

              const SizedBox(height: 24),

              // ── Payment Info ──
              _buildSectionHeader(t('paymentInfo')),
              const SizedBox(height: 12),
              _buildDropdown<String>(
                value: _selectedPaymentMethod,
                label: t('paymentMethod'),
                icon: Icons.payment_outlined,
                items: _paymentMethods
                    .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedPaymentMethod = v),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _pickDate,
                child: AbsorbPointer(
                  child: AppTextField(
                    controller: _dateController,
                    label: t('date'),
                    prefixIcon: const Icon(Icons.calendar_today_outlined),
                    suffixIcon:
                        Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildDropdown<String>(
                value: _selectedEmployeeId,
                label: t('assignedTo'),
                icon: Icons.person_outline,
                items: [
                  const DropdownMenuItem<String>(
                    value: null,
                    child: Text('—'),
                  ),
                  ...employees.map(
                    (e) => DropdownMenuItem(value: e.id, child: Text(e.name)),
                  ),
                ],
                onChanged: (v) => setState(() => _selectedEmployeeId = v),
              ),

              const SizedBox(height: 24),

              // ── Receipt ──
              _buildSectionHeader(t('receipt')),
              const SizedBox(height: 12),
              _buildReceiptSection(t),

              const SizedBox(height: 24),

              // ── Additional Notes ──
              _buildSectionHeader(t('additional')),
              const SizedBox(height: 12),
              AppTextField(
                controller: _notesController,
                label: t('notes'),
                maxLines: 3,
                prefixIcon: const Icon(Icons.notes_outlined),
              ),

              const SizedBox(height: 32),
              AppButton(
                label: t('save'),
                onPressed: _save,
                expand: true,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppTheme.primary,
            fontWeight: FontWeight.bold,
          ),
    );
  }

  // ──────────────────────────────────────────
  // Simple Amount Section
  // ──────────────────────────────────────────
  Widget _buildAmountHero(String Function(String) t) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t('amount'),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              // Currency dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _currency,
                    isDense: true,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    borderRadius: BorderRadius.circular(12),
                    items: AppConstants.supportedCurrencyCodes
                        .map((c) => DropdownMenuItem(
                              value: c,
                              child: Text(
                                c,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) setState(() => _currency = v);
                    },
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Amount field
              Expanded(
                child: TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
                  decoration: InputDecoration(
                    hintText: '0.00',
                    hintStyle: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[300],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          color: AppTheme.primary, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Required' : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown<T>({
    required T? value,
    required String label,
    required IconData icon,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.primary, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      items: items,
      onChanged: onChanged,
    );
  }

  Widget _buildReceiptSection(String Function(String) t) {
    return GestureDetector(
      onTap: _pickReceipt,
      child: Container(
        width: double.infinity,
        height: _receiptImagePath != null ? 180 : 100,
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.grey[300]!,
          ),
          image: _receiptImagePath != null
              ? DecorationImage(
                  image: FileImage(File(_receiptImagePath!)),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: _receiptImagePath == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long_outlined,
                      size: 32, color: Colors.grey[400]),
                  const SizedBox(height: 6),
                  Text(
                    t('attachReceipt'),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              )
            : Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.black54,
                    child: IconButton(
                      icon: const Icon(Icons.close,
                          size: 14, color: Colors.white),
                      padding: EdgeInsets.zero,
                      onPressed: () =>
                          setState(() => _receiptImagePath = null),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
