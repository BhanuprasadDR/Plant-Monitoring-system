// config.dart
class AppConfig {
  static String ipAddress = '';
  static int minMoisture = 0;
  static int maxMoisture = 100; // Adjust the maximum value as needed
  static String cropIpAddress = '';
  static String fertilizerIpAddress = '';

}
final offlineServer = "http://${AppConfig.fertilizerIpAddress}/";