import 'package:flutter/material.dart';
import 'package:numbers_trivia/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'package:numbers_trivia/injection_container.dart' as di;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  
  runApp(MaterialApp(
    title: 'Number Trivia',
    home: NumberTriviaPage(),
    theme: ThemeData(
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: Colors.cyan[600],
        secondary: Colors.cyanAccent[400]
      ),
    ),
  ));
}