import 'package:currency_rate_calculator/Firebase_auth/Auth_Bloc/auth_bloc.dart';
import 'package:currency_rate_calculator/Firebase_auth/Auth_Bloc/auth_event.dart';
import 'package:currency_rate_calculator/Firebase_auth/Auth_Bloc/auth_state.dart';
import 'package:currency_rate_calculator/Home_Page/Home_Page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  late AnimationController _shakeController;
  late Animation<double> _shakeOffset;

  @override
  void initState() {
    super.initState();

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _shakeOffset = Tween(begin: 0.0, end: 20.0)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_shakeController);
  }

  void triggerShake() {
    _shakeController.forward().then((_) => _shakeController.reverse());
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            triggerShake();
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }

          if (state is AuthAuthenticated) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => HomeScreen()),
                  (route) => false,
            );
          }
        },
        builder: (context, state) {
          return Center(
            child: AnimatedBuilder(
              animation: _shakeController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(_shakeOffset.value, 0),
                  child: child,
                );
              },
              child: Container(
                padding: EdgeInsets.all(24),
                margin: EdgeInsets.symmetric(horizontal: 28),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withOpacity(0.1),
                      blurRadius: 18,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.person_add_alt_1,
                        size: 60, color: colorScheme.primary),
                    SizedBox(height: 10),

                    Text(
                      "Create Account",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),

                    SizedBox(height: 6),
                    Text(
                      "Register to get started",
                      style: TextStyle(color: colorScheme.onSurfaceVariant),
                    ),

                    SizedBox(height: 25),

                    TextField(
                      controller: emailCtrl,
                      decoration: InputDecoration(
                        filled: true,
                        labelText: "Email",
                        prefixIcon: Icon(Icons.email_outlined, color: colorScheme.primary),
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
                        labelText: "Password",
                        prefixIcon: Icon(Icons.lock_outline, color: colorScheme.primary),
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
                          backgroundColor: colorScheme.primary,
                        ),
                        onPressed: () {
                          context.read<AuthBloc>().add(
                            AuthRegisterRequested(
                              emailCtrl.text.trim(),
                              passCtrl.text.trim(),
                            ),
                          );
                        },
                        child: state is AuthLoading
                            ? CircularProgressIndicator(color: colorScheme.onPrimary)
                            : Text(
                          "Register",
                          style: TextStyle(
                              fontSize: 18, color: colorScheme.onPrimary),
                        ),
                      ),
                    ),
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
