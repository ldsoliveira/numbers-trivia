import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:numbers_trivia/core/util/input_converter.dart';

void main() {
  InputConverter inputConverter = InputConverter();

  group('stringToUnsignedInt', () {
    test('should return an integer when the string represents an unsigned integer', () {
      final str = '123';
      final result = inputConverter.stringToUnsignedInteger(str);

      expect(result, Right(123));
    });

    test('should return an InvalidInputFailure when the string is not an integer', () {
      final str = '1.0';
      final result = inputConverter.stringToUnsignedInteger(str);

      expect(result, Left(InvalidInputFailure()));
    });

    test('should return an InvalidInputFailure when the string is a negative integer', () {
      final str = '-123';
      final result = inputConverter.stringToUnsignedInteger(str);

      expect(result, Left(InvalidInputFailure()));
    });
  });
}