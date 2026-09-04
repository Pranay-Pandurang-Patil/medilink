import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:medilink/features/auth/screens/register_screen.dart';
import 'package:medilink/features/dashboard/screens/main_screen.dart';
import 'package:medilink/shared/widgets/custom_button.dart';
import 'package:medilink/shared/widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MainScreen(),
        ),
      );
    }
  }

  void _openRegisterScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RegisterScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 20,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                Lottie.asset(
                  'assets/animations/login_animation.json',
                  height: 220,
                  repeat: true,
                ),

                const SizedBox(height: 10),

                Image.asset(
                  'assets/images/logo_icon.png',
                  height: 100,
                ),

                const SizedBox(height: 20),

                const Text(
                  'Owner Login',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Sign in to manage your medical shop',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 35),

                CustomTextField(
                  controller: emailController,
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your email';
                    }

                    if (!value.contains('@') || !value.contains('.')) {
                      return 'Please enter a valid email';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 18),

                CustomTextField(
                  controller: passwordController,
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  prefixIcon: Icons.lock_outline,
                  obscureText: obscurePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }

                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }

                    return null;
                  },
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 12),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // TODO: Forgot password
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                CustomButton(
                  text: 'Login',
                  onPressed: _login,
                ),

                const SizedBox(height: 25),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an owner account? ",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                    GestureDetector(
                      onTap: _openRegisterScreen,
                      child: const Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}