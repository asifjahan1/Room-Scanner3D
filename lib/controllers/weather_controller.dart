import 'package:get/get.dart';

class HourlyForecast {
  final String time;
  final String temperature;
  final String condition;
  final String iconType; // 'rain', 'cloud', 'sun'
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
  final projectLocation = "Berlin Sector C-4".obs;
  final currentTemp = "6°".obs;
  final currentCondition = "Overcast & Humid".obs;
  final windSpeed = "14 km/h".obs;
  final humidityLevel = "82%".obs;
  final siteConditionDesc = "Wet, slippery soil.".obs;

  final siteAlerts = <SiteAlert>[
    const SiteAlert(
      type: 'CRITICAL',
      title: 'High Wind Warning',
      detail: 'Gusts > 45km/h',
    ),
    const SiteAlert(
      type: 'SCHEDULE',
      title: 'Pour Delayed',
      detail: '@ < 3°C limit',
    ),
  ].obs;

  final hourlyTimeline = <HourlyForecast>[
    const HourlyForecast(time: 'NOW', temperature: '6°', condition: 'Rain', iconType: 'rain', humidity: '82%'),
    const HourlyForecast(time: '13:00', temperature: '5°', condition: 'Cloud', iconType: 'cloud', humidity: '80%'),
    const HourlyForecast(time: '14:00', temperature: '4°', condition: 'Cloud', iconType: 'cloud', humidity: '78%'),
    const HourlyForecast(time: '15:00', temperature: '3°', condition: 'Overcast', iconType: 'cloud', humidity: '75%'),
  ].obs;
}
