import 'package:flutter/material.dart';
import 'package:ontap_sharedprefences/provider/setting.dart';
import 'package:ontap_sharedprefences/provider/task.dart';
import 'package:provider/provider.dart';

import 'screen/home.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => SettingProvider()),
      ChangeNotifierProvider(create: (_) => TaskProvider()),
    ],
    child: MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "My App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.green,
          brightness: context.watch<SettingProvider>().isDark
              ? Brightness.dark
              : Brightness.light),
      home: Home(),
    );
  }
}
