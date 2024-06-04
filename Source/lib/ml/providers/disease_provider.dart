import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:plant_health_cse/config.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:http/http.dart';

import 'disease_model.dart';

class DiseaseProvider with ChangeNotifier {
  static const onlineServer = "Wirsthorwl.deilion.com/plantkitsjict";
  static late final offlineServer = "http://${AppConfig.fertilizerIpAddress}/";

  static String currentServer = offlineServer;
  bool _offline = false;

  bool get offline => _offline;

  void toggleServer() {
    _offline = !_offline;
    if (offline) {
      currentServer = offlineServer;
    } else {
      currentServer = onlineServer;
    }
    notifyListeners();
  }

  static Future<DiseaseDetails> detectDisease(String imagePath) async {
    // TODO: add switch for offline and online server
    final url = Uri.parse(currentServer);
    final image = await File(imagePath).readAsBytes();
    String base64Image = base64Encode(image);
    final request = await post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'image': base64Image}),
    );
    log("request.body : ${request.body}");
    return DiseaseDetails.fromJson(
        jsonDecode(request.body).cast<String, dynamic>());
  }
}
