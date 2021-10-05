import 'package:dartz/dartz.dart';
import 'package:flutter_clean_achitecture/core/platform/network_info.dart';
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
      when(() => mockRemoteDataSource.getConcreteNumberTrivia(any()))
          .thenAnswer((_) async => NumberTriviaModel(text: 'test', number: 42));
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      //act
      repository.getConcreteNumberTrivia(tNumber);
      //assert
      verify(() => mockNetworkInfo.isConnected);
    },
  );
  group('device is online',(){
    setUp((){
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    });
    test(
        'should return remote data when the call to remote data source in success',
        () async {
          // arrange
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
    });
  group('device is offline',(){
    setUp((){
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
    });
  });
});
}