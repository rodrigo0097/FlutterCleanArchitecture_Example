import 'package:dartz/dartz.dart';
import 'package:flutter_clean_achitecture/core/error/exceptions.dart';
import 'package:flutter_clean_achitecture/core/error/failure.dart';
import 'package:flutter_clean_achitecture/core/platform/network_info.dart';
import 'package:flutter_clean_achitecture/features/number_trivia/data/datasources/number_trivia_local_data_sources.dart';
import 'package:flutter_clean_achitecture/features/number_trivia/data/datasources/number_trivia_remote_data_sources.dart';
import 'package:flutter_clean_achitecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_clean_achitecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class NumberTriviaRepositoryImpl implements NumberTriviaRepository{
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo});

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
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() {
    // TODO: implement getRandomNumberTrivia
    throw UnimplementedError();
  }

}