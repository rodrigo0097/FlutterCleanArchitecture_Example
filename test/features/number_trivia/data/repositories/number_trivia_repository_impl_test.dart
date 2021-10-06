import 'package:dartz/dartz.dart';
import 'package:flutter_clean_achitecture/core/error/exceptions.dart';
import 'package:flutter_clean_achitecture/core/error/failure.dart';
import 'package:flutter_clean_achitecture/core/network/network_info.dart';
import 'package:flutter_clean_achitecture/features/number_trivia/data/datasources/number_trivia_local_data_sources.dart';
import 'package:flutter_clean_achitecture/features/number_trivia/data/datasources/number_trivia_remote_data_sources.dart';
import 'package:flutter_clean_achitecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_clean_achitecture/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:flutter_clean_achitecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource{}

class MockLocalDataSource extends Mock
    implements NumberTriviaLocalDataSource{}

class MockNetworkInfo extends Mock
    implements NetworkInfo{}

void main(){
late NumberTriviaRepositoryImpl repository;
late MockRemoteDataSource mockRemoteDataSource;
late MockLocalDataSource mockLocalDataSource;
late MockNetworkInfo mockNetworkInfo;

setUp(() {
mockRemoteDataSource = MockRemoteDataSource();
mockLocalDataSource = MockLocalDataSource();
mockNetworkInfo = MockNetworkInfo();
repository = NumberTriviaRepositoryImpl(
  remoteDataSource: mockRemoteDataSource,
  localDataSource: mockLocalDataSource,
  networkInfo: mockNetworkInfo,
);
});
void runTestsOnline(Function body){
  group('device is online', (){
    setUp(() {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    });
    body();
  });
}
void runTestsOffline(Function body){
  group('device is online', (){
    setUp(() {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
    });
    body();
  });
}
group('getConcreteNumberTrivia',(){
  final tNumber = 1;
  final tNumberTriviaModel = NumberTriviaModel(number:tNumber, text: 'test' );
  final NumberTrivia tNumberTrivia =  tNumberTriviaModel;
  test(
    'should check if the device is online',
        () async {
      // arrange
          /**
           * se útiliza thenAnswer() porque corresponde
           * a una respuesta futura (asincrona), en caso contrario se útilizaría
           * thenReturns ()
            */
      when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
              .thenAnswer((_) async => tNumberTriviaModel);
      when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
          .thenAnswer((_) async => NumberTriviaModel(text: 'test', number: 42));
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      //act
      repository.getConcreteNumberTrivia(tNumber);
      //assert
      verify(() => mockNetworkInfo.isConnected);
    },
  );
  runTestsOnline((){
    test(
        'should return remote data when the call to remote data source in success',
        () async {
          // arrange
          when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
              .thenAnswer((_) async => NumberTriviaModel(text: 'test', number: 42));
          when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
              .thenAnswer((_) async => tNumberTriviaModel);
          //act
          final result = await repository.getConcreteNumberTrivia(tNumber);
          //assert
          verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          //el equals puede ser omitido, pero lo dejo por legibilidad
          expect(result, equals(Right(tNumberTrivia)));
        },
      );
    test(
      'should cache the data locally when the call to remote data source in success',
          () async {
        // arrange
        when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
            .thenAnswer((_) async => NumberTriviaModel(text: 'test', number: 42));
        when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        await repository.getConcreteNumberTrivia(tNumber);
        //assert
        verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        //el equals puede ser omitido, pero lo dejo por legibilidad
        verify(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      },
    );
    test(
      'should return server failure when the call to remote data source in unsuccess',
          () async {
        // arrange
        when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenThrow(serverException());
        //act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        //assert
        verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verifyZeroInteractions(mockLocalDataSource);
        //el equals puede ser omitido, pero lo dejo por legibilidad
        expect(result, equals(Left(ServerFailure())));
      },
    );
    });
  runTestsOffline((){
    test(
        'should return the last locally cached data when the cached data is present',
        () async {
          // arrange
          when(() => mockLocalDataSource.getLastNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          //act
          final result = await repository.getConcreteNumberTrivia(tNumber);
          //assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(() => mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Right(tNumberTrivia)));
        },
      );
    test(
      'should return CacheFailure when there is no cached data present',
          () async {
        // arrange
        when(() => mockLocalDataSource.getLastNumberTrivia())
            .thenThrow(cacheException());
        //act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      },
    );
    });
});

group('getRandomNumberTrivia',(){
  final tNumberTriviaModel = NumberTriviaModel(number:123 , text: 'test' );
  final NumberTrivia tNumberTrivia =  tNumberTriviaModel;
  test(
    'should check if the device is online',
        () async {
      // arrange
      /**
       * se útiliza thenAnswer() porque corresponde
       * a una respuesta futura (asincrona), en caso contrario se útilizaría
       * thenReturns ()
       */
      when(() => mockRemoteDataSource.getRandomNumberTrivia())
          .thenAnswer((_) async => tNumberTriviaModel);
      when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
          .thenAnswer((_) async => NumberTriviaModel(text: 'test', number: 42));
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      //act
      repository.getRandomNumberTrivia();
      //assert
      verify(() => mockNetworkInfo.isConnected);
    },
  );
  runTestsOnline((){
    test(
      'should return remote data when the call to remote data source in success',
          () async {
        // arrange
        when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
            .thenAnswer((_) async => NumberTriviaModel(text: 'test', number: 42));
        when(() => mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        final result = await repository.getRandomNumberTrivia();
        //assert
        verify(() => mockRemoteDataSource.getRandomNumberTrivia());
        //el equals puede ser omitido, pero lo dejo por legibilidad
        expect(result, equals(Right(tNumberTrivia)));
      },
    );
    test(
      'should cache the data locally when the call to remote data source in success',
          () async {
        // arrange
        when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
            .thenAnswer((_) async => NumberTriviaModel(text: 'test', number: 42));
        when(() => mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        await repository.getRandomNumberTrivia();
        //assert
        verify(() => mockRemoteDataSource.getRandomNumberTrivia());
        //el equals puede ser omitido, pero lo dejo por legibilidad
        verify(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      },
    );
    test(
      'should return server failure when the call to remote data source in unsuccess',
          () async {
        // arrange
        when(() => mockRemoteDataSource.getRandomNumberTrivia())
            .thenThrow(serverException());
        //act
        final result = await repository.getRandomNumberTrivia();
        //assert
        verify(() => mockRemoteDataSource.getRandomNumberTrivia());
        verifyZeroInteractions(mockLocalDataSource);
        //el equals puede ser omitido, pero lo dejo por legibilidad
        expect(result, equals(Left(ServerFailure())));
      },
    );
  });
  runTestsOffline((){
    test(
      'should return the last locally cached data when the cached data is present',
          () async {
        // arrange
        when(() => mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        final result = await repository.getRandomNumberTrivia();
        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Right(tNumberTrivia)));
      },
    );
    test(
      'should return CacheFailure when there is no cached data present',
          () async {
        // arrange
        when(() => mockLocalDataSource.getLastNumberTrivia())
            .thenThrow(cacheException());
        //act
        final result = await repository.getRandomNumberTrivia();
        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      },
    );
  });
});


}