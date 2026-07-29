import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HourlyForecast {
  final String time;
  final String temperature;
  final String condition;
  final IconData icon;
  final String humidity;
  final bool isRainy; // Controls the blue tinted styling

  const HourlyForecast({
    required this.time,
    required this.temperature,
    required this.condition,
    required this.icon,
    required this.humidity,
    this.isRainy = false,
  });
}

class SiteAlert {
  final String type; // 'CRITICAL' or 'SCHEDULE'
  final String title;
  final String detail;
  final IconData icon;

  const SiteAlert({
    required this.type,
    required this.title,
    required this.detail,
    required this.icon,
  });
}

class WeatherController extends GetxController {
  final projectLocation = "Berlin Sector C-4".obs;
  final currentTemp = "6°".obs;
  final currentCondition = "Overcast & Humid".obs;
  final windSpeed = "14 km/h".obs;
  final humidityLevel = "82%".obs;

  final siteAlerts = <SiteAlert>[
    const SiteAlert(
      type: 'CRITICAL',
      title: 'High Wind Warning',
      detail: 'Gusts 45km/h',
      icon: Icons.air_rounded,
    ),
    const SiteAlert(
      type: 'SCHEDULE',
      title: 'Pour Delayed',
      detail: '+2h Shift',
      icon: Icons.access_time_rounded,
    ),
  ].obs;

  final hourlyTimeline = <HourlyForecast>[
    const HourlyForecast(
      time: 'NOW',
      temperature: '6°',
      condition: 'Cloud',
      icon: Icons.cloud_outlined,
      humidity: '',
    ),
    const HourlyForecast(
      time: '13:00',
      temperature: '5°',
      condition: 'Rain',
      icon: Icons.water_drop, // Approximating the solid rain icon
      humidity: '80%',
      isRainy: true,
    ),
    const HourlyForecast(
      time: '14:00',
      temperature: '4°',
      condition: 'Rain',
      icon: Icons.water_drop,
      humidity: '95%',
      isRainy: true,
    ),
    const HourlyForecast(
      time: '15:00',
      temperature: '3°',
      condition: 'Drizzle',
      icon: Icons.grain_rounded, // Approximating the outline rain icon
      humidity: '',
    ),
  ].obs;
}
