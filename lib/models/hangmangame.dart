import 'package:http/http.dart' as http;

class HangmanGame {
  String _word;
  String _correctGuesses = "";
  String _wrongGuesses = "";

  //Constructor starts off with blank strings that we will concatenate during the course of play
  HangmanGame(String word) {
    _word = word;
    _correctGuesses = "";
    _wrongGuesses = "";
  }

  String correctGuesses() {
    return _correctGuesses;
  }

  String wrongGuesses() {
    return _wrongGuesses;
  }

  String word() {
    return _word;
  }

  bool guess(String letter) {
    if (RegExp(r'^[A-Za-z]').hasMatch(letter) &&
        letter != '' &&
        letter != null &&
        letter.length == 1) {
      if (_correctGuesses.contains(letter.toLowerCase()) ||
          _wrongGuesses.contains(letter.toLowerCase())) return false;
      if (_word.contains(letter)) {
        _correctGuesses += letter;
      } else {
        _wrongGuesses += letter;
      }
      return true;
    }
    throw ArgumentError();
  }

  String blanksWithCorrectGuesses() {
    String partialWord = "";
    for (int i = 0; i < _word.length; i++) {
      if (_correctGuesses.contains(_word[i])) {
        partialWord += _word[i];
      } else {
        partialWord += '-';
      }
    }
    return partialWord;
  }

  String status() {
    if (blanksWithCorrectGuesses() == _word)
      return 'win';
    else if (_wrongGuesses.length == 7)
      return 'lose';
    else
      return 'play';
  }

  //when running integration tests always return "banana"
  static Future<String> getStartingWord(bool areWeInIntegrationTest) async {
    String word;
    Uri endpoint = Uri.parse("http://randomword.saasbook.info/RandomWord");
    if (areWeInIntegrationTest) {
      word = "banana";
    } else {
      try {
        var response = await http.post(endpoint);
        word = response.body;
      } catch (e) {
        word = "error";
      }
    }

    return word;
  }
}
