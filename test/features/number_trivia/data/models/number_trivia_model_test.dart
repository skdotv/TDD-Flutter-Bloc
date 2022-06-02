import 'dart:convert';

import 'package:clean_arch/features/data/models/number_trivia_model.dart';
import 'package:clean_arch/features/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';



void main() {
  const tNumberTriviaModel = NumberTriviaModel(number:1, text:"Test Text");

  test("should be sub class of Number Trivia entity", ()async{
    // assert
    expect(tNumberTriviaModel, isA<NumberTrivia>());

  


  });  

  group("from Json", (() {


      test("should return a valid model from JSON numbe is an integer", ()async{
          // arrange
          final Map<String,dynamic> jsonMap = json.decode(fixture('trivia.json'));
          
          // act

        final result = NumberTriviaModel.fromJson(jsonMap);

          // assert
          expect(result,  tNumberTriviaModel);

      });

      test("should return a valid model when JSON number is regarder as a double", ()async{

        // arrange 
        final Map<String,dynamic> jsonMap = json.decode(fixture("trivia_double.json"));
        // act
        final result = NumberTriviaModel.fromJson(jsonMap);
        // assert
        expect(result, tNumberTriviaModel);
      });



  }));


    group("toJson", (){
        test("should return a JSON map containing the proper data", (()async {
            // arrange
            // act
            final result = tNumberTriviaModel.toJson();
            // assert
            final expectedMap = {
                "text":"Test Text",
                "number":1,
            };

            expect(result, expectedMap); 
             
        }));
    });

}