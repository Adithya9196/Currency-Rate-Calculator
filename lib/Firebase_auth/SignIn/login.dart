import 'package:currency_rate_calculator/Firebase_auth/Auth_Bloc/auth_bloc.dart';
import 'package:currency_rate_calculator/Firebase_auth/Auth_Bloc/auth_event.dart';
import 'package:currency_rate_calculator/Firebase_auth/Auth_Bloc/auth_state.dart';
import 'package:currency_rate_calculator/Firebase_auth/SignUp/Register.dart';
import 'package:currency_rate_calculator/Home_Page/Home_Page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  late AnimationController _shake;
  late Animation<double> _offset;

  @override
  void initState() {
    super.initState();
    _shake =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _offset = Tween(begin: 0.0, end: 20.0)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_shake);
  }

  void triggerShake() => _shake.forward().then((_) => _shake.reverse());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = theme.colorScheme.background;
    final cardColor = theme.colorScheme.surface;
    final primaryColor = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;
    final surfaceVariant = theme.colorScheme.surfaceVariant;

    return Scaffold(
      backgroundColor: bgColor,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            triggerShake();
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
          if (state is AuthAuthenticated) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          }
        },
        builder: (context, state) {
          return Center(
            child: AnimatedBuilder(
              animation: _shake,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(_offset.value, 0),
                  child: child,
                );
              },
              child: Container(
                padding: EdgeInsets.all(24),
                margin: EdgeInsets.symmetric(horizontal: 28),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withOpacity(0.2),
                      blurRadius: 18,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.lock_outline, size: 60, color: primaryColor),
                    SizedBox(height: 10),

                    Text(
                      "Welcome Back",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),

                    SizedBox(height: 6),
                    Text(
                      "Login to continue",
                      style: TextStyle(color: theme.colorScheme.onBackground),
                    ),

                    SizedBox(height: 25),

                    TextField(
                      controller: emailCtrl,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: surfaceVariant,
                        labelText: "Email",
                        prefixIcon: Icon(Icons.email_outlined, color: primaryColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 15),

                    TextField(
                      controller: passCtrl,
                      obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: surfaceVariant,
                        labelText: "Password",
                        prefixIcon: Icon(Icons.lock_outline, color: primaryColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    SizedBox(height: 22),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                          backgroundColor: primaryColor,
                        ),
                        onPressed: () {
                          context.read<AuthBloc>().add(
                            AuthLoginRequested(
                              emailCtrl.text.trim(),
                              passCtrl.text.trim(),
                            ),
                          );
                        },
                        child: state is AuthLoading
                            ? CircularProgressIndicator(color: theme.colorScheme.onPrimary)
                            : Text(
                          "Login",
                          style: TextStyle(
                              fontSize: 18,
                              color: theme.colorScheme.onPrimary),
                        ),
                      ),
                    ),

                    SizedBox(height: 16),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => RegisterScreen()),
                        );
                      },
                      child: Text(
                        "Create an account",
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
