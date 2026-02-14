import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../state/product_provider.dart';

class ProductFormScreen extends StatefulWidget {
  const ProductFormScreen({super.key, this.productId});

  final String? productId;

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  late TextEditingController _nameController;
  late TextEditingController _skuController;
  late TextEditingController _purchasePriceController;
  late TextEditingController _sellingPriceController;
  late TextEditingController _stockController;
  late TextEditingController _lowStockLimitController;
  late TextEditingController _descriptionController;
  late TextEditingController _categoryController;
  
  // State
  String? _imagePath;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _skuController = TextEditingController();
    _purchasePriceController = TextEditingController(text: '0');
    _sellingPriceController = TextEditingController(text: '0');
    _stockController = TextEditingController(text: '0');
    _lowStockLimitController = TextEditingController(text: '0');
    _descriptionController = TextEditingController();
    _categoryController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.productId != null) {
      final p = context.read<ProductProvider>().getById(widget.productId!);
      if (p != null && _nameController.text.isEmpty) {
        _nameController.text = p.name;
        _skuController.text = p.sku ?? '';
        _purchasePriceController.text = p.purchasePrice.toString();
        _sellingPriceController.text = p.sellingPrice.toString();
        _stockController.text = p.stock.toString();
        _lowStockLimitController.text = p.lowStockLimit.toString();
        _descriptionController.text = p.description ?? '';
        _categoryController.text = p.category ?? '';
        setState(() {
          _imagePath = p.imagePath;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _purchasePriceController.dispose();
    _sellingPriceController.dispose();
    _stockController.dispose();
    _lowStockLimitController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imagePath = image.path;
      });
    }
  }

  Future<void> _scanBarcode() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BarcodeScannerScreen()),
    );
    if (result != null && result is String) {
      setState(() {
        _skuController.text = result;
      });
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    
    final id = widget.productId ?? DateTime.now().millisecondsSinceEpoch.toString();
    
    final product = ProductModel(
      id: id,
      name: _nameController.text.trim(),
      sku: _skuController.text.trim().isEmpty ? null : _skuController.text.trim(),
      purchasePrice: double.tryParse(_purchasePriceController.text) ?? 0,
      sellingPrice: double.tryParse(_sellingPriceController.text) ?? 0,
      stock: int.tryParse(_stockController.text) ?? 0,
      lowStockLimit: int.tryParse(_lowStockLimitController.text) ?? 0,
      imagePath: _imagePath,
      description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
      category: _categoryController.text.trim().isEmpty ? null : _categoryController.text.trim(),
    );

    if (widget.productId != null) {
      context.read<ProductProvider>().updateProduct(product);
    } else {
      context.read<ProductProvider>().addProduct(product);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final t = (String key) => AppLocalizations.tr(context, key);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.productId != null ? t('products') : t('addProduct'), 
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)
        ),
        actions: [
          TextButton(
            onPressed: _save,
            child: Text(t('save'), style: const TextStyle(fontWeight: FontWeight.bold)),
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
              _buildImageSection(t),
              const SizedBox(height: 24),
              _buildSectionHeader(t, t('basicInformation')),
              const SizedBox(height: 12),
              AppTextField(
                controller: _nameController,
                label: t('name'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                prefixIcon: const Icon(Icons.inventory_2_outlined),
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _descriptionController,
                label: t('description'),
                maxLines: 3,
                prefixIcon: const Icon(Icons.description_outlined),
              ),
              const SizedBox(height: 16),
              AppTextField(
                 controller: _categoryController,
                 label: t('category'),
                 prefixIcon: const Icon(Icons.category_outlined),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      controller: _skuController,
                      label: t('sku'),
                      prefixIcon: const Icon(Icons.qr_code_2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _scanBarcode,
                    icon: const Icon(Icons.qr_code_scanner),
                    style: IconButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              _buildSectionHeader(t, t('pricing')),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      controller: _purchasePriceController,
                      label: t('purchasePrice'),
                      keyboardType: TextInputType.number,
                      prefixIcon: const Icon(Icons.attach_money),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AppTextField(
                      controller: _sellingPriceController,
                      label: t('sellingPrice'),
                      keyboardType: TextInputType.number,
                      prefixIcon: const Icon(Icons.sell_outlined),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              _buildSectionHeader(t, t('inventory')),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      controller: _stockController,
                      label: t('currentStock'),
                      keyboardType: TextInputType.number,
                      prefixIcon: const Icon(Icons.warehouse_outlined),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AppTextField(
                      controller: _lowStockLimitController,
                      label: t('lowStockLimit'),
                      keyboardType: TextInputType.number,
                      prefixIcon: const Icon(Icons.warning_amber_rounded),
                    ),
                  ),
                ],
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

  Widget _buildSectionHeader(String Function(String) t, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: AppTheme.primary,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildImageSection(String Function(String) t) {
    return GestureDetector(
      onTap: _pickImage,
      child: CustomPaint(
        painter: _imagePath == null ? _DottedBorderPainter(color: Colors.grey[400]!) : null,
        child: Container(
          width: double.infinity,
          height: 160,
          decoration: BoxDecoration(
            color: _imagePath == null ? Colors.grey[50] : null,
            borderRadius: BorderRadius.circular(16),
            image: _imagePath != null
                ? DecorationImage(
                    image: FileImage(File(_imagePath!)),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: _imagePath == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cloud_upload_outlined, size: 40, color: Colors.grey[400]),
                    const SizedBox(height: 8),
                    Text(
                      t('addPhoto'),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'JPG, PNG',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 11,
                      ),
                    ),
                  ],
                )
              : null,
        ),
      ),
    );
  }
}

class BarcodeScannerScreen extends StatelessWidget {
  const BarcodeScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.tr(context, 'scanBarcode'))),
      body: MobileScanner(
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            if (barcode.rawValue != null) {
              Navigator.pop(context, barcode.rawValue);
              break; // Return first detected code
            }
          }
        },
      ),
    );
  }
}

class _DottedBorderPainter extends CustomPainter {
  _DottedBorderPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const double dashWidth = 6;
    const double dashSpace = 4;
    final radius = Radius.circular(16);
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      radius,
    );

    final path = Path()..addRRect(rrect);
    final metrics = path.computeMetrics();

    for (final metric in metrics) {
      double distance = 0;
      while (distance < metric.length) {
        final next = distance + dashWidth;
        canvas.drawPath(
          metric.extractPath(distance, next.clamp(0, metric.length)),
          paint,
        );
        distance = next + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DottedBorderPainter oldDelegate) =>
      color != oldDelegate.color;
}
