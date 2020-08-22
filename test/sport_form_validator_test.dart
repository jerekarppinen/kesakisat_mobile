import 'package:flutter_test/flutter_test.dart';
import 'package:kesakisat_mobile/sport_form.dart';

void main() {
  test('empty sport name returns error string', () {
    String result = SportFormValidator.validate('');
    expect(result, 'Nimi on pakollinen');
  });

  test('non-empty sport name returns null', () {
    String result = SportFormValidator.validate('Mölkky');
    expect(result, null);
  });

}