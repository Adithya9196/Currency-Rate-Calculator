import 'package:currency_rate_calculator/Firebase_auth/Auth_Bloc/auth_bloc.dart';
import 'package:currency_rate_calculator/Firebase_auth/Auth_Bloc/auth_state.dart';
import 'package:currency_rate_calculator/Firebase_auth/SignIn/login.dart';
import 'package:currency_rate_calculator/Home_Page/Home_Page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _logoScale;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _logoScale = Tween<double>(begin: 0.6, end: 1.2).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );
    _logoController.forward();

    _fadeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();

    Future.delayed(Duration(seconds: 4), () {
      final authState = context.read<AuthBloc>().state;

      if (authState is AuthAuthenticated) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
              (route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
              (route) => false,
        );
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? Colors.black : Colors.white;
    final primaryColor = Colors.deepPurple;

    return Scaffold(
      backgroundColor: bgColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: bgColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _logoScale,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          primaryColor.withOpacity(0.3),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  Icon(
                    Icons.currency_exchange,
                    size: 120,
                    color: primaryColor,
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  Text(
                    "Currency Rate",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Real-time currency converter",
                    style: TextStyle(
                      fontSize: 16,
                      color: primaryColor.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
