import 'package:currency_rate_calculator/Currency/Bloc/currency_bloc.dart';
import 'package:currency_rate_calculator/Currency/Bloc/currency_event.dart';
import 'package:currency_rate_calculator/Currency/Bloc/currency_state.dart';
import 'package:currency_rate_calculator/Currency/UI/currency_chip.dart';
import 'package:currency_rate_calculator/Firebase_auth/Auth_Bloc/auth_bloc.dart';
import 'package:currency_rate_calculator/Firebase_auth/Auth_Bloc/auth_event.dart';
import 'package:currency_rate_calculator/Firebase_auth/Auth_Bloc/auth_state.dart';
import 'package:currency_rate_calculator/Firebase_auth/SignIn/login.dart';
import 'package:currency_rate_calculator/Trend_Chart/trend_UI.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final amountController = TextEditingController();

  late AnimationController swapController;
  late AnimationController _countUpController;
  late Animation<double> _countUpAnimation;

  double animatedValue = 0.0;

  @override
  void initState() {
    super.initState();
    swapController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      upperBound: 1,
    );

    _countUpController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );

    _countUpAnimation =
        Tween<double>(begin: animatedValue, end: animatedValue).animate(
      CurvedAnimation(parent: _countUpController, curve: Curves.easeOut),
    )..addListener(() {
            setState(() {
              animatedValue = _countUpAnimation.value;
            });
          });
  }

  @override
  void dispose() {
    swapController.dispose();
    _countUpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<CurrencyBloc>();
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
              (route) => false,
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: Icon(Icons.logout,
                    color: Theme.of(context).colorScheme.onPrimary
                ),
                onPressed: () {
                  context.read<AuthBloc>().add(AuthLogoutRequested());
                },
              ),
            ],
            backgroundColor: theme.colorScheme.primaryContainer,
            title: Text(
              "Currency Converter",
              style: TextStyle(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
            centerTitle: true,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Card(
                    color: theme.colorScheme.surface,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: theme.colorScheme.outline)),
                    elevation: 4,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CurrencyChip(
                            label: bloc.fromCurrency,
                            heroTag: "FROM_CURRENCY",
                            onSelect: (item) {
                              context
                                  .read<CurrencyBloc>()
                                  .add(SelectFromCurrencyEvent(item));
                            },
                          ),
                          GestureDetector(
                            onTap: () {
                              swapController.forward(from: 0);
                              context
                                  .read<CurrencyBloc>()
                                  .add(SwapCurrenciesEvent());
                            },
                            child: AnimatedBuilder(
                              animation: swapController,
                              builder: (context, child) {
                                return Transform.rotate(
                                  angle: swapController.value * 3.14,
                                  child: Icon(
                                    Icons.swap_horiz,
                                    size: 30,
                                    color: theme.colorScheme.primary,
                                  ),
                                );
                              },
                            ),
                          ),
                          CurrencyChip(
                            label: bloc.toCurrency,
                            heroTag: "TO_CURRENCY",
                            onSelect: (item) {
                              context
                                  .read<CurrencyBloc>()
                                  .add(SelectToCurrencyEvent(item));
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Card(
                    color: theme.colorScheme.surfaceVariant,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: theme.colorScheme.outline)),
                    elevation: 2,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: TextField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter amount",
                          hintStyle: TextStyle(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          prefixText: "${bloc.fromCurrency.code}  ",
                          prefixStyle:
                              TextStyle(color: theme.colorScheme.onSurface),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        context.read<CurrencyBloc>().add(
                              ConvertCurrencyEvent(
                                from: bloc.fromCurrency.code,
                                to: bloc.toCurrency.code,
                                amount: amountController.text.trim(),
                              ),
                            );
                      },
                      child: Text("Convert"),
                    ),
                  ),
                  SizedBox(height: 24),
                  BlocListener<CurrencyBloc, CurrencyState>(
                    listener: (context, state) {
                      if (state is CurrencyLoaded) {
                        double finalAmount = state.data.result[
                            context.read<CurrencyBloc>().toCurrency.code]!;
                        animateCountUp(finalAmount);
                      }
                    },
      
                    child: BlocBuilder<CurrencyBloc, CurrencyState>(
                      builder: (context, state) {
                        if (state is CurrencyLoading) {
                          return Shimmer.fromColors(
                            baseColor: theme.colorScheme.surfaceVariant,
                            highlightColor: theme.colorScheme.surface,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 20,
                                      width: 150,
                                      color: Colors.white,
                                    ),
                                    SizedBox(height: 16),
                                    Container(
                                      height: 32,
                                      width: 100,
                                      color: Colors.white,
                                    ),
                                    SizedBox(height: 16),
                                    Container(
                                      height: 48,
                                      width: double.infinity,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else if (state is CurrencyLoaded) {
                          return AnimatedSwitcher(
                            duration: Duration(milliseconds: 500),
                            child: Card(
                              key: ValueKey(state.data.result),
                              color: theme.colorScheme.surface,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: theme.colorScheme.outline),
                              ),
                              elevation: 4,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "1 ${bloc.fromCurrency.code} = ",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: theme.colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                        Text(
                                          "${state.data.result[bloc.toCurrency.code]!.toStringAsFixed(2)} ${bloc.toCurrency.code}",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: theme.colorScheme.onSurface,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      animatedValue.toStringAsFixed(2),
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: theme.colorScheme.onSurface,
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    SizedBox(
                                      width: double.infinity,
                                      child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: theme.colorScheme.primary,
                                          side: BorderSide(color: theme.colorScheme.primary),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12)),
                                        ),
                                        onPressed: () {
                                          openTrendSheet(
                                            context,
                                            bloc.fromCurrency.code,
                                            bloc.toCurrency.code,
                                          );
                                        },
                                        child: Text("View Trend"),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
      
                        return SizedBox.shrink();
                      },
                    ),

                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void animateCountUp(double targetValue) {
    final double start = animatedValue;
    final double end = targetValue;

    final controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );

    final animation = Tween<double>(begin: start, end: end)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

    animation.addListener(() {
      setState(() => animatedValue = animation.value);
    });

    controller.forward();

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      }
    });
  }
}

void openTrendSheet(BuildContext context, String from, String to) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => CurrencyTrendSheet(fromCurrency: from, toCurrency: to),
  );
}
