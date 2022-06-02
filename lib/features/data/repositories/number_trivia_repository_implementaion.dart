import 'package:clean_arch/features/data/models/number_trivia_model.dart';

import '../../../core/error/exceptions.dart';
import '../../../core/network/network_info.dart';
import '../data_sources/number_trivia_local_data_source.dart';
import '../data_sources/number_trivia_repo_data_source.dart';
import '../../domain/entities/number_trivia.dart';
import '../../../core/error/failures.dart';
import '../../domain/repository/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';

//Type def


typedef Future<NumberTriviaModel?>? _ConcreteOrRandomChosed();
class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl(
      {required this.remoteDataSource,
      required this.localDataSource,
      required this.networkInfo});

  @override
  Future<Either<Failure, NumberTrivia?>?>? getConcreteNumberTrivia(
      int number) async {
    return await _getTrivia((){
      return remoteDataSource.getConcreteNumberTrivia(number);
    });
  }

  Future<Either<Failure, NumberTrivia?>> _getTrivia(_ConcreteOrRandomChosed getConcreteOrRandom ) async {
     if (await networkInfo.isConnected) {
      try {
        final remoteTrivia =
            await getConcreteOrRandom();
        await localDataSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final getLastTrivia = await localDataSource.getLastNumberTrivia();
        return Right(getLastTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, NumberTrivia?>?>? getRandomNumberTrivia() async {
    return await _getTrivia((){
      return remoteDataSource.getRandomNumberTrivia();
    });
  }
}
