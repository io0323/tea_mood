class AppConstants {
  // Tea Types
  static const List<String> teaTypes = [
    'green',
    'black',
    'oolong',
    'herbal',
    'white',
    'pu-erh',
    'rooibos',
    'chamomile',
    'peppermint',
    'jasmine',
  ];

  // Mood Types
  static const List<String> moods = [
    'relaxed',
    'focused',
    'energized',
    'calm',
    'stressed',
    'happy',
    'tired',
    'alert',
    'peaceful',
    'anxious',
  ];

  // Default Caffeine Content (mg per 100ml)
  static const Map<String, int> defaultCaffeineContent = {
    'green': 20,
    'black': 40,
    'oolong': 30,
    'herbal': 0,
    'white': 15,
    'pu-erh': 35,
    'rooibos': 0,
    'chamomile': 0,
    'peppermint': 0,
    'jasmine': 20,
  };

  // Default Temperatures (Celsius)
  static const Map<String, int> defaultTemperatures = {
    'green': 70,
    'black': 95,
    'oolong': 85,
    'herbal': 100,
    'white': 65,
    'pu-erh': 95,
    'rooibos': 100,
    'chamomile': 100,
    'peppermint': 100,
    'jasmine': 70,
  };

  // Default Amounts (ml)
  static const List<int> defaultAmounts = [100, 150, 200, 250, 300];

  // Hive Box Names
  static const String teaLogsBox = 'tea_logs';
  static const String settingsBox = 'settings';

  // Shared Preferences Keys
  static const String themeKey = 'theme';
  static const String languageKey = 'language';
  static const String caffeineGoalKey = 'caffeine_goal';
}
