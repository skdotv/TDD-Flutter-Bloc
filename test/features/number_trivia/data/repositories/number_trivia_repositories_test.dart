import 'package:clean_arch/core/error/exceptions.dart';
import 'package:clean_arch/core/error/failures.dart';
import 'package:clean_arch/core/network/network_info.dart';
import 'package:clean_arch/features/data/data_sources/number_trivia_local_data_source.dart';
import 'package:clean_arch/features/data/data_sources/number_trivia_repo_data_source.dart';
import 'package:clean_arch/features/data/models/number_trivia_model.dart';
import 'package:clean_arch/features/data/repositories/number_trivia_repository_implementaion.dart';
import 'package:clean_arch/features/domain/entities/number_trivia.dart';
import 'package:clean_arch/features/domain/usecases/get_concrete_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_test/flutter_test.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetwokInfo extends Mock implements NetworkInfo {}

void main() {
  late NumberTriviaRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetwokInfo mockNetwokInfo;
  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetwokInfo = MockNetwokInfo();
    repository = NumberTriviaRepositoryImpl(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
        networkInfo: mockNetwokInfo);
  });

  void runTestOnline(Function body) {
    group("device is online", () {
      setUp(() {
        when(() => mockNetwokInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runTestOffline(Function body) {
    group("device offline", () {
      setUp(() {
        when(() => mockNetwokInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }

  group('getConcreteNumberTrivia', () {
    const int tNumber = 1;
    const tNumberTriviaModel =
        NumberTriviaModel(text: "test trivia", number: tNumber);
    const NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test("should check if the device is online ", () async {
      // arrange
      when(() => mockNetwokInfo.isConnected).thenAnswer((_) async => true);
      // act
      await repository.getConcreteNumberTrivia(1);
      // assert
      verify((() => mockNetwokInfo.isConnected));
    });

    runTestOnline(() {
      test(
          'should rerturn remote data when the call to remote data source is successful',
          () async {
        // arrange
        when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenAnswer((_) async => tNumberTriviaModel);

        // action

        final result = await repository.getConcreteNumberTrivia(tNumber);

        // assert

        verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        expect(result, equals(const Right(tNumberTrivia)));
      });
      test(
          "sould cache data locally when the call to remote data source is sucessful",
          (() async {
        // arrange
        when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenAnswer((_) async => tNumberTriviaModel);
        // action

        await repository.getConcreteNumberTrivia(tNumber);
        // assert

        verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verify(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      }));
      test(
          "sould return server failure when the call to remote data source is unsucessful",
          (() async {
        // arrange
        when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenThrow(ServerException());

        // action
        final result = await repository.getConcreteNumberTrivia(tNumber);

        // assert

        verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      }));
    
    });

      runTestOffline(() {
        test(
            "should return last locally cached data when the cached data is present",
            () async {
          // arrange

          when(() => mockLocalDataSource.getLastNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // act

          final result = await repository.getConcreteNumberTrivia(tNumber);

          // assert
          verifyZeroInteractions(mockRemoteDataSource);

          verify(() => mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(const Right(tNumberTrivia)));
        });

        test(
            "should return last cachedfailure data when there is no cached data present",
            (() async {
          // arrange
          when(() => mockLocalDataSource.getLastNumberTrivia())
              .thenThrow(CacheException());

          // action

          final result = await repository.getConcreteNumberTrivia(tNumber);

          verifyNoMoreInteractions(mockRemoteDataSource);
          verify(() => mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Left(CacheFailure())));

          // assert
        }));
      });
    });
  
// 
// Get Random Number trivia
// 



  group('get Random Number trivia', () {
    const int tNumber = 1;
    const tNumberTriviaModel =
        NumberTriviaModel(text: "test trivia", number: tNumber);
    const NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test("should check if the device is online ", () async {
      // arrange
      when(() => mockNetwokInfo.isConnected).thenAnswer((_) async => true);
      // act
      await repository.getRandomNumberTrivia();
      // assert
      verify((() => mockNetwokInfo.isConnected));
    });

    runTestOnline(() {
      test(
          'should rerturn remote data when the call to remote data source is successful',
          () async {
        // arrange
        when(() => mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        // action

        final result = await repository.getRandomNumberTrivia();

        // assert

        verify(() => mockRemoteDataSource.getRandomNumberTrivia());
        expect(result, equals(const Right(tNumberTrivia)));
      });
      test(
          "sould cache data locally when the call to remote data source is sucessful",
          (() async {
        // arrange
        when(() => mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        // action

        await repository.getRandomNumberTrivia();
        // assert

        verify(() => mockRemoteDataSource.getRandomNumberTrivia());
        verify(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      }));
      test(
          "sould return server failure when the call to remote data source is unsucessful",
          (() async {
        // arrange
        when(() => mockRemoteDataSource.getRandomNumberTrivia())
            .thenThrow(ServerException());

        // action
        final result = await repository.getRandomNumberTrivia();

        // assert

        verify(() => mockRemoteDataSource.getRandomNumberTrivia());
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      }));
    
    });

      runTestOffline(() {
        test(
            "should return last locally cached data when the cached data is present",
            () async {
          // arrange

          when(() => mockLocalDataSource.getLastNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // act

          final result = await repository.getRandomNumberTrivia();

          // assert
          verifyZeroInteractions(mockRemoteDataSource);

          verify(() => mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(const Right(tNumberTrivia)));
        });

        test(
            "should return last cachedfailure data when there is no cached data present",
            (() async {
          // arrange
          when(() => mockLocalDataSource.getLastNumberTrivia())
              .thenThrow(CacheException());

          // action

          final result = await repository.getRandomNumberTrivia();

          verifyNoMoreInteractions(mockRemoteDataSource);
          verify(() => mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Left(CacheFailure())));

          // assert
        }));
      });
    });
  
}



