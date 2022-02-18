import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:numbers_trivia/core/errors/failure.dart';
import 'package:numbers_trivia/core/usecases/usecase.dart';
import 'package:numbers_trivia/core/util/input_converter.dart';
import 'package:numbers_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:numbers_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:numbers_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:numbers_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';

class MockGetConcreteNumberTrivia extends Mock implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
  MockInputConverter mockInputConverter = MockInputConverter();

  NumberTriviaBloc bloc = NumberTriviaBloc(
    getConcreteNumberTrivia: mockGetConcreteNumberTrivia, 
    getRandomNumberTrivia: mockGetRandomNumberTrivia, 
    inputConverter: mockInputConverter,
  );

  test('initialState should be Empty', () {
    expect(bloc.initialState, Empty());
  });

  group('GetTriviaForRandomNumber', () {
    final testNumberTrivia = NumberTrivia(text: 'Test text', number: 1);

    test('should get data from the random use case', () async {
      when(mockGetRandomNumberTrivia(any))
        .thenAnswer((_) async => Right(testNumberTrivia));

      bloc.add(GetTriviaForRandomNumber());

      await untilCalled(mockGetRandomNumberTrivia(any));

      verify(mockGetRandomNumberTrivia(NoParams()));
    });

    test('should emit [Loading, Loaded] when data is gotten sucessfully', () async {
      when(mockGetRandomNumberTrivia(any))
        .thenAnswer((_) async => Right(testNumberTrivia));

      expectLater(bloc.state, emitsInOrder(
        [
          // Empty(),
          Loading(),
          Loaded(trivia: testNumberTrivia),
        ]
      ));

      bloc.add(GetTriviaForRandomNumber());
    });

    test('should emit [Loading, Error] when getting data fails', () async {
      when(mockGetRandomNumberTrivia(any))
        .thenAnswer((_) async => Left(ServerFailure()));

      expectLater(bloc.state, emitsInOrder(
        [
          // Empty(),
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE),
        ]
      ));

      bloc.add(GetTriviaForRandomNumber());
    });

    test('should emit [Loading, Error] with proper message for the error', () async {
      when(mockGetRandomNumberTrivia(any))
        .thenAnswer((_) async => Left(CacheFailure()));

      expectLater(bloc.state, emitsInOrder(
        [
          // Empty(),
          Loading(),
          Error(message: CACHE_FAILURE_MESSAGE),
        ]
      ));

      bloc.add(GetTriviaForRandomNumber());
    });
  });

  group('GetTriviaForConcreteNumber', () {
    final testNumberString = '1';
    final testNumberParsed = 1;
    final testNumberTrivia = NumberTrivia(text: 'Test text', number: 1);

    test('should call the InputConverter to validate and convert the string to an unsigned integer', () async {
      when(mockInputConverter.stringToUnsignedInteger(any))
        .thenReturn(Right(testNumberParsed));

      bloc.add(GetTriviaForConcreteNumber(testNumberString));

      await untilCalled(mockInputConverter.stringToUnsignedInteger(any));

      verify(mockInputConverter.stringToUnsignedInteger(testNumberString));
    });

    test('should emit [Error] when the input is invalid', () async {
      when(mockInputConverter.stringToUnsignedInteger(any))
        .thenReturn(Left(InvalidInputFailure()));

      expectLater(bloc.state, emitsInOrder(
        [
          // Empty(),
          Error(message: INVALID_INPUT_FAILURE_MESSAGE)
        ]
      ));

      bloc.add(GetTriviaForConcreteNumber(testNumberString));
    });

    test('should get data from the concrete use case', () async {
      when(mockInputConverter.stringToUnsignedInteger(any))
        .thenReturn(Right(testNumberParsed));
      when(mockGetConcreteNumberTrivia(any))
        .thenAnswer((_) async => Right(testNumberTrivia));

      bloc.add(GetTriviaForConcreteNumber(testNumberString));

      await untilCalled(mockGetConcreteNumberTrivia(any));

      verify(mockGetConcreteNumberTrivia(Params(number: testNumberParsed)));
    });

    test('should emit [Loading, Loaded] when data is gotten sucessfully', () async {
      when(mockInputConverter.stringToUnsignedInteger(any))
        .thenReturn(Right(testNumberParsed));
      when(mockGetConcreteNumberTrivia(any))
        .thenAnswer((_) async => Right(testNumberTrivia));

      expectLater(bloc.state, emitsInOrder(
        [
          // Empty(),
          Loading(),
          Loaded(trivia: testNumberTrivia),
        ]
      ));

      bloc.add(GetTriviaForConcreteNumber(testNumberString));
    });

    test('should emit [Loading, Error] when getting data fails', () async {
      when(mockInputConverter.stringToUnsignedInteger(any))
        .thenReturn(Right(testNumberParsed));
      when(mockGetConcreteNumberTrivia(any))
        .thenAnswer((_) async => Left(ServerFailure()));

      expectLater(bloc.state, emitsInOrder(
        [
          // Empty(),
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE),
        ]
      ));

      bloc.add(GetTriviaForConcreteNumber(testNumberString));
    });

    test('should emit [Loading, Error] with proper message for the error', () async {
      when(mockInputConverter.stringToUnsignedInteger(any))
        .thenReturn(Right(testNumberParsed));
      when(mockGetConcreteNumberTrivia(any))
        .thenAnswer((_) async => Left(CacheFailure()));

      expectLater(bloc.state, emitsInOrder(
        [
          // Empty(),
          Loading(),
          Error(message: CACHE_FAILURE_MESSAGE),
        ]
      ));

      bloc.add(GetTriviaForConcreteNumber(testNumberString));
    });
  });

  bloc.close();
}