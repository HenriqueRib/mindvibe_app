class AppConfig {
  const AppConfig._();

  static const String apiUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://mindvibe.codeline43.com.br/api/v1',
  );

  static const String v1FocusProgramSlug = '7-dias-foco';

  static const Map<String, String> programSlugByGoal = {
    'focus': '7-dias-foco',
    'memory': '5-dias-memoria',
    'relaxation': '6-dias-relaxamento',
    'sleep': '7-dias-sono',
    'habit': '7-dias-foco',
    'breathing': '3-dias-respiracao',
    'mindfulness': '5-dias-atencao-plena',
  };

  static String programSlugForGoals(Iterable<String> goals) {
    for (final goal in goals) {
      final slug = programSlugByGoal[goal];
      if (slug != null) {
        return slug;
      }
    }
    return v1FocusProgramSlug;
  }

  static String get siteUrl {
    final api = Uri.parse(apiUrl);
    final path = api.path.replaceFirst(RegExp(r'/api/v1/?$'), '');
    return api
        .replace(path: path.isEmpty ? '/' : path, query: '', fragment: '')
        .toString()
        .replaceFirst(RegExp(r'/$'), '');
  }

  static String get termsUrl => '$siteUrl/termos';
  static String get privacyUrl => '$siteUrl/privacidade';
}
