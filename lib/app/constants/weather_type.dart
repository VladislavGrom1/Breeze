enum WeatherType {
  clearSky('Ясное небо', 'assets/weather_icons/ic_sunny.xml'),
  mainlyClear('Преимущественно ясно', 'assets/weather_icons/ic_cloudy.xml'),
  partlyCloudy('Переменная облачность', 'assets/weather_icons/ic_cloudy.xml'),
  overcast('Облачно', 'assets/weather_icons/ic_cloudy.xml'),
  foggy('Туман', 'assets/weather_icons/ic_very_cloudy.xml'),
  depositingRimeFog('Изморозь и туман', 'assets/weather_icons/ic_very_cloudy.xml'),
  lightDrizzle('Лёгкая морось', 'assets/weather_icons/ic_rainshower.xml'),
  moderateDrizzle('Умеренная морось', 'assets/weather_icons/ic_rainshower.xml'),
  denseDrizzle('Сильная морось', 'assets/weather_icons/ic_rainshower.xml'),
  lightFreezingDrizzle('Слабый ледяной дождь', 'assets/weather_icons/ic_snowyrainy.xml'),
  denseFreezingDrizzle('Сильный ледяной дождь', 'assets/weather_icons/ic_snowyrainy.xml'),
  slightRain('Небольшой дождь', 'assets/weather_icons/ic_rainy.xml'),
  moderateRain('Дождь', 'assets/weather_icons/ic_rainy.xml'),
  heavyRain('Сильный дождь', 'assets/weather_icons/ic_rainy.xml'),
  heavyFreezingRain('Сильный ледяной дождь', 'assets/weather_icons/ic_snowyrainy.xml'),
  slightSnowFall('Небольшой снег', 'assets/weather_icons/ic_snowy.xml'),
  moderateSnowFall('Снег', 'assets/weather_icons/ic_heavysnow.xml'),
  heavySnowFall('Сильный снегопад', 'assets/weather_icons/ic_heavysnow.xml'),
  snowGrains('Снежные зерна', 'assets/weather_icons/ic_heavysnow.xml'),
  slightRainShowers('Небольшие ливни', 'assets/weather_icons/ic_rainshower.xml'),
  moderateRainShowers('Ливни', 'assets/weather_icons/ic_rainshower.xml'),
  violentRainShowers('Сильные ливни', 'assets/weather_icons/ic_rainshower.xml'),
  slightSnowShowers('Небольшой снегопад', 'assets/weather_icons/ic_snowy.xml'),
  heavySnowShowers('Сильный снегопад', 'assets/weather_icons/ic_snowy.xml'),
  moderateThunderstorm('Гроза', 'assets/weather_icons/ic_thunder.xml'),
  slightHailThunderstorm('Гроза с небольшим градом', 'assets/weather_icons/ic_rainythunder.xml'),
  heavyHailThunderstorm('Гроза с сильным градом', 'assets/weather_icons/ic_rainythunder.xml');

  const WeatherType(this.weatherDesc, this.iconAsset);

  final String weatherDesc;
  final String iconAsset;

  static WeatherType fromWmo(int code) {
    switch (code) {
      case 0:
        return WeatherType.clearSky;
      case 1:
        return WeatherType.mainlyClear;
      case 2:
        return WeatherType.partlyCloudy;
      case 3:
        return WeatherType.overcast;
      case 45:
        return WeatherType.foggy;
      case 48:
        return WeatherType.depositingRimeFog;
      case 51:
        return WeatherType.lightDrizzle;
      case 53:
        return WeatherType.moderateDrizzle;
      case 55:
        return WeatherType.denseDrizzle;
      case 56:
        return WeatherType.lightFreezingDrizzle;
      case 57:
        return WeatherType.denseFreezingDrizzle;
      case 61:
        return WeatherType.slightRain;
      case 63:
        return WeatherType.moderateRain;
      case 65:
        return WeatherType.heavyRain;
      case 66:
        return WeatherType.lightFreezingDrizzle;
      case 67:
        return WeatherType.heavyFreezingRain;
      case 71:
        return WeatherType.slightSnowFall;
      case 73:
        return WeatherType.moderateSnowFall;
      case 75:
        return WeatherType.heavySnowFall;
      case 77:
        return WeatherType.snowGrains;
      case 80:
        return WeatherType.slightRainShowers;
      case 81:
        return WeatherType.moderateRainShowers;
      case 82:
        return WeatherType.violentRainShowers;
      case 85:
        return WeatherType.slightSnowShowers;
      case 86:
        return WeatherType.heavySnowShowers;
      case 95:
        return WeatherType.moderateThunderstorm;
      case 96:
        return WeatherType.slightHailThunderstorm;
      case 99:
        return WeatherType.heavyHailThunderstorm;
      default:
        return WeatherType.clearSky;
    }
  }
}