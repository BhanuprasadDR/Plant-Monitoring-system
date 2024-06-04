import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:plant_health_cse/ml/common/image_picker.dart';
import 'package:plant_health_cse/ml/providers/disease_provider.dart';
import 'package:plant_health_cse/ml/screens/feedback_screen.dart';
import 'package:provider/provider.dart';

import '../components/menu_item.dart';
import 'camera_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final DiseaseProvider _diseaseProvider;

  @override
  void initState() {
    super.initState();
    _diseaseProvider = context.read<DiseaseProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  child: buildSwitchIcon(),
                ),
                buildHeading(),
                buildMenu1(),
                Selector<DiseaseProvider, bool>(
                  selector: (_, provider) => provider.offline,
                  builder: (_, offline, __) =>
                  !offline ? buildMenu2() : const SizedBox(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  NeumorphicButton buildSwitchIcon() {
    return NeumorphicButton(
      margin: const EdgeInsets.symmetric(vertical: 20),
      onPressed: () {
        _diseaseProvider.toggleServer();
      },
      child: SizedBox(
        height: 30,
        child: Selector<DiseaseProvider, bool>(
          selector: (_, provider) => provider.offline,
          builder: (_, offline, __) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (offline) ...[
                const Icon(Icons.cloud_outlined),
                const SizedBox(width: 15),
                const Text("online")
              ] else ...[
                const Icon(Icons.cloud_off_outlined),
                const SizedBox(width: 15),
                const Text("Offline")
              ]
            ],
          ),
        ),
      ),
    );
  }

  Padding buildHeading() {
    return Padding(
      padding: const EdgeInsets.only(top: 60, bottom: 80),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Plant health check",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color(0xff112a42),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  SizedBox buildMenu1() {
    return SizedBox(
      height: 180,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          MenuItem(
              text: "Upload Image",
              icon: Icons.upload_file_rounded,
              onPressed: () {
                chooseImageFromGallery();
              }),
          const SizedBox(width: 20),
          MenuItem(
              text: "Scan plant",
              icon: Icons.camera_enhance_rounded,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CameraScreen(),
                  ),
                );
              }),
        ],
      ),
    );
  }

  SizedBox buildMenu2() {
    return SizedBox(
      height: 180,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Omitting the "Latest Fertilizers" and "Feedback" sections
        ],
      ),
    );
  }
}
