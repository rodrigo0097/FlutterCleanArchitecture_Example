import 'dart:convert';
import 'dart:io';

import 'package:flutter_clean_achitecture/core/error/exceptions.dart';
import 'package:flutter_clean_achitecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
//esta primera clase corresponde al contrato del data source para TDD
abstract class NumberTriviaLocalDataSource{
  // Gets the cached [NumberTriviaModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

//esta es la implementación del contrato de la local DS
const CACHED_NUMBER_TRIVIA = 'CACHED_NUMBER_TRIVIA';
class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) {
    sharedPreferences.setString(CACHED_NUMBER_TRIVIA, json.encode(triviaToCache.toJson()));

    }

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final jsonString = sharedPreferences.getString(CACHED_NUMBER_TRIVIA);
    if(jsonString != null)
    {
      //TODO: puede que el jsonString! genere problemas
      return Future.value(NumberTriviaModel.fromJson(json.decode(jsonString)));
    } else {
      throw cacheException();
    }
  }
  
}