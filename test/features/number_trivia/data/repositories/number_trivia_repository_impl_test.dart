import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:numbers_trivia/core/errors/exceptions.dart';
import 'package:numbers_trivia/core/errors/failure.dart';
import 'package:numbers_trivia/core/plataform/network_info.dart';
import 'package:numbers_trivia/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:numbers_trivia/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:numbers_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:numbers_trivia/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:numbers_trivia/features/number_trivia/domain/entities/number_trivia.dart';

class MockRemoteDataSource extends Mock implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  MockRemoteDataSource mockRemoteDataSource = MockRemoteDataSource();
  MockLocalDataSource mockLocalDataSource = MockLocalDataSource();
  MockNetworkInfo mockNetworkInfo = MockNetworkInfo();

  NumberTriviaRepositoryImpl repository = NumberTriviaRepositoryImpl(
    localDataSource: mockLocalDataSource,
    networkInfo: mockNetworkInfo,
    remoteDataSource: mockRemoteDataSource
  );

  group('getConcreteNumberTrivia', () {
    final testNumber = 1;
    final testNumberTriviaModel = NumberTriviaModel(text: 'Test text', number: testNumber);
    final NumberTrivia testNumberTrivia  = testNumberTriviaModel;

    test('should check if the device is online', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      await repository.getConcreteNumberTrivia(testNumber);

      verify(mockNetworkInfo.isConnected);
    });
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test('should return remote data when the call to remote data source is sucessful', () async {
        when(mockRemoteDataSource.getConcreteNumberTrivia(any))
          .thenAnswer((_) async => testNumberTriviaModel);

        final result = await repository.getConcreteNumberTrivia(testNumber);

        verify(mockRemoteDataSource.getConcreteNumberTrivia(testNumber));
        expect(result, Right(testNumberTrivia));
      });

      test('should cache the data locally when the call to remote data source is sucessful', () async {
        when(mockRemoteDataSource.getConcreteNumberTrivia(testNumber))
          .thenAnswer((_) async => testNumberTriviaModel);

        await repository.getConcreteNumberTrivia(testNumber);

        verify(mockRemoteDataSource.getConcreteNumberTrivia(testNumber));
        verify(mockLocalDataSource.cacheNumberTrivia(testNumberTriviaModel));
      });

      test('should return ServerFailure when the call to remote data source is unsucessful', () async {
        when(mockRemoteDataSource.getConcreteNumberTrivia(any))
          .thenThrow(ServerException());

        final result = await repository.getConcreteNumberTrivia(testNumber);

        verify(mockRemoteDataSource.getConcreteNumberTrivia(testNumber));
        expect(result, Left(ServerFailure()));
      });
    });

    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should return last locally cached data when the cached data is present', () async {
        when(mockLocalDataSource.getLastNumberTrivia())
          .thenAnswer((_) async => testNumberTriviaModel);

        final result = await repository.getConcreteNumberTrivia(testNumber);

        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, Right(testNumberTrivia));
      });

      test('should return CacheFailure when there is no cached data present', () async {
        when(mockLocalDataSource.getLastNumberTrivia())
          .thenThrow(CacheException());

        final result = await repository.getConcreteNumberTrivia(testNumber);

        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, Left(CacheFailure()));
      });
    });
  });

  group('getRandomNumberTrivia', () {
    final testNumberTriviaModel = NumberTriviaModel(text: 'Test text', number: 1);
    final NumberTrivia testNumberTrivia  = testNumberTriviaModel;

    test('should check if the device is online', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      await repository.getRandomNumberTrivia();

      verify(mockNetworkInfo.isConnected);
    });
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test('should return remote data when the call to remote data source is sucessful', () async {
        when(mockRemoteDataSource.getRandomNumberTrivia())
          .thenAnswer((_) async => testNumberTriviaModel);

        final result = await repository.getRandomNumberTrivia();

        verify(mockRemoteDataSource.getRandomNumberTrivia());
        expect(result, Right(testNumberTrivia));
      });

      test('should cache the data locally when the call to remote data source is sucessful', () async {
        when(mockRemoteDataSource.getRandomNumberTrivia())
          .thenAnswer((_) async => testNumberTriviaModel);

        await repository.getRandomNumberTrivia();

        verify(mockRemoteDataSource.getRandomNumberTrivia());
        verify(mockLocalDataSource.cacheNumberTrivia(testNumberTriviaModel));
      });

      test('should return ServerFailure when the call to remote data source is unsucessful', () async {
        when(mockRemoteDataSource.getRandomNumberTrivia())
          .thenThrow(ServerException());

        final result = await repository.getRandomNumberTrivia();

        verify(mockRemoteDataSource.getRandomNumberTrivia());
        expect(result, Left(ServerFailure()));
      });
    });

    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should return last locally cached data when the cached data is present', () async {
        when(mockLocalDataSource.getLastNumberTrivia())
          .thenAnswer((_) async => testNumberTriviaModel);

        final result = await repository.getRandomNumberTrivia();

        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, Right(testNumberTrivia));
      });

      test('should return CacheFailure when there is no cached data present', () async {
        when(mockLocalDataSource.getLastNumberTrivia())
          .thenThrow(CacheException());

        final result = await repository.getRandomNumberTrivia();

        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, Left(CacheFailure()));
      });
    });
  });
}