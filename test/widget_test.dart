import 'package:flutter_test/flutter_test.dart';
import 'package:mindvibe_app/features/auth/domain/auth_validators.dart';

void main() {
  test('e-mail válido passa na validação', () {
    expect(AuthValidators.isEmail('ana@gmail.com'), isTrue);
  });
}
