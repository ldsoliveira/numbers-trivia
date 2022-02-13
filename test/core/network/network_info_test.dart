import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:numbers_trivia/core/network/network_info.dart';


class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

void main() {
  MockDataConnectionChecker mockDataConnectionChecker = MockDataConnectionChecker();
  NetworkInfoImpl networkInfoImpl = NetworkInfoImpl(mockDataConnectionChecker);

  group('isConnected', () {
    test('should forward the call to DataConnectionChecker.hasConnection', () async {
      final testHasConnectionFuture = Future.value(true);

      when(mockDataConnectionChecker.hasConnection)
        .thenAnswer((_) => testHasConnectionFuture);

      final result = networkInfoImpl.isConnected;

      verify(mockDataConnectionChecker.hasConnection);
      expect(result, testHasConnectionFuture);
    });
  });
}