import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import 'signup_screen.dart';
import '../../main_scaffold.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 40),
                // App Logo
                _buildLogo(),
                const SizedBox(height: 16),
                // App Name
                Text(
                  'NeerGauge',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryBlue,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Smart Water Monitoring',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textColorSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 48),
                // Form Card
                _buildFormCard(),
                const SizedBox(height: 24),
                // Sign Up Link
                _buildSignUpLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          'assets/logo/neergauge.png',
          fit: BoxFit.contain,
          errorBuilder: (context, error, stack) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: CustomPaint(
                painter: _LogoPainter(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Username Field
          TextFormField(
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: 'Username',
              hintText: 'Enter your username',
              prefixIcon: const Icon(Icons.person_outline),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a username';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          // Password Field
          TextFormField(
            controller: _passwordController,
            obscureText: !_isPasswordVisible,
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Enter your password',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a password';
              }
              return null;
            },
          ),
          const SizedBox(height: 32),
          // Login Button
          FilledButton(
            onPressed: _handleLogin,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Login',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textColorSecondary,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const SignUpScreen()),
            );
          },
          child: Text(
            'Sign Up',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      // Navigate to main app
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainScaffold()),
      );
    }
  }
}

class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = const Color(0xFF1976D2);

    // Main droplet shape
    final path = Path();
    path.moveTo(size.width * 0.5, size.height * 0.1);
    path.quadraticBezierTo(size.width * 0.2, size.height * 0.3, size.width * 0.3, size.height * 0.6);
    path.quadraticBezierTo(size.width * 0.4, size.height * 0.8, size.width * 0.5, size.height * 0.9);
    path.quadraticBezierTo(size.width * 0.6, size.height * 0.8, size.width * 0.7, size.height * 0.6);
    path.quadraticBezierTo(size.width * 0.8, size.height * 0.3, size.width * 0.5, size.height * 0.1);
    path.close();

    // Fill with gradient-like effect
    paint.color = const Color(0xFF4FC3F7);
    canvas.drawPath(path, paint);

    // Gauge circle
    paint.color = const Color(0xFF81D4FA);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.45), size.width * 0.15, paint);

    // Gauge needle
    strokePaint.color = const Color(0xFF1976D2);
    canvas.drawLine(
      Offset(size.width * 0.5, size.height * 0.45),
      Offset(size.width * 0.6, size.height * 0.35),
      strokePaint,
    );

    // Wave shapes at bottom
    paint.color = const Color(0xFF2196F3);
    final wave1 = Path();
    wave1.moveTo(size.width * 0.2, size.height * 0.7);
    wave1.quadraticBezierTo(size.width * 0.35, size.height * 0.65, size.width * 0.5, size.height * 0.7);
    wave1.quadraticBezierTo(size.width * 0.65, size.height * 0.75, size.width * 0.8, size.height * 0.7);
    canvas.drawPath(wave1, paint);

    paint.color = const Color(0xFF1976D2);
    final wave2 = Path();
    wave2.moveTo(size.width * 0.1, size.height * 0.85);
    wave2.quadraticBezierTo(size.width * 0.3, size.height * 0.8, size.width * 0.5, size.height * 0.85);
    wave2.quadraticBezierTo(size.width * 0.7, size.height * 0.9, size.width * 0.9, size.height * 0.85);
    canvas.drawPath(wave2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
