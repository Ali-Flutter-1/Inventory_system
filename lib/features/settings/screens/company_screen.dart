import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_text_field.dart';

class CompanyScreen extends StatefulWidget {
  const CompanyScreen({super.key});

  @override
  State<CompanyScreen> createState() => _CompanyScreenState();
}

class _CompanyScreenState extends State<CompanyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _companyNameController = TextEditingController(text: 'My Company');
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateProvinceController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _countryController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _websiteController = TextEditingController();
  final _taxIdController = TextEditingController();

  String _selectedCurrency = AppConstants.supportedCurrencyCodes.first;
  String? _logoPath;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _companyNameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateProvinceController.dispose();
    _postalCodeController.dispose();
    _countryController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    _taxIdController.dispose();
    super.dispose();
  }

  Future<void> _pickLogo(ImageSource source) async {
    final XFile? image = await _picker.pickImage(
      source: source,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );
    if (image != null && mounted) {
      setState(() => _logoPath = image.path);
    }
  }

  void _showLogoOptions(String Function(String) t) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt_rounded, color: AppTheme.primary),
              title: Text(t('camera')),
              onTap: () {
                Navigator.pop(context);
                _pickLogo(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library_rounded, color: AppTheme.primary),
              title: Text(t('gallery')),
              onTap: () {
                Navigator.pop(context);
                _pickLogo(ImageSource.gallery);
              },
            ),
            if (_logoPath != null)
              ListTile(
                leading: Icon(Icons.delete_outline_rounded, color: AppTheme.error),
                title: Text(t('removeLogo')),
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _logoPath = null);
                },
              ),
          ],
        ),
      ),
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${AppLocalizations.tr(context, 'save')} – TODO: persist'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String t(String key) => AppLocalizations.tr(context, key);
    final theme = Theme.of(context);

    return AppScaffold(
      showDrawer: false,
      title: t('company'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // —— Company profile card: logo + name ——
              Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                elevation: 0,
                shadowColor: Colors.black.withValues(alpha: 0.06),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () => _showLogoOptions(t),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppTheme.primaryContainer,
                                border: Border.all(
                                  color: AppTheme.primary.withValues(alpha: 0.2),
                                  width: 2,
                                ),
                              ),
                              child: ClipOval(
                                child: _logoPath != null
                                    ? Image.file(
                                        File(_logoPath!),
                                        fit: BoxFit.cover,
                                        width: 100,
                                        height: 100,
                                      )
                                    : Icon(
                                        Icons.business_rounded,
                                        size: 44,
                                        color: AppTheme.primary.withValues(alpha: 0.6),
                                      ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppTheme.primary,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.2),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.camera_alt_rounded,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _logoPath != null ? t('changeLogo') : t('addLogo'),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 20),
                      AppTextField(
                        controller: _companyNameController,
                        label: t('companyName'),
                        hint: 'Acme Inc.',
                        validator: (v) =>
                            v == null || v.isEmpty ? '${t('companyName')} (required)' : null,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // —— Business details card ——
              Text(
                t('businessDetails'),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                elevation: 0,
                shadowColor: Colors.black.withValues(alpha: 0.06),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppTextField(
                        controller: _addressController,
                        label: t('address'),
                        hint: '123 Main Street',
                        maxLines: 2,
                      ),
                      const SizedBox(height: 14),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: AppTextField(
                              controller: _cityController,
                              label: t('city'),
                              hint: 'City',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AppTextField(
                              controller: _stateProvinceController,
                              label: t('stateProvince'),
                              hint: 'State',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: AppTextField(
                              controller: _postalCodeController,
                              label: t('postalCode'),
                              hint: 'ZIP / Postal',
                              keyboardType: TextInputType.streetAddress,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AppTextField(
                              controller: _countryController,
                              label: t('country'),
                              hint: 'Country',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      AppTextField(
                        controller: _phoneController,
                        label: t('phone'),
                        hint: '+1 234 567 8900',
                        keyboardType: TextInputType.phone,
                        prefixIcon: Icon(
                          Icons.phone_outlined,
                          size: 20,
                          color: AppTheme.primary.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 14),
                      AppTextField(
                        controller: _emailController,
                        label: t('email'),
                        hint: 'contact@company.com',
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          size: 20,
                          color: AppTheme.primary.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 14),
                      AppTextField(
                        controller: _websiteController,
                        label: t('website'),
                        hint: 'https://www.example.com',
                        keyboardType: TextInputType.url,
                        prefixIcon: Icon(
                          Icons.language_rounded,
                          size: 20,
                          color: AppTheme.primary.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 14),
                      AppTextField(
                        controller: _taxIdController,
                        label: t('taxId'),
                        hint: 'VAT / Tax number',
                      ),
                      const SizedBox(height: 14),
                      DropdownButtonFormField<String>(
                        value: _selectedCurrency,
                        decoration: InputDecoration(
                          labelText: t('currency'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: AppTheme.primary, width: 2),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        items: AppConstants.supportedCurrencyCodes
                            .map((code) => DropdownMenuItem(
                                  value: code,
                                  child: Text(code),
                                ))
                            .toList(),
                        onChanged: (v) =>
                            setState(() => _selectedCurrency = v ?? _selectedCurrency),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              AppButton(
                label: t('save'),
                onPressed: _save,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
