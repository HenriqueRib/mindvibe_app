import 'package:mindvibe_app/core/error/result.dart';
import 'package:mindvibe_app/core/network/api_client.dart';

class FeedbackRemote {
  FeedbackRemote(this._client);

  final ApiClient _client;

  Future<Result<void>> send({
    required String type,
    required String message,
    required String platform,
  }) {
    return _client.post(
      '/me/messages',
      body: {'type': type, 'message': message, 'platform': platform},
      parse: (_) {},
    );
  }
}
