import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rapidito/blocProviders.dart';
import 'package:rapidito/injection.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rapidito/firebase_options.dart';
import 'package:rapidito/src/presentation/pages/authentication/login/LoginPage.dart';
import 'package:rapidito/src/presentation/pages/authentication/register/RegisterPage.dart';
import 'package:rapidito/src/presentation/pages/client/home/ClientHomePage.dart';
import 'package:rapidito/src/presentation/pages/driver/home/DriverHomePage.dart';
import 'package:rapidito/src/presentation/pages/profile/update/profileUpdatePage.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: blocProvider,
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 15, 66, 233),
          ),
        ),
        initialRoute: '/login',
        routes: {
          '/login': (BuildContext context) => const LoginPage(),
          '/register': (BuildContext context) => const RegisterPage(),
          '/client/home': (BuildContext context) => const ClientHomePage(),
          '/driver/home': (BuildContext context) => const DriverHomePage(),
          '/profile/update': (BuildContext context) =>
              const ProfileUpdatePage(),
        },
      ),
    );
  }
}
