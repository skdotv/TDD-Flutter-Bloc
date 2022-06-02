import 'package:clean_arch/features/domain/entities/number_trivia.dart';
import 'package:clean_arch/features/domain/repository/number_trivia_repository.dart';
import 'package:clean_arch/features/domain/usecases/get_concrete_number_trivia.dart';
import 'package:dartz/dartz.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNumberTriviaRepository extends Mock implements NumberTriviaRepository{
}

void main(){
  late GetConcreteNumberTrivia? usecase;
  late MockNumberTriviaRepository mockNumberTriviaRepository;
  setUp((){
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
  });


  const tNumber = 1;
  const tNumberTrivia = NumberTrivia(text: "test", number: tNumber);
  test("should get trivia for the number from the repository", ()async{

      when(()=> mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber)).thenAnswer((_) async =>  Right(tNumberTrivia));

      final result = await usecase!(Params(number:tNumber));

      expect(result, const Right(tNumberTrivia));
      verify((() =>  mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber)));
      verifyNoMoreInteractions(mockNumberTriviaRepository);

  });



  }