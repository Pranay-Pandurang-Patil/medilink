import 'package:flutter/material.dart';
import 'package:medilink/features/auth/screens/login_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 20,
            ),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Logo
                Image.asset(
                  'assets/images/logo_icon.png',
                  height: 130,
                ),

                const SizedBox(height: 35),

                // Title
                RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: 'Welcome to ',
                        style: TextStyle(color: Colors.black87),
                      ),
                      TextSpan(
                        text: 'MediLink',
                        style: TextStyle(color: Colors.green),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                const Text(
                  'Choose how you want to continue',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 45),

                // Customer Card
                _buildRoleCard(
                  icon: Icons.person,
                  title: 'Continue as Customer',
                  subtitle: 'Find and order medicines easily',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 22),

                // Owner Card
                _buildRoleCard(
                  icon: Icons.store,
                  title: 'Continue as Store Owner',
                  subtitle: 'Manage your store and medicines',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 45),

                const Icon(
                  Icons.verified_user_outlined,
                  color: Colors.green,
                  size: 28,
                ),

                const SizedBox(height: 12),

                const Text(
                  'By continuing, you agree to our',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 6),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Terms of Service',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '•',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Privacy Policy',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
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

  static Widget _buildRoleCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xffF8FFF8),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(.15),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(.12),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: Colors.green,
                size: 34,
              ),
            ),

            const SizedBox(width: 18),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.green,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}