
class WeeklyForecastDto {
  double? latitude;
  double? longitude;
  double? generationtimeMs;
  int? utcOffsetSeconds;
  String? timezone;
  String? timezoneAbbreviation;
  int? elevation;
  DailyUnits? dailyUnits;
  Daily? daily;

  WeeklyForecastDto({this.latitude, this.longitude, this.generationtimeMs, this.utcOffsetSeconds, this.timezone, this.timezoneAbbreviation, this.elevation, this.dailyUnits, this.daily});

  WeeklyForecastDto.fromJson(Map<String, dynamic> json) {
    latitude = (json["latitude"] as num).toDouble();
    longitude = (json["longitude"] as num).toDouble();
    generationtimeMs = (json["generationtime_ms"] as num).toDouble();
    utcOffsetSeconds = (json["utc_offset_seconds"] as num).toInt();
    timezone = json["timezone"];
    timezoneAbbreviation = json["timezone_abbreviation"];
    elevation = (json["elevation"] as num).toInt();
    dailyUnits = json["daily_units"] == null ? null : DailyUnits.fromJson(json["daily_units"]);
    daily = json["daily"] == null ? null : Daily.fromJson(json["daily"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["latitude"] = latitude;
    _data["longitude"] = longitude;
    _data["generationtime_ms"] = generationtimeMs;
    _data["utc_offset_seconds"] = utcOffsetSeconds;
    _data["timezone"] = timezone;
    _data["timezone_abbreviation"] = timezoneAbbreviation;
    _data["elevation"] = elevation;
    if(dailyUnits != null) {
      _data["daily_units"] = dailyUnits?.toJson();
    }
    if(daily != null) {
      _data["daily"] = daily?.toJson();
    }
    return _data;
  }
}

class Daily {
  List<String>? time;
  List<int>? weatherCode;
  List<double>? temperature2MMax;
  List<double>? temperature2MMin;

  Daily({this.time, this.weatherCode, this.temperature2MMax, this.temperature2MMin});

  Daily.fromJson(Map<String, dynamic> json) {
    time = json["time"] == null ? null : List<String>.from(json["time"]);
    weatherCode = json["weather_code"] == null ? null : List<int>.from(json["weather_code"]);
    temperature2MMax = json["temperature_2m_max"] == null ? null : List<double>.from(json["temperature_2m_max"]);
    temperature2MMin = json["temperature_2m_min"] == null ? null : List<double>.from(json["temperature_2m_min"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if(time != null) {
      _data["time"] = time;
    }
    if(weatherCode != null) {
      _data["weather_code"] = weatherCode;
    }
    if(temperature2MMax != null) {
      _data["temperature_2m_max"] = temperature2MMax;
    }
    if(temperature2MMin != null) {
      _data["temperature_2m_min"] = temperature2MMin;
    }
    return _data;
  }
}

class DailyUnits {
  String? time;
  String? weatherCode;
  String? temperature2MMax;
  String? temperature2MMin;

  DailyUnits({this.time, this.weatherCode, this.temperature2MMax, this.temperature2MMin});

  DailyUnits.fromJson(Map<String, dynamic> json) {
    time = json["time"];
    weatherCode = json["weather_code"];
    temperature2MMax = json["temperature_2m_max"];
    temperature2MMin = json["temperature_2m_min"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["time"] = time;
    _data["weather_code"] = weatherCode;
    _data["temperature_2m_max"] = temperature2MMax;
    _data["temperature_2m_min"] = temperature2MMin;
    return _data;
  }
}


// 0 	Clear sky
// 1, 2, 3 	Mainly clear, partly cloudy, and overcast
// 45, 48 	Fog and depositing rime fog
// 51, 53, 55 	Drizzle: Light, moderate, and dense intensity
// 56, 57 	Freezing Drizzle: Light and dense intensity
// 61, 63, 65 	Rain: Slight, moderate and heavy intensity
// 66, 67 	Freezing Rain: Light and heavy intensity
// 71, 73, 75 	Snow fall: Slight, moderate, and heavy intensity
// 77 	Snow grains
// 80, 81, 82 	Rain showers: Slight, moderate, and violent
// 85, 86 	Snow showers slight and heavy
// 95 * 	Thunderstorm: Slight or moderate
// 96, 99 * 	Thunderstorm with slight and heavy hail
enum WeatherCode {
  clearSky(0, 'Clear sky', 'assets/images/1.jpg'),

  mainlyClear(1, 'Mainly clear', 'assets/images/2-0.jpg'),
  partlyCloudy(2, 'Partly cloudy', 'assets/images/2.jpg'),
  overcast(3, 'Overcast', 'assets/images/2-2.jpg'),

  fog(45, 'Fog', 'assets/images/3-0.jpg'),
  depositingRimeFog(48, 'Depositing rime fog', 'assets/images/3.jpg'),

  drizzleLight(51, 'Drizzle: Light intensity', 'assets/images/4-0.jpg'),
  drizzleModerate(53, 'Drizzle: Moderate intensity', 'assets/images/4.jpg'),
  drizzleDense(55, 'Drizzle: Dense intensity', 'assets/images/4-2.jpg'),

  freezingDrizzleLight(56, 'Freezing Drizzle: Light intensity', 'assets/images/5.jpg'),
  freezingDrizzleDense(57, 'Freezing Drizzle: dense intensity', 'assets/images/5-1.jpg'),

  rainSlight(61, 'Rain: Slight intensity', 'assets/images/6-0.jpg'),
  rainModerate(63, 'Rain: Moderate intensity', 'assets/images/6.jpg'),
  rainHeavy(65, 'Rain: Heavy intensity', 'assets/images/6-2.jpg'),

  freezingRainLight(66, 'Freezing Rain: Light intensity' , 'assets/images/7.jpg'),
  freezingRainHeavy(66, 'Freezing Rain: Heavy intensity' , 'assets/images/7-1.jpg'),

  snowFallSlight(71, 'Snow fall: Slight intensity' , 'assets/images/8-0.jpg'),
  snowFallModerate(73, 'Snow fall: Moderate intensity' , 'assets/images/8.jpg'),
  snowFallHeavy(75, 'Snow fall: Heavy intensity' , 'assets/images/8-2.jpg'),

  snowGrains(77, 'Snow grains' , 'assets/images/9.jpg'),

  rainShowersSlight(80, 'Rain showers: Slight' , 'assets/images/10-0.jpg'),
  rainShowersModerate(81, 'Rain showers: Moderate' , 'assets/images/10.jpg'),
  rainShowersVoilent(82, 'Rain showers: Violent' , 'assets/images/10-2.jpg'),

  snowShowersSlight(85, 'Snow showers: Slight' , 'assets/images/11-0.jpg'),
  snowShowersHeavy(86, 'Snow showers: Heavy' , 'assets/images/11.jpg'),

  thunerstorm(95, 'Thunderstorm: Slight or moderate' , 'assets/images/12-0.jpg'),
  thunderstormSlightHail(96, 'Thunderstorm with slight hail' , 'assets/images/12.jpg'),
  thunderstormHeavyHail(99, 'Thunderstorm with heavy hail' , 'assets/images/12-2.jpg'),
  ;

  final int value;
  final String description;
  final String imagePath;
  const WeatherCode(this.value, this.description, this.imagePath);

  factory WeatherCode.fromInt(int value) {
    return WeatherCode.values.singleWhere((code) => code.value == value);
  }

  static String getImagePath(int value) {
    return WeatherCode.fromInt(value).imagePath;
  }
}