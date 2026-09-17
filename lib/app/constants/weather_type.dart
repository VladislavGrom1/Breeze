enum WeatherType {
  clearSky('Ясное небо', 'assets/weather_icons/ic_sunny.svg'),
  mainlyClear('Преимущественно ясно', 'assets/weather_icons/ic_cloudy.svg'),
  partlyCloudy('Переменная облачность', 'assets/weather_icons/ic_cloudy.svg'),
  overcast('Облачно', 'assets/weather_icons/ic_cloudy.svg'),
  foggy('Туман', 'assets/weather_icons/ic_very_cloudy.svg'),
  depositingRimeFog('Изморозь и туман', 'assets/weather_icons/ic_very_cloudy.svg'),
  lightDrizzle('Лёгкая морось', 'assets/weather_icons/ic_rainshower.svg'),
  moderateDrizzle('Умеренная морось', 'assets/weather_icons/ic_rainshower.svg'),
  denseDrizzle('Сильная морось', 'assets/weather_icons/ic_rainshower.svg'),
  lightFreezingDrizzle('Слабый ледяной дождь', 'assets/weather_icons/ic_snowyrainy.svg'),
  denseFreezingDrizzle('Сильный ледяной дождь', 'assets/weather_icons/ic_snowyrainy.svg'),
  slightRain('Небольшой дождь', 'assets/weather_icons/ic_rainy.svg'),
  moderateRain('Дождь', 'assets/weather_icons/ic_rainy.svg'),
  heavyRain('Сильный дождь', 'assets/weather_icons/ic_rainy.svg'),
  heavyFreezingRain('Сильный ледяной дождь', 'assets/weather_icons/ic_snowyrainy.svg'),
  slightSnowFall('Небольшой снег', 'assets/weather_icons/ic_snowy.svg'),
  moderateSnowFall('Снег', 'assets/weather_icons/ic_heavysnow.svg'),
  heavySnowFall('Сильный снегопад', 'assets/weather_icons/ic_heavysnow.svg'),
  snowGrains('Снежные зерна', 'assets/weather_icons/ic_heavysnow.svg'),
  slightRainShowers('Небольшие ливни', 'assets/weather_icons/ic_rainshower.svg'),
  moderateRainShowers('Ливни', 'assets/weather_icons/ic_rainshower.svg'),
  violentRainShowers('Сильные ливни', 'assets/weather_icons/ic_rainshower.svg'),
  slightSnowShowers('Небольшой снегопад', 'assets/weather_icons/ic_snowy.svg'),
  heavySnowShowers('Сильный снегопад', 'assets/weather_icons/ic_snowy.svg'),
  moderateThunderstorm('Гроза', 'assets/weather_icons/ic_thunder.svg'),
  slightHailThunderstorm('Гроза с небольшим градом', 'assets/weather_icons/ic_rainythunder.svg'),
  heavyHailThunderstorm('Гроза с сильным градом', 'assets/weather_icons/ic_rainythunder.svg');

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