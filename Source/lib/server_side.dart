import 'dart:convert';
import 'package:http/http.dart' as http;

import 'config.dart';

class ServerSide {
  late String baseUrl='192.168.221.120';

  ServerSide(this.baseUrl);

  // Method to update the base URL dynamically
  void updateBaseUrl(String newBaseUrl) {
    baseUrl = newBaseUrl;
  }

  Future<double?> fetchData(String endpoint) async {
    try {
      final response = await http.get(Uri.parse('http://${AppConfig.ipAddress}/$endpoint'));


      if (response.statusCode == 200) {
        final String dataString = response.body;
        print('Raw data for $endpoint: $dataString');

        final double? data = double.tryParse(dataString);

        return data;
      } else {
        throw Exception('Failed to load $endpoint data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching $endpoint data: $e');
      return null;
    }
  }

  Future<double?> getTemperature() async {
    return fetchData('temperature');
  }

  Future<double?> getHumidity() async {
    return fetchData('humidity');
  }

  Future<double?> getMoisture() async {
    return fetchData('moisture');
  }

  Future<double?> getLightFlux() async {
    return fetchData('light');
  }
}
