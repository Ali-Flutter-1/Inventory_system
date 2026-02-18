import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../state/employee_provider.dart';

class EmployeeFormScreen extends StatefulWidget {
  const EmployeeFormScreen({super.key, this.employeeId});

  final String? employeeId;

  @override
  State<EmployeeFormScreen> createState() => _EmployeeFormScreenState();
}

class _EmployeeFormScreenState extends State<EmployeeFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late TextEditingController _nameController;
  late TextEditingController _employeeIdController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _departmentController;
  late TextEditingController _positionController;
  late TextEditingController _salaryController;
  late TextEditingController _joiningDateController;
  bool _isActive = true;

  // State
  String? _profileImagePath;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _employeeIdController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _departmentController = TextEditingController();
    _positionController = TextEditingController();
    _salaryController = TextEditingController(text: '0');
    _joiningDateController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.employeeId != null) {
      final e = context.read<EmployeeProvider>().getById(widget.employeeId!);
      if (e != null && _nameController.text.isEmpty) {
        _nameController.text = e.name;
        _employeeIdController.text = e.employeeId ?? '';
        _emailController.text = e.email ?? '';
        _phoneController.text = e.phone ?? '';
        _departmentController.text = e.department ?? '';
        _positionController.text = e.position ?? '';
        _salaryController.text = e.salary?.toString() ?? '0';
        _joiningDateController.text = e.joiningDate ?? '';
        _isActive = e.isActive;
        setState(() {
          _profileImagePath = e.profileImagePath;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _employeeIdController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _departmentController.dispose();
    _positionController.dispose();
    _salaryController.dispose();
    _joiningDateController.dispose();
    super.dispose();
  }

  Future<void> _pickProfileImage() async {
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
        _profileImagePath = image.path;
      });
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        _joiningDateController.text =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final id =
        widget.employeeId ?? DateTime.now().millisecondsSinceEpoch.toString();

    final emp = EmployeeModel(
      id: id,
      name: _nameController.text.trim(),
      employeeId: _employeeIdController.text.trim().isEmpty
          ? null
          : _employeeIdController.text.trim(),
      email:
          _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
      phone:
          _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
      department: _departmentController.text.trim().isEmpty
          ? null
          : _departmentController.text.trim(),
      position: _positionController.text.trim().isEmpty
          ? null
          : _positionController.text.trim(),
      salary: double.tryParse(_salaryController.text),
      joiningDate: _joiningDateController.text.trim().isEmpty
          ? null
          : _joiningDateController.text.trim(),
      profileImagePath: _profileImagePath,
      isActive: _isActive,
    );

    if (widget.employeeId != null) {
      context.read<EmployeeProvider>().updateEmployee(emp);
    } else {
      context.read<EmployeeProvider>().addEmployee(emp);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final t = (String key) => AppLocalizations.tr(context, key);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.employeeId != null ? t('employees') : t('addEmployee'),
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
              // ── Profile Image ──
              _buildProfileImageSection(),
              const SizedBox(height: 24),

              // ── Personal Info ──
              _buildSectionHeader(t('personalInfo')),
              const SizedBox(height: 12),
              AppTextField(
                controller: _nameController,
                label: t('name'),
                prefixIcon: const Icon(Icons.person_outline),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _emailController,
                label: t('email'),
                prefixIcon: const Icon(Icons.email_outlined),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _phoneController,
                label: t('phone'),
                prefixIcon: const Icon(Icons.phone_outlined),
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 24),

              // ── Work Details ──
              _buildSectionHeader(t('workDetails')),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      controller: _employeeIdController,
                      label: t('employeeId'),
                      prefixIcon: const Icon(Icons.badge_outlined),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AppTextField(
                      controller: _positionController,
                      label: t('position'),
                      prefixIcon: const Icon(Icons.work_outline),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _departmentController,
                label: t('department'),
                prefixIcon: const Icon(Icons.business_outlined),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _pickDate,
                child: AbsorbPointer(
                  child: AppTextField(
                    controller: _joiningDateController,
                    label: t('joiningDate'),
                    prefixIcon: const Icon(Icons.calendar_today_outlined),
                    suffixIcon: Icon(Icons.arrow_drop_down,
                        color: Colors.grey[600]),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ── Compensation ──
              _buildSectionHeader(t('compensation')),
              const SizedBox(height: 12),
              AppTextField(
                controller: _salaryController,
                label: t('salary'),
                prefixIcon: const Icon(Icons.attach_money),
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 24),

              // ── Status ──
              _buildSectionHeader(t('status')),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: SwitchListTile(
                  title: Text(t('active'),
                      style: Theme.of(context).textTheme.titleMedium),
                  subtitle: Text(
                    _isActive ? t('employeeActive') : t('employeeInactive'),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  value: _isActive,
                  activeColor: AppTheme.success,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  onChanged: (v) => setState(() => _isActive = v),
                ),
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

  Widget _buildProfileImageSection() {
    return Center(
      child: GestureDetector(
        onTap: _pickProfileImage,
        child: Stack(
          children: [
            CircleAvatar(
              radius: 56,
              backgroundColor: AppTheme.primaryContainer,
              backgroundImage: _profileImagePath != null
                  ? FileImage(File(_profileImagePath!))
                  : null,
              child: _profileImagePath == null
                  ? Icon(Icons.person, size: 48,
                      color: AppTheme.primary.withValues(alpha: 0.5))
                  : null,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
