import 'package:mindvibe_app/core/config/app_config.dart';

class MediaUrl {
  const MediaUrl._();

  static String resolve(String url, {String apiUrl = AppConfig.apiUrl}) {
    final media = Uri.tryParse(url);
    if (media == null || !media.hasScheme) {
      return url;
    }
    final api = Uri.parse(apiUrl);
    final loopback =
        media.host == 'localhost' ||
        media.host == '127.0.0.1' ||
        media.host == '::1';
    if (!loopback) {
      return url;
    }
    return media
        .replace(
          host: api.host,
          port: api.hasPort
              ? api.port
              : media.hasPort
              ? media.port
              : null,
        )
        .toString();
  }
}
