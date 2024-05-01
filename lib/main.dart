import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hostel_management/features/auth/screens/login_screen.dart';
import 'package:hostel_management/features/home/screens/home_screen.dart';
import 'package:hostel_management/features/auth/services/auth_service.dart';
import 'package:hostel_management/providers/user_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  final bool isUserLoggedIn;

  const MyApp({super.key, this.isUserLoggedIn = false});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService authService = AuthService();
  late bool isLoggedIn;

  @override
  void initState() {
    super.initState();
    checkUserLoggedIn().then((value) => setState(() => isLoggedIn = value));
    ;
    // authService.getUserData(context);
  }

  Future<bool> checkUserLoggedIn() async {
    isLoggedIn = await authService.isUserLoggedIn(context);
    return isLoggedIn;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
      ],
      child: ScreenUtilInit(
        // Screen Responsiveness
        useInheritedMediaQuery: true,
        designSize: const Size(375, 825),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          // final ThemeData theme = ThemeData();

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'MyApp',
            home: isLoggedIn ? const HomeScreen() : const LoginScreen(),
          );
        },
      ),
    );
  }
}
