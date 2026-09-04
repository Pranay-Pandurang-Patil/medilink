import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:medilink/shared/widgets/custom_button.dart';
import 'package:medilink/shared/widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
  TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _createAccount() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account details are valid'),
        ),
      );

      Future.delayed(const Duration(milliseconds: 800), () {
        if (!mounted) return;

        Navigator.pop(context);
      });
    }
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
              children: [
                const SizedBox(height: 20),

                Lottie.asset(
                  'assets/animations/login_animation.json',
                  height: 210,
                  repeat: true,
                ),

                const SizedBox(height: 15),

                Image.asset(
                  'assets/images/logo_icon.png',
                  height: 95,
                ),

                const SizedBox(height: 20),

                const Text(
                  'Create Owner Account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Create your account to manage your medical shop',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 35),

                CustomTextField(
                  controller: nameController,
                  labelText: 'Owner Name',
                  hintText: 'Enter your full name',
                  prefixIcon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your name';
                    }

                    if (value.trim().length < 3) {
                      return 'Name must be at least 3 characters';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 18),

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
                  controller: phoneController,
                  labelText: 'Mobile Number',
                  hintText: 'Enter your mobile number',
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your mobile number';
                    }

                    if (value.length != 10) {
                      return 'Mobile number must be 10 digits';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 18),

                CustomTextField(
                  controller: passwordController,
                  labelText: 'Password',
                  hintText: 'Create a password',
                  prefixIcon: Icons.lock_outline,
                  obscureText: obscurePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
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

                const SizedBox(height: 18),

                CustomTextField(
                  controller: confirmPasswordController,
                  labelText: 'Confirm Password',
                  hintText: 'Re-enter your password',
                  prefixIcon: Icons.lock_outline,
                  obscureText: obscureConfirmPassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }

                    if (value != passwordController.text) {
                      return 'Passwords do not match';
                    }

                    return null;
                  },
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        obscureConfirmPassword =
                        !obscureConfirmPassword;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 25),

                CustomButton(
                  text: 'Create Account',
                  onPressed: _createAccount,
                ),

                const SizedBox(height: 25),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an owner account? ',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Login',
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