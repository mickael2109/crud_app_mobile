// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_new, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:p5_app_with_sqlite/widgets/home_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      
      theme: ThemeData( 
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 187, 15, 3)),
        // colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.red),
        useMaterial3: true,
      ),
      home: const HomeController(title: 'Je veux ...'),
      debugShowCheckedModeBanner: false,
    );
  }
}
