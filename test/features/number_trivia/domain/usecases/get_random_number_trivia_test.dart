
import 'package:dartz/dartz.dart';
import 'package:flutter_clean_achitecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_clean_achitecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_clean_achitecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_clean_achitecture/features/number_trivia/domain/usecases/get_number_random_trivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

//setup method runs first in test and here we initialize all objects.
void main() {
  late GetRandomNumberTrivia useCase;
  late MockNumberTriviaRepository mockNumberTriviaRepository;
  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    useCase = GetRandomNumberTrivia(mockNumberTriviaRepository);
  });
  final tNumberTrivia = NumberTrivia(number: 1, text: 'text');
  test('should get trivia from the repository', () async {
    //arrange
    // Right hace referencia a el caso exitoso
    when(() => mockNumberTriviaRepository.getRandomNumberTrivia())
        .thenAnswer((_) async => Right(tNumberTrivia));
    //act
    // invoca el método callable, por lo que no hace useCase.call
    final result = await useCase(NoParams());
    //assert
    expect(result, Right(tNumberTrivia));
    verify(() => mockNumberTriviaRepository.getRandomNumberTrivia());
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}