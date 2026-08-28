class AppRoutes {
  const AppRoutes._();

  static const splash = '/splash';
  static const welcome = '/welcome';
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
  static const resetPassword = '/reset-password';
  static const device = '/device';
  static const onboarding = '/onboarding';
  static const home = '/home';
  static const plan = '/home/plan';
  static const choosePlan = '/home/choose-plan';
  static const progress = '/progress';
  static const history = '/progress/history';
  static const ranking = '/progress/ranking';
  static const xpInfo = '/progress/xp';
  static const profile = '/profile';
  static const profileMessage = '/profile/message';
  static const billing = '/profile/billing';
  static const paywall = '/paywall';
  static const session = '/session/:id';
  static const explore = '/explore';
  static const program = '/explore/:id';
  static const listen = '/listen';
  static const nowPlaying = '/now-playing';
  static const moments = '/moments';
  static const exerciseLibrary = '/exercises';
  static const breathing = '/breathing';
  static const daily = '/daily';
  static const dailyCircuit = '/daily/circuit';
  static const practice = '/practice';
  static const pomodoro = '/pomodoro';
  static const checkin = '/checkin';
  static const journal = '/journal';
  static const thoughts = '/thoughts';
  static const clearMind = '/clear-mind';
  static const dayClose = '/day-close';
  static const silentRoom = '/silent-room';

  static String sessionPath(int id, {bool prepared = false}) {
    return prepared ? '/session/$id?prepared=1' : '/session/$id';
  }

  static String programPath(int id) => '/explore/$id';
  static String momentsPath({String? category}) {
    return category == null ? moments : '$moments?category=$category';
  }

  static String exerciseLibraryPath({String? type}) {
    return type == null ? exerciseLibrary : '$exerciseLibrary?type=$type';
  }
}
