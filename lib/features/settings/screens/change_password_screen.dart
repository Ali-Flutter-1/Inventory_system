import 'package:flutter/material.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_text_field.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_newController.text != _confirmController.text) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('New password and confirm do not match'),
          backgroundColor: AppTheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    
    if (_newController.text.length < 6) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('New password must be at least 6 characters'),
          backgroundColor: AppTheme.warning,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    
    // TODO: call auth updatePassword when backend is ready
    
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${AppLocalizations.tr(context, 'save')} – Password updated successfully'),
        backgroundColor: AppTheme.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final t = (String key) => AppLocalizations.tr(context, key);

    return AppScaffold(
      showDrawer: false,
      title: t('changePassword'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Header Icon
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.primaryContainer,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.lock_reset_rounded,
                size: 48,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: 40),
            
            // Form Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppTextField(
                      controller: _currentController,
                      label: t('password'), // Generic 'Password' usually implies current
                      hint: 'Current Password',
                      obscureText: true,
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Enter current password' : null,
                    ),
                    const SizedBox(height: 20),
                    AppTextField(
                      controller: _newController,
                      label: t('password'), // Needs 'New Password' label ideally, using generic for now implies new
                      hint: 'New Password',
                      obscureText: true,
                      prefixIcon: const Icon(Icons.vpn_key_outlined),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Enter new password' : null,
                    ),
                    const SizedBox(height: 20),
                    AppTextField(
                      controller: _confirmController,
                      label: t('confirmPassword'),
                      hint: 'Confirm New Password',
                      obscureText: true,
                      prefixIcon: const Icon(Icons.check_circle_outline_rounded),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Confirm new password' : null,
                    ),
                    const SizedBox(height: 32),
                    AppButton(
                      label: t('save'),
                      onPressed: _isLoading ? null : _save,
                      loading: _isLoading,
                      expand: true,
                    ),
                  ],
                ),
              ),
            ),
            
            // Helper Text
            const SizedBox(height: 24),
            Text(
              'Make sure your password is secure and at least 6 characters long.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
