import 'package:flutter_test/flutter_test.dart';
import 'package:numbers_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:numbers_trivia/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final testNumberTriviaModel = NumberTriviaModel(text: 'Test text', number: 1);

  test('should be a subclass of NumberTrivia entity', () {
    expect(testNumberTriviaModel, isA<NumberTrivia>());
  });

  group('fromJson', () {
    test('should return a valid model when the JSON number is an integer', () {
      final result = NumberTriviaModel.fromJson(fixture('trivia.json'));
      
      expect(result, testNumberTriviaModel);
    });

    test('should return a valid model when the JSON number is regarded as a double', () {
      final result = NumberTriviaModel.fromJson(fixture('trivia_double.json'));

      expect(result, testNumberTriviaModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing the proper data', () {
      final result = testNumberTriviaModel.toMap();
      final expectedMap = {
        "text": "Test text",
        "number": 1,
      };

      expect(result, expectedMap);
    });
  });
}