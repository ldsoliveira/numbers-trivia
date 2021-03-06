import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:numbers_trivia/core/network/network_info.dart';
import 'package:numbers_trivia/core/util/input_converter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:numbers_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:numbers_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:numbers_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:numbers_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:numbers_trivia/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:numbers_trivia/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';

GetIt sl = GetIt.instance;

Future<void> init() async {
  //! Features 
  // Bloc
  sl.registerFactory(() => NumberTriviaBloc(
    getConcreteNumberTrivia: sl(), 
    getRandomNumberTrivia: sl(), 
    inputConverter: sl(),
  ));

  // Usecases
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));

  // Repository
  sl.registerLazySingleton<NumberTriviaRepository>(() => NumberTriviaRepositoryImpl(
    remoteDataSource: sl(), 
    localDataSource: sl(), 
    networkInfo: NetworkInfoImpl(sl()),
  ));

  // Datasources
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(() => 
    NumberTriviaRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<NumberTriviaLocalDataSource>(() => 
    NumberTriviaLocalDataSourceImpl(sharedPreferences: sl()));

  //! Core
  sl.registerLazySingleton(() => InputConverter());

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}