import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../state/auth_provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.tr(context, 'passwordsDoNotMatch')),
        ),
      );
      return;
    }
    setState(() => _loading = true);
    try {
      await context.read<AuthProvider>().signUpWithEmail(
            _emailController.text.trim(),
            _passwordController.text,
            _nameController.text.trim(),
          );
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRouter.dashboard);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    String t(String key) => AppLocalizations.tr(context, key);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pushReplacementNamed(
              context, AppRouter.login),
          color: theme.colorScheme.onSurface,
        ),
        title: Text(
          t('signUp'),
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                AppTextField(
                  controller: _nameController,
                  label: t('name'),
                  validator: (v) =>
                      v == null || v.isEmpty ? t('enterName') : null,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _emailController,
                  label: t('email'),
                  hint: 'you@example.com',
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) =>
                      v == null || v.isEmpty ? t('enterEmail') : null,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _passwordController,
                  label: t('password'),
                  obscureText: true,
                  validator: (v) => v == null || v.length < 6
                      ? t('passwordMinLength')
                      : null,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _confirmPasswordController,
                  label: t('confirmPassword'),
                  obscureText: true,
                  validator: (v) =>
                      v == null || v.isEmpty ? t('enterConfirmPassword') : null,
                ),
                const SizedBox(height: 24),
                AppButton(
                  label: t('signUp'),
                  onPressed: _submit,
                  loading: _loading,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(child: Divider(color: theme.dividerColor)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'or',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: theme.dividerColor)),
                  ],
                ),
                const SizedBox(height: 24),
                OutlinedButton.icon(
                  onPressed: _loading
                      ? null
                      : () async {
                          setState(() => _loading = true);
                          await context
                              .read<AuthProvider>()
                              .signInWithGoogle();
                          if (mounted) {
                            Navigator.pushReplacementNamed(
                                context, AppRouter.dashboard);
                          }
                          if (mounted) setState(() => _loading = false);
                        },
                  icon: const Icon(Icons.g_mobiledata, size: 20),
                  label: Text(t('signUpWithGoogle')),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    side: BorderSide(color: theme.dividerColor),
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        'By signing up you agree to our ',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      GestureDetector(
                        onTap: () =>
                            Navigator.pushNamed(context, AppRouter.terms),
                        child: Text(
                          t('termsOfService'),
                          style: const TextStyle(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Text(
                        ' and ',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      GestureDetector(
                        onTap: () =>
                            Navigator.pushNamed(context, AppRouter.privacy),
                        child: Text(
                          t('privacyPolicy'),
                          style: const TextStyle(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Text(
                        '.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      t('hasAccountPrompt'),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushReplacementNamed(
                          context, AppRouter.login),
                      style: TextButton.styleFrom(
                        foregroundColor: AppTheme.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                      child: Text(t('login')),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
