import 'package:flutter/material.dart';
import 'server_side.dart';
import 'config.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _ipController = TextEditingController();
  final TextEditingController _minMoistureController = TextEditingController();
  final TextEditingController _maxMoistureController = TextEditingController();
  final TextEditingController _cropIpController = TextEditingController();
  final TextEditingController _fertilizerIpController = TextEditingController();
  bool isConnected = false;
  bool isLoading = false;
  late ServerSide server;

  @override
  void initState() {
    super.initState();
    server = ServerSide('');
    _ipController.text = AppConfig.ipAddress;
    _minMoistureController.text = AppConfig.minMoisture.toString();
    _maxMoistureController.text = AppConfig.maxMoisture.toString();
    _cropIpController.text = AppConfig.cropIpAddress;
    _fertilizerIpController.text = AppConfig.fertilizerIpAddress;
  }

  Future<void> _checkConnection() async {
    setState(() {
      isLoading = true;
    });

    final newServer = ServerSide(_ipController.text);

    try {
      await newServer.getTemperature();
      setState(() {
        isConnected = true;
        server = newServer;
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Connected to the server'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        isConnected = false;
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error connecting to the server'),
          backgroundColor: Colors.red,
        ),
      );
    }

    AppConfig.ipAddress = _ipController.text;
    AppConfig.minMoisture = int.tryParse(_minMoistureController.text) ?? 0;
    AppConfig.maxMoisture = int.tryParse(_maxMoistureController.text) ?? 0;
    AppConfig.cropIpAddress = _cropIpController.text;
    AppConfig.fertilizerIpAddress = _fertilizerIpController.text;
  }

  void _saveValues() {

    AppConfig.ipAddress = _ipController.text;
    AppConfig.minMoisture = int.tryParse(_minMoistureController.text) ?? 0;
    AppConfig.maxMoisture = int.tryParse(_maxMoistureController.text) ?? 0;
    AppConfig.cropIpAddress = _cropIpController.text;
    AppConfig.fertilizerIpAddress = _fertilizerIpController.text;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Values saved'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _ipController,
                decoration: const InputDecoration(labelText: 'Enter IP Address'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: isLoading ? null : _checkConnection,
                child: const Text('Connect'),
              ),
              const SizedBox(height: 16.0),
              isLoading
                  ? const CircularProgressIndicator()
                  : Text(
                isConnected ? 'Connected' : 'Disconnected',
                style: TextStyle(
                  fontSize: 18.0,
                  color: isConnected ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _minMoistureController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Enter Min Moisture'),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _maxMoistureController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Enter Max Moisture'),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _cropIpController,
                decoration: const InputDecoration(labelText: 'Enter Crop IP Address'),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _fertilizerIpController,
                decoration: const InputDecoration(labelText: 'Enter Fertilizer IP Address'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _saveValues,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
