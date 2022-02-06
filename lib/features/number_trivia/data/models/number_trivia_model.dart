import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:numbers_trivia/features/number_trivia/domain/entities/number_trivia.dart';

class NumberTriviaModel extends NumberTrivia {
  NumberTriviaModel({
    @required this.text, 
    @required this.number
  }) : super(
    text:  text,
    number: number, 
  );

  final String text;
  final int number;

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'number': number,
    };
  }

  factory NumberTriviaModel.fromMap(Map<String, dynamic> map) {
    return NumberTriviaModel(
      text: map['text'] ?? '',
      number: map['number']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory NumberTriviaModel.fromJson(String source) => NumberTriviaModel.fromMap(json.decode(source));
}
