import 'package:flutter/material.dart';
import 'package:flutter_front_end/screens/login_page.dart';
import 'package:flutter_front_end/screens/main_page.dart';
import 'package:flutter_front_end/widgets/post_list.dart';
import 'package:provider/provider.dart';

import 'utils/constants.dart';
import './models/user_data.dart';
import './models/post_list_data.dart';

void main() {
  runApp(
    /// Providers are above [MyApp] instead of inside it, so that tests
    /// can use [MyApp] while mocking the providers
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PostListData()),
        ChangeNotifierProvider(create: (_) => UserData()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: kBackgrounColor,
        appBarTheme: const AppBarTheme(
          color: kBackgrounColor,
        ),
      ),
      home: LoginPage(),
    );
  }
}
