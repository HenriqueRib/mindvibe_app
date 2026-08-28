import 'package:flutter_test/flutter_test.dart';
import 'package:mindvibe_app/core/network/media_url.dart';

void main() {
  test('troca localhost pelo host da API no emulador', () {
    expect(
      MediaUrl.resolve(
        'http://localhost:8000/storage/audio/pt-BR/foco/dia-01-introducao.mp3',
        apiUrl: 'http://10.0.2.2:8000/api/v1',
      ),
      'http://10.0.2.2:8000/storage/audio/pt-BR/foco/dia-01-introducao.mp3',
    );
  });

  test('mantém URL remota intacta', () {
    const url = 'https://mindvibe.codeline43.com.br/storage/audio/ninar.mp3';
    expect(MediaUrl.resolve(url), url);
  });
}
