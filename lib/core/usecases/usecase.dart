import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_clean_achitecture/core/error/failure.dart';

/**
 * clase abstracta que sirve como interfaz para manejar los casos de uso
 * como callable methods
 */
abstract class useCase<Type, Params>{
  Future<Either<Failure, Type>> call(Params params);
}
class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}