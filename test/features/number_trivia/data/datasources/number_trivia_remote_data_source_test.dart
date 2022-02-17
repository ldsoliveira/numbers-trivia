import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';
import 'package:numbers_trivia/core/errors/exceptions.dart';
import 'package:numbers_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:numbers_trivia/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  MockHttpClient mockHttpClient = MockHttpClient();
  NumberTriviaRemoteDataSourceImpl dataSource = 
    NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);

  group('getConcreteNumberTrivia', () {
    const testNumber = 1;
    final testNumberTriviaModel = NumberTriviaModel.fromJson(fixture('trivia.json'));

    test('''should perform GET request on a URL with number being the endpoint 
        and with application/json header''', () async {
      when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));

      dataSource.getConcreteNumberTrivia(testNumber);

      verify(mockHttpClient.get(
        'http://numbersapi.com/$testNumber',
        headers: {'Content-Type': 'application/json'},
      ));
    });

    test('should return NumberTrivia when the response code is 200', () async {
      when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));

      final result = await dataSource.getConcreteNumberTrivia(testNumber);

      expect(result, testNumberTriviaModel);
    });

    test('should throw a ServerException when response code is 404 or other', () async {
      when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));

      final call = dataSource.getConcreteNumberTrivia;

      expect(() => call(testNumber), throwsA(TypeMatcher<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    final testNumberTriviaModel = NumberTriviaModel.fromJson(fixture('trivia.json'));

    test('''should perform GET request on a URL with number being the endpoint 
        and with application/json header''', () async {
      when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));

      dataSource.getRandomNumberTrivia();

      verify(mockHttpClient.get(
        'http://numbersapi.com/random',
        headers: {'Content-Type': 'application/json'},
      ));
    });

    test('should return NumberTrivia when the response code is 200', () async {
      when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));

      final result = await dataSource.getRandomNumberTrivia();

      expect(result, testNumberTriviaModel);
    });

    test('should throw a ServerException when response code is 404 or other', () async {
      when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));

      final call = dataSource.getRandomNumberTrivia;

      expect(() => call(), throwsA(TypeMatcher<ServerException>()));
    });
  });
}