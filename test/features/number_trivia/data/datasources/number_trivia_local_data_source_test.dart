import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:numbers_trivia/core/errors/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:numbers_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:numbers_trivia/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  MockSharedPreferences mockSharedPreferences = MockSharedPreferences();
  NumberTriviaLocalDataSourceImpl dataSource = 
    NumberTriviaLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);

  group('getLastNumberTrivia', () {
    final testNumberTriviaModel = NumberTriviaModel.fromJson(fixture('trivia_cached.json'));

    test('should return NumberTrivia from SharedPreferences when there is one in cache', () async {
      when(mockSharedPreferences.getString(any))
        .thenReturn(fixture('trivia_cached.json'));

      final result = await dataSource.getLastNumberTrivia();

      verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
      expect(result, testNumberTriviaModel);
    });

    test('should throw CacheException when there is not a cached value', () async {
      when(mockSharedPreferences.getString(any))
        .thenReturn(null);

      final call = dataSource.getLastNumberTrivia;

      expect(() => call(), throwsA(TypeMatcher<CacheException>()));
    });
  });

  group('cacheNumberTrivia', () {
    final testNumberTriviaModel = NumberTriviaModel(text: 'Test text', number: 1);

    test('should call SharedPreferences to cache the data', () {
      dataSource.cacheNumberTrivia(testNumberTriviaModel);

      final expectedJson = testNumberTriviaModel.toJson();

      verify(mockSharedPreferences.setString(CACHED_NUMBER_TRIVIA, expectedJson));
    });
  });
}