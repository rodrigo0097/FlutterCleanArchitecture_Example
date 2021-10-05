import 'package:flutter_clean_achitecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_clean_achitecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tNumberTriviaModel = NumberTriviaModel(number: 1, text: "test");
  test(
    'should be a subclass of NumberTrivia entity',
    () async {
      // arrange
      expect(tNumberTriviaModel, isA<NumberTrivia>());
      //act

      //assert
    },
  );
}
