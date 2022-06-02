import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../entities/number_trivia.dart';
import '../repository/number_trivia_repository.dart';

class GetConcreteNumberTrivia implements UseCase<NumberTrivia, Params>{
  final NumberTriviaRepository repository;
  GetConcreteNumberTrivia(this.repository);
  
  //  api.com/42
  // api.com/random



  @override
  Future<Either<Failure,NumberTrivia?>?>? call(Params params)async{
     return await repository.getConcreteNumberTrivia(params.number);
  }
}


class Params extends Equatable{
  final int number;
  
  const Params({required this.number});
  
  @override
  List<Object?> get props => [number];
  
}