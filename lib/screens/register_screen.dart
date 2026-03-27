import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dadaroo/config/app_config.dart';
import 'package:dadaroo/providers/app_provider.dart';
import 'package:dadaroo/theme/app_theme.dart';

/// Parent registration screen (Dad/Mum only). Family members use JoinFamilyScreen instead.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _familyNameController = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _familyNameController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final provider = context.read<AppProvider>();
      await provider.signUpParent(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        phoneNumber: _phoneController.text.trim(),
        familyName: _familyNameController.text.trim(),
      );
      // signUpParent auto-creates the family group, so AuthGate will
      // route to the main app after the profile stream updates.
    } catch (e) {
      setState(() => _error = _friendlyError(e.toString()));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _friendlyError(String error) {
    if (error.contains('email-already-in-use')) {
      return 'This email is already registered';
    }
    if (error.contains('weak-password')) {
      return 'Password must be at least 6 characters';
    }
    if (error.contains('invalid-email')) return 'Invalid email address';
    return 'Sign up failed. Please try again.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      Text(
                        appConfig.parentEmoji,
                        style: const TextStyle(fontSize: 48),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Register as ${appConfig.parentRole}',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkBrown,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Set up your ${appConfig.appName} account',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppTheme.warmBrown.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Error message
                if (_error != null) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Text(
                      _error!,
                      style: TextStyle(color: Colors.red.shade700),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Name
                TextFormField(
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  decoration: _inputDecoration(
                    label: 'Your Name',
                    icon: Icons.person_outlined,
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Enter your name';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: _inputDecoration(
                    label: 'Email',
                    icon: Icons.email_outlined,
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Enter your email';
                    if (!v.contains('@')) return 'Enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Phone
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  decoration: _inputDecoration(
                    label: 'Phone Number',
                    icon: Icons.phone_outlined,
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Enter your phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  textInputAction: TextInputAction.next,
                  decoration: _inputDecoration(
                    label: 'Password',
                    icon: Icons.lock_outlined,
                    hint: 'At least 6 characters',
                  ),
                  validator: (v) {
                    if (v == null || v.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Family name
                Divider(color: AppTheme.warmBrown.withValues(alpha: 0.3)),
                const SizedBox(height: 16),
                Text(
                  'Your Family Group',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkBrown,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "You'll get a code to share with your family",
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.warmBrown.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _familyNameController,
                  textInputAction: TextInputAction.done,
                  textCapitalization: TextCapitalization.words,
                  onFieldSubmitted: (_) => _signUp(),
                  decoration: _inputDecoration(
                    label: 'Family Name',
                    icon: Icons.home_outlined,
                    hint: 'e.g. The Smiths',
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Enter a family name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // Sign up button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _signUp,
                    child: _loading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Create Account'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    String? hint,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: AppTheme.primaryOrange,
          width: 2,
        ),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }
}
