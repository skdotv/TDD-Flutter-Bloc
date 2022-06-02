import '../models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource{
///Gets the last Number Trivia data when internet connection was active
///
///
  Future<NumberTriviaModel?>? getLastNumberTrivia();


  Future<void>? cacheNumberTrivia(NumberTriviaModel? triviaModel);
}