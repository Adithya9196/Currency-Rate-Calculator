import 'package:currency_rate_calculator/Currency/Bloc/currency_bloc.dart';
import 'package:currency_rate_calculator/Currency/Data/currency_list.dart';
import 'package:currency_rate_calculator/Currency/Data/currency_repository.dart';
import 'package:currency_rate_calculator/Firebase_auth/Auth_Bloc/auth_bloc.dart';
import 'package:currency_rate_calculator/Firebase_auth/Auth_Repository/auth_repo.dart';
import 'package:currency_rate_calculator/SplashScreen/SplashScreen.dart';
import 'package:currency_rate_calculator/Theme/ThemeData.dart';
import 'package:currency_rate_calculator/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc(AuthRepository())),
        BlocProvider(
            create: (context) => CurrencyBloc(
                repository: CurrencyRepository(),
                fromCurrency: currencies[0],
                toCurrency: currencies[1]))
      ],
      child: MaterialApp(
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
