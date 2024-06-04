import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'config.dart';

class PredictionPage extends StatefulWidget {
  @override
  _PredictionPageState createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> {
  TextEditingController nitrogenController = TextEditingController();
  TextEditingController phosphorusController = TextEditingController();
  TextEditingController potassiumController = TextEditingController();
  TextEditingController temperatureController = TextEditingController();
  TextEditingController humidityController = TextEditingController();
  TextEditingController phController = TextEditingController();
  TextEditingController rainfallController = TextEditingController();

  String predictionResult = '';
  final _formKey = GlobalKey<FormState>();

  Future<void> sendRequest() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final String serverUrl = 'http://${AppConfig.cropIpAddress}/form';

    try {
      final Map<String, dynamic> requestData = {
        'Nitrogen': double.tryParse(nitrogenController.text),
        'Phosphorus': double.tryParse(phosphorusController.text),
        'Potassium': double.tryParse(potassiumController.text),
        'Temperature': double.tryParse(temperatureController.text),
        'Humidity': double.tryParse(humidityController.text),
        'Ph': double.tryParse(phController.text),
        'Rainfall': double.tryParse(rainfallController.text),
      };

      if (requestData.containsValue(null)) {
        _showResultDialog('Please enter valid numeric values for all fields.');
        return;
      }

      final response = await http.post(
        Uri.parse(serverUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          predictionResult = '${data['prediction']} is suitable for this area';
        });
        _showResultDialog(predictionResult);
      } else {
        print('Error: ${response.statusCode}');
        final Map<String, dynamic> errorData = json.decode(response.body);
        _showResultDialog('Error: ${errorData['error']}');
      }
    } catch (e) {
      print('Exception: $e');
      _showResultDialog('An error occurred during prediction.');
    }
  }

  Future<void> _showResultDialog(String result) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Prediction Result'),
          content: Text(result),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crop Prediction'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildInputField('Nitrogen', nitrogenController),
                _buildInputField('Phosphorus', phosphorusController),
                _buildInputField('Potassium', potassiumController),
                _buildInputField('Temperature', temperatureController),
                _buildInputField('Humidity', humidityController),
                _buildInputField('Ph', phController),
                _buildInputField('Rainfall', rainfallController),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    sendRequest();
                  },
                  child: Text('Predict'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a value';
          }
          return null;
        },
      ),
    );
  }
}
