import 'package:flutter_clean_achitecture/features/number_trivia/domain/entities/number_trivia.dart';

class NumberTriviaModel extends NumberTrivia{
  //revisar el const - podría llegar a generarme problemas
  const NumberTriviaModel({
    required String text,
    required int number
}) : super(text: text, number: number);

  factory NumberTriviaModel.fromJson(Map<String, dynamic> json){
    return NumberTriviaModel(
        text: json['text'], number: json['number']
    );
  }
}