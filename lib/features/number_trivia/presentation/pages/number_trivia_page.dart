import 'package:flutter/material.dart';
import 'package:numbers_trivia/features/number_trivia/presentation/widgets/build_body.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({ Key key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Trivia'),
      ),
      body: BuildBody(),
    );
  }
}