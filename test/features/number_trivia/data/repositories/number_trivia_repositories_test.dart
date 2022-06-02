import 'package:clean_arch/core/error/exceptions.dart';
import 'package:clean_arch/core/error/failures.dart';
import 'package:clean_arch/core/platform/network_info.dart';
import 'package:clean_arch/features/data/data_sources/number_trivia_local_data_source.dart';
import 'package:clean_arch/features/data/data_sources/number_trivia_repo_data_source.dart';
import 'package:clean_arch/features/data/models/number_trivia_model.dart';
import 'package:clean_arch/features/data/repositories/number_trivia_repository_implementaion.dart';
import 'package:clean_arch/features/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_test/flutter_test.dart';

class MockRemoteDataSource extends Mock implements NumberTriviaRemoteDataSource{}
class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource{}
class MockNetwokInfo extends Mock implements NetworkInfo{}



void main() {
  
  late NumberTriviaRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetwokInfo mockNetwokInfo;
  setUp((){
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetwokInfo = MockNetwokInfo();
    repository  = NumberTriviaRepositoryImpl(    
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo:mockNetwokInfo  
    );
  });

      group('getConcreteNumberTrivia', (){
        const int tNumber = 1;
        const  tNumberTriviaModel = NumberTriviaModel(text: "test trivia", number: tNumber);
        const  NumberTrivia tNumberTrivia = tNumberTriviaModel;
        test("should check if the device is online ", () async {
            // arrange
            when(() => mockNetwokInfo.isConnected).thenAnswer((_) async => true);
            // act
            await repository.getConcreteNumberTrivia(1);
            // assert
            verify((() => mockNetwokInfo.isConnected));

        });

        group("device is online", (){

              setUp(
                (){
                  when(() => mockNetwokInfo.isConnected).thenAnswer((_) async => true);
                }
              );

              // 
              test('should rerturn remote data when the call to remote data source is successful', ()async{

               // arrange 
                when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber)).thenAnswer((_) async => tNumberTriviaModel);

               // action 

                final result = await repository.getConcreteNumberTrivia(tNumber);

               // assert 

                verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
                expect(result,  equals(const Right(tNumberTrivia)));

               
                
               
               
            });

            test("sould cache data locally when the call to remote data source is sucessful", (()async {
                // arrange 
                when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber)).thenAnswer((_) async => tNumberTriviaModel);
                // action 
                
                await repository.getConcreteNumberTrivia(tNumber); 
                // assert 

                verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
                verify(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
                
                
            }));


            test("sould return server failure when the call to remote data source is unsucessful", (() async{ 

              // arrange 
                when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber)).thenThrow(ServerException());              
              
              // action 
              final result = await repository.getConcreteNumberTrivia(tNumber);
               
              // assert 

              verify(()=>mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
              verifyZeroInteractions(mockLocalDataSource);
              expect(result, equals(Left(ServerFailure())));
          
            }));

        group("device is offline ", (){

            setUp((){
              
              when(() => mockNetwokInfo.isConnected).thenAnswer((_) async=> false);

            });
            test("should return local data when the call to local data source", ()async{
             
              
                
            });

        });




      });

});
}