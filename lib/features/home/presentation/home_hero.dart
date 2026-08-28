enum HomeHeroPeriod { day, sunset, night }

class HomeHero {
  const HomeHero._();

  static const dayAsset = 'assets/home/canoe_day.png';
  static const sunsetAsset = 'assets/home/canoe_sunset.png';
  static const nightAsset = 'assets/home/canoe_night.png';

  static HomeHeroPeriod periodAt([DateTime? now]) {
    final hour = (now ?? DateTime.now()).hour;
    if (hour >= 6 && hour < 17) {
      return HomeHeroPeriod.day;
    }
    if (hour >= 17 && hour < 20) {
      return HomeHeroPeriod.sunset;
    }
    return HomeHeroPeriod.night;
  }

  static String assetFor(HomeHeroPeriod period) {
    return switch (period) {
      HomeHeroPeriod.day => dayAsset,
      HomeHeroPeriod.sunset => sunsetAsset,
      HomeHeroPeriod.night => nightAsset,
    };
  }
}
