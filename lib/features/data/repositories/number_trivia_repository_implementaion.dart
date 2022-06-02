import 'package:clean_arch/core/error/exceptions.dart';
import 'package:clean_arch/core/platform/network_info.dart';
import 'package:clean_arch/features/data/data_sources/number_trivia_local_data_source.dart';
import 'package:clean_arch/features/data/data_sources/number_trivia_repo_data_source.dart';
import 'package:clean_arch/features/domain/entities/number_trivia.dart';
import 'package:clean_arch/core/error/failures.dart';
import 'package:clean_arch/features/domain/repository/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';
import '';

class NumberTriviaRepositoryImpl implements NumberTriviaRepository{
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({required this.remoteDataSource,required this.localDataSource,required this.networkInfo});

  @override
  Future<Either<Failure, NumberTrivia?>?>? getConcreteNumberTrivia(int number) async{

    try{
      networkInfo.isConnected;
      final remoteTrivia = await remoteDataSource.getConcreteNumberTrivia(number);
      await localDataSource.cacheNumberTrivia(remoteTrivia);
      return Right( await remoteDataSource.getConcreteNumberTrivia(number) );
    } on ServerException{
      
      return Left(ServerFailure());
    }

  }

  @override
  Future<Either<Failure, NumberTrivia>>? getRandomNumberTrivia() {
      return null;
  }
  
}