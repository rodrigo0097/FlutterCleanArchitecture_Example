import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_clean_achitecture/core/error/failure.dart';
import 'package:flutter_clean_achitecture/core/usecases/usecase.dart';
import 'package:flutter_clean_achitecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_clean_achitecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_clean_achitecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';

class GetRandomNumberTrivia implements useCase<NumberTrivia, NoParams>{
  final NumberTriviaRepository repository;

  GetRandomNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams params
      ) async {
    return await repository.getRandomNumberTrivia();
  }

}
class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
 }