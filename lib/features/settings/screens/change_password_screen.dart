import 'package:flutter/material.dart';
import '../../../core/l10n/app_localizations.dart';
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

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    if (_newController.text != _confirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('New password and confirm do not match')),
      );
      return;
    }
    if (_newController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('New password must be at least 6 characters')),
      );
      return;
    }
    // TODO: call auth updatePassword when backend is ready
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${AppLocalizations.tr(context, 'save')} – TODO: persist')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    String t(String key) => AppLocalizations.tr(context, key);

    return AppScaffold(
      showDrawer: false,
      title: t('changePassword'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                controller: _currentController,
                label: 'Current password',
                obscureText: true,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter current password' : null,
              ),
              const SizedBox(height: 14),
              AppTextField(
                controller: _newController,
                label: 'New password',
                obscureText: true,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter new password' : null,
              ),
              const SizedBox(height: 14),
              AppTextField(
                controller: _confirmController,
                label: t('confirmPassword'),
                obscureText: true,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Confirm new password' : null,
              ),
              const SizedBox(height: 24),
              AppButton(
                label: t('save'),
                onPressed: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
