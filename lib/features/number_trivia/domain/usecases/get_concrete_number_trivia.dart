import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_clean_achitecture/core/error/failure.dart';
import 'package:flutter_clean_achitecture/core/usecases/usecase.dart';
import 'package:meta/meta.dart';
import '../entities/number_trivia.dart';
import '../repositories/number_trivia_repository.dart';

/**
 * para todos los casos de uso se va a implementar la clase abstracta useCase
 * la idea es hacer una implementación obligatoria del callable method
 * para cada una de las clases de los casos de uso
 */

class GetConcreteNumberTrivia implements useCase<NumberTrivia, Params> {
  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia(this.repository);
// el nombre de la función de call para funcionar como callable method
  @override
  Future<Either<Failure, NumberTrivia>> call(Params params
  ) async {
    return await repository.getConcreteNumberTrivia(params.number);
  }
}

class Params extends Equatable{
  final int number;
  const Params({required this.number});
  @override
  List<Object> get props => [number];}