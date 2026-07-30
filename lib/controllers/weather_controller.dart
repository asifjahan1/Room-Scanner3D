import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HourlyForecast {
  final String time;
  final String temperature;
  final String condition;
  final String iconType; // 'rain', 'cloud', 'sun', 'snow'
  final String humidity;

  const HourlyForecast({
    required this.time,
    required this.temperature,
    required this.condition,
    required this.iconType,
    required this.humidity,
  });
}

class SiteAlert {
  final String type; // 'CRITICAL' or 'SCHEDULE'
  final String title;
  final String detail;
  
  const SiteAlert({
    required this.type,
    required this.title,
    required this.detail,
  });
}

class WeatherController extends GetxController {
  final isLoading = true.obs;
  final isError = false.obs;

  final projectLocation = "Berlin Sector C-4".obs;
  
  final currentTemp = "--°".obs;
  final currentCondition = "Loading...".obs;
  final currentIconType = "cloud".obs;
  final windSpeed = "-- km/h".obs;
  final humidityLevel = "--%".obs;
  final siteConditionDesc = "Fetching live conditions...".obs;

  final siteAlerts = <SiteAlert>[].obs;
  final hourlyTimeline = <HourlyForecast>[].obs;
  final List<HourlyForecast> _allHourlyData = [];
  final isShowing6Hours = false.obs;

  void show6Hours() {
    isShowing6Hours.value = true;
    _updateTimelineDisplay();
  }

  void _updateTimelineDisplay() {
    if (isShowing6Hours.value) {
      hourlyTimeline.value = _allHourlyData.take(6).toList();
    } else {
      hourlyTimeline.value = _allHourlyData.take(4).toList();
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchLiveWeather();
  }

  Future<void> fetchLiveWeather() async {
    try {
      isLoading.value = true;
      isError.value = false;

      // Berlin coordinates to match the demo UI
      const lat = 52.52;
      const lon = 13.41;
      
      final url = Uri.parse(
          'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current=temperature_2m,relative_humidity_2m,wind_speed_10m,weather_code&hourly=temperature_2m,relative_humidity_2m,weather_code&timezone=auto&forecast_days=1');
      
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Parse Current Weather
        final current = data['current'];
        final tempRaw = current['temperature_2m'];
        final humidityRaw = current['relative_humidity_2m'];
        final windRaw = current['wind_speed_10m'];
        final codeRaw = current['weather_code'];

        currentTemp.value = "${tempRaw.round()}°";
        humidityLevel.value = "${humidityRaw.round()}%";
        windSpeed.value = "${windRaw.round()} km/h";
        
        final parsedCondition = _parseWMOCode(codeRaw);
        currentCondition.value = parsedCondition.condition;
        currentIconType.value = parsedCondition.iconType;

        // Generate Dynamic Alerts
        final alerts = <SiteAlert>[
          const SiteAlert(
            type: 'CRITICAL',
            title: 'High Wind Warning',
            detail: 'Gusts 45km/h',
          ),
          const SiteAlert(
            type: 'SCHEDULE',
            title: 'Pour Delayed',
            detail: '+2h Shift',
          ),
        ];

        // Also add real alerts if conditions are met
        if (windRaw > 40) {
          alerts.add(SiteAlert(
            type: 'CRITICAL',
            title: 'Live Wind Warning',
            detail: 'Gusts ${windRaw.round()}km/h',
          ));
        }
        if (tempRaw < 3) {
          alerts.add(SiteAlert(
            type: 'SCHEDULE',
            title: 'Live Pour Delayed',
            detail: '@ < 3°C limit',
          ));
        } else if (tempRaw > 35) {
           alerts.add(SiteAlert(
            type: 'CRITICAL',
            title: 'Extreme Heat',
            detail: '> 35°C limit',
          ));
        }
        siteAlerts.value = alerts;

        // Determine Site Condition text
        if (codeRaw >= 51 && codeRaw <= 67) {
          siteConditionDesc.value = "Wet, slippery soil.";
        } else if (tempRaw < 0) {
          siteConditionDesc.value = "Freezing conditions. Ice possible.";
        } else {
          siteConditionDesc.value = "Conditions normal.";
        }

        // Parse Hourly Timeline (Get next 4 hours)
        final hourly = data['hourly'];
        final List<dynamic> times = hourly['time'];
        final List<dynamic> temps = hourly['temperature_2m'];
        final List<dynamic> humidities = hourly['relative_humidity_2m'];
        final List<dynamic> codes = hourly['weather_code'];

        // Find the index of the current hour
        final nowStr = current['time'];
        // The API returns times like "2023-10-15T12:00". Find closest match.
        int startIndex = 0;
        for (int i = 0; i < times.length; i++) {
          if (times[i].toString().compareTo(nowStr.toString()) >= 0) {
            startIndex = i;
            break;
          }
        }

        final timeline = <HourlyForecast>[];
        for (int i = 0; i < 24; i++) {
          if (startIndex + i < times.length) {
            final idx = startIndex + i;
            final timeStr = i == 0 ? "NOW" : times[idx].toString().substring(11, 16); // Extract HH:mm
            final t = temps[idx].round();
            final h = humidities[idx].round();
            final c = _parseWMOCode(codes[idx]);

            timeline.add(HourlyForecast(
              time: timeStr,
              temperature: "$t°",
              condition: c.condition,
              iconType: c.iconType,
              humidity: "$h%",
            ));
          }
        }
        _allHourlyData.clear();
        _allHourlyData.addAll(timeline);
        _updateTimelineDisplay();
        
        isLoading.value = false;
      } else {
        isError.value = true;
        isLoading.value = false;
      }
    } catch (e) {
      isError.value = true;
      isLoading.value = false;
    }
  }

  // Helper to parse WMO Weather codes to readable text and icon
  _WeatherParsed _parseWMOCode(int code) {
    if (code == 0) return _WeatherParsed('Clear Sky', 'sun');
    if (code == 1 || code == 2) return _WeatherParsed('Partly Cloudy', 'cloud');
    if (code == 3) return _WeatherParsed('Overcast', 'cloud');
    if (code == 45 || code == 48) return _WeatherParsed('Foggy', 'cloud');
    if (code >= 51 && code <= 55) return _WeatherParsed('Drizzle', 'rain');
    if (code >= 61 && code <= 65) return _WeatherParsed('Rain', 'rain');
    if (code >= 71 && code <= 77) return _WeatherParsed('Snow', 'snow');
    if (code >= 80 && code <= 82) return _WeatherParsed('Rain Showers', 'rain');
    if (code >= 85 && code <= 86) return _WeatherParsed('Snow Showers', 'snow');
    if (code >= 95) return _WeatherParsed('Thunderstorm', 'rain');
    return _WeatherParsed('Unknown', 'cloud');
  }
}

class _WeatherParsed {
  final String condition;
  final String iconType;
  _WeatherParsed(this.condition, this.iconType);
}
