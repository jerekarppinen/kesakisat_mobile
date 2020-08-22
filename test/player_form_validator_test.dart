import 'package:flutter_test/flutter_test.dart';
import 'package:kesakisat_mobile/player_form.dart';

void main() {
  test('empty player name returns error string', () {
    String result = PlayerFormValidator.validate('');
    expect(result, 'Nimi on pakollinen');
  });

  test('non-empty player name returns null', () {
    String result = PlayerFormValidator.validate('Seppo');
    expect(result, null);
  });

}