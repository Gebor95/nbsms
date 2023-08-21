import 'package:flutter/material.dart';
import 'package:nbsms/constant/constant_fonts.dart';
import 'package:nbsms/model/user.dart';
import 'package:nbsms/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final showOnBoarding = prefs.getBool('showOnBoarding') ?? false;

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<UserProfileProvider>(
        create: (_) => UserProfileProvider(),
      ),
    ],
    child: MyApp(showOnBoarding: showOnBoarding),
  ));
}

class MyApp extends StatelessWidget {
  final bool showOnBoarding;

  const MyApp({
    Key? key,
    required this.showOnBoarding,
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nigeria Bulk SMS',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: centurygothic,
        primarySwatch: Colors.green,
      ),
      home: const SplashScreen(),
    );
  }
}
