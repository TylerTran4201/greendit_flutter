import 'package:flutter/material.dart';
import 'package:greendit/features/objectDetected/screens/detector_widget.dart';
import 'package:greendit/models/screen_params.dart';


/// [ObjectDetectedView] stacks [DetectorWidget]
class ObjectDetectedView extends StatelessWidget {
  const ObjectDetectedView({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenParams.screenSize = MediaQuery.sizeOf(context);
    return Scaffold(
      key: GlobalKey(),
      backgroundColor: Colors.black,
      body: const DetectorWidget(),
    );
  }
}
