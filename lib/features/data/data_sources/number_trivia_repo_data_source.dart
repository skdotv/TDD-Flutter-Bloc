import 'package:clean_arch/features/data/models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDataSource{

/// Calls the api endpoint
///
///Throws [ServerException] for all error codes

Future<NumberTriviaModel>? getConcreteNumberTrivia(int number);

/// Calls the api endpoint
/// 
/// Throws a [ServerException] for all error codes

Future<NumberTriviaModel> getRandomNumberTrivia();
 
}