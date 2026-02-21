import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../state/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await context.read<AuthProvider>().signInWithEmail(
            _emailController.text.trim(),
            _passwordController.text,
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

  static const String _appName = 'BizInventory';
  static const String _appSlogan = 'Your business. Your stock. One app.';

  @override
  Widget build(BuildContext context) {
    String t(String key) => AppLocalizations.tr(context, key);
    final theme = Theme.of(context);
    final auth = context.watch<AuthProvider>();
    final displayName = (auth.companyName != null && auth.companyName!.isNotEmpty)
        ? auth.companyName!
        : _appName;
    final displaySlogan = (auth.companySlogan != null && auth.companySlogan!.isNotEmpty)
        ? auth.companySlogan!
        : _appSlogan;
    final hasLogo = auth.companyLogo != null &&
        auth.companyLogo!.isNotEmpty &&
        File(auth.companyLogo!).existsSync();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          displayName,
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
                Center(
                  child: Column(
                    children: [
                      if (hasLogo)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(auth.companyLogo!),
                            width: 72,
                            height: 72,
                            fit: BoxFit.cover,
                          ),
                        )
                      else
                        Icon(
                          Icons.inventory_2_rounded,
                          size: 48,
                          color: AppTheme.primary,
                        ),
                      const SizedBox(height: 12),
                      Text(
                        displayName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1E293B),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        displaySlogan,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF64748B),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  t('login'),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 24),
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
                  validator: (v) =>
                      v == null || v.isEmpty ? t('enterPassword') : null,
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRouter.forgotPassword),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                    ),
                    child: Text(t('forgotPassword')),
                  ),
                ),
                const SizedBox(height: 24),
                AppButton(
                  label: t('login'),
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
                  label: Text(t('signInWithGoogle')),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    side: BorderSide(color: theme.dividerColor),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      t('noAccountPrompt'),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushReplacementNamed(
                          context, AppRouter.signUp),
                      style: TextButton.styleFrom(
                        foregroundColor: AppTheme.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                      child: Text(t('signUp')),
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
