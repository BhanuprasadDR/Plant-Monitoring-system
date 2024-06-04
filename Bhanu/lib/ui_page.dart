
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:plant_health_cse/prediction_page.dart';
import 'package:plant_health_cse/setting.dart';
import 'config.dart';
import 'ml/screens/home_screen.dart';
import 'server_side.dart';
import 'dart:async';
class UiPage extends StatefulWidget {
  const UiPage({Key? key}) : super(key: key);

  @override
  _UiPageState createState() => _UiPageState();
}

class _UiPageState extends State<UiPage> {
  late final ServerSide server;


  bool isPumpToggled = false;
  bool isLightFluxToggled = false;
  bool isAutoModeToggled = false;

  @override
  void initState() {
    super.initState();
    server = ServerSide('');


  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plant Health Monitoring'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {}
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                image: const DecorationImage(
                  image: AssetImage("assets/banner_image.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
              children: [
                buildCard(Icons.thermostat, 'Temperature', () => server.getTemperature()),
                buildCard(Icons.opacity, 'Humidity', () => server.getHumidity()),
                buildCard(Icons.wb_sunny, 'Light Flux', () => server.getLightFlux()),
                buildCard(Icons.water, 'Moisture', () => server.getMoisture()),
                buildAutoModeCard(),
                if (!isAutoModeToggled) buildPumpCard(),
              ],
            ),
            const SizedBox(height: 16.0),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Auto Mode'),
                trailing: Switch(
                  value: isAutoModeToggled,
                  onChanged: (value) {
                    setState(() {
                      isAutoModeToggled = value;
                    });
                    final dio = Dio();
                    if (value) {
                      dio.get('http://${AppConfig.ipAddress}/moist_auto?min=${AppConfig.minMoisture}&max=${AppConfig.maxMoisture}')
                          .then((response) {
                      })
                          .catchError((error) {
                      });
                    } else {
                      dio.get('http://${AppConfig.ipAddress}/moist_auto?min=0&max=0')
                          .then((response) {
                      })
                          .catchError((error) {
                      });
                    }

                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.image_search),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb_outlined),
            label: 'Crop Recommend',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_applications),
            label: 'About',
          ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        onTap: (index) {
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PredictionPage()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyHomePage()),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsPage()),
            );
          }
        },
      ),
    );
  }

  Widget buildPumpCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: const Icon(Icons.settings),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Pump',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            '   Status: ${isPumpToggled ? 'On' : 'Off'}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isPumpToggled ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(height: 8.0),
          Switch(
            value: isPumpToggled,
            onChanged: (value) async {
              setState(() {
                isPumpToggled = value;
              });
              final dio = Dio();
              final baseUrl = "http://${AppConfig.ipAddress}/pump";
              try {
                if (value) {
                  await dio.get("$baseUrl?status=on");
                } else {
                  await dio.get("$baseUrl?status=off");
                }
              } catch (e) {
              }
            },
          ),
        ],
      ),
    );
  }

  Widget buildAutoModeCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.autorenew),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Auto Mode'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Status: ${isAutoModeToggled ? 'On' : 'Off'}'),
          ),
        ],
      ),
    );
  }

  Widget buildCard(IconData icon, String title, Future<double?> Function() dataFunction) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(icon),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: FutureBuilder<double?>(
              future: dataFunction(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('Loading...');
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.data == null) {
                  return const Text('No data available');
                } else {
                  return RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: [
                        TextSpan(
                          text: '${snapshot.data}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                        TextSpan(
                          text: title == 'Temperature'
                              ? '°C'
                              : (title == 'Light Flux' ? ' Lux' : (title == 'Moisture' ? ' %' : '')),
                        ),
                      ],
                    ),
                  );

                }
              },
            ),
          ),
        ],
      ),
    );
  }

}
