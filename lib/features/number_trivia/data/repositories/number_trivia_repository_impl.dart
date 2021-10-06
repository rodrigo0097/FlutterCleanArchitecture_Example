import 'package:dartz/dartz.dart';
import 'package:flutter_clean_achitecture/core/error/exceptions.dart';
import 'package:flutter_clean_achitecture/core/error/failure.dart';
import 'package:flutter_clean_achitecture/core/network/network_info.dart';
import 'package:flutter_clean_achitecture/features/number_trivia/data/datasources/number_trivia_local_data_sources.dart';
import 'package:flutter_clean_achitecture/features/number_trivia/data/datasources/number_trivia_remote_data_sources.dart';
import 'package:flutter_clean_achitecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_clean_achitecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_clean_achitecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';

typedef Future<NumberTriviaModel> _ConcreteOrRandomChooser();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository{
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo});

  /**
   * el presente es el código de cada una de las funciones separadas,
   * en el método de acabo se combinan útilizando la funcionalidad de dart
   * de funciones de alto orden
   *

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number,) async {

    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await remoteDataSource.getConcreteNumberTrivia(
            number);
        //TODO este await puede joderme la compilación
        localDataSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on serverException {
        return Left(ServerFailure());
      }
    } else {
      try{
        final cache = await localDataSource.getLastNumberTrivia();
        return Right(cache);
      } on cacheException {
        return Left(CacheFailure());
      }



    }

  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {

    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await remoteDataSource.getRandomNumberTrivia();
        //TODO este await puede joderme la compilación
        localDataSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on serverException {
        return Left(ServerFailure());
      }
    } else {
      try{
        final cache = await localDataSource.getLastNumberTrivia();
        return Right(cache);
      } on cacheException {
        return Left(CacheFailure());
      }



    }
  }
   */
  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number,) async {
    return await _getTrivia((){
      return remoteDataSource.getConcreteNumberTrivia(number);
    });
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getTrivia(() {
      return remoteDataSource.getRandomNumberTrivia();
    });
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(
      _ConcreteOrRandomChooser getConcreteOrRandom
      )async {


    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await getConcreteOrRandom();
        //TODO este await puede joderme la compilación
        localDataSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on serverException {
        return Left(ServerFailure());
      }
    } else {
      try{
        final cache = await localDataSource.getLastNumberTrivia();
        return Right(cache);
      } on cacheException {
        return Left(CacheFailure());
      }



    }

  }

}