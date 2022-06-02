import 'package:clean_arch/core/usecases/usecase.dart';
import 'package:clean_arch/features/domain/entities/number_trivia.dart';
import 'package:clean_arch/features/domain/repository/number_trivia_repository.dart';
import 'package:clean_arch/features/domain/usecases/get_random_number_trivia.dart';
import 'package:dartz/dartz.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNumberTriviaRepository extends Mock implements NumberTriviaRepository{
}

void main(){
  late GetRandomNumberTrivia? usecase;
  late MockNumberTriviaRepository mockNumberTriviaRepository;
  setUp((){
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(mockNumberTriviaRepository);
  });


  const tNumberTrivia = NumberTrivia(text: "test", number: 1);
  test("should get trivia from the repository", ()async{

      when(()=> mockNumberTriviaRepository.getRandomNumberTrivia()).thenAnswer((_) async =>  const Right(tNumberTrivia));

      final result = await usecase!(NoParams());

      expect(result, const Right(tNumberTrivia));
      verify((() =>  mockNumberTriviaRepository.getRandomNumberTrivia()));
      verifyNoMoreInteractions(mockNumberTriviaRepository);

  });
}