import 'dart:async';
import 'dart:isolate';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greendit/features/ObjectDetected/screens/box_widget.dart';
import 'package:greendit/features/objectDetected/controller/object_detected_controller.dart';
import 'package:greendit/models/recognition.dart';
import 'package:greendit/models/screen_params.dart';
import 'package:greendit/services/detector_service.dart';

/// [DetectorWidget] sends each frame for inference
class DetectorWidget extends ConsumerStatefulWidget {
  /// Constructor
  const DetectorWidget({super.key});

  @override
  ConsumerState<DetectorWidget> createState() => _DetectorWidgetState();
}

class _DetectorWidgetState extends ConsumerState<DetectorWidget>
    with WidgetsBindingObserver {
  /// List of available cameras
  late List<CameraDescription> cameras;

  /// Controller
  CameraController? _cameraController;

  // use only when initialized, so - not null
  get _controller => _cameraController;

  /// Object Detector is running on a background [Isolate]. This is nullable
  /// because acquiring a [Detector] is an asynchronous operation. This
  /// value is `null` until the detector is initialized.
  Detector? _detector;
  StreamSubscription? _subscription;

  /// Results to draw bounding boxes
  List<Recognition>? results;

  /// Realtime stats
  Map<String, String>? stats;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initStateAsync();
  }

  void _initStateAsync() async {
    // initialize preview and CameraImage stream
    _initializeCamera();
    // Spawn a new isolate
    Detector.start().then((instance) {
      setState(() {
        _detector = instance;
        _subscription = instance.resultsStream.stream.listen((values) {
          setState(() {
            results = values['recognitions'];
            stats = values['stats'];
          });
        });
      });
    });
  }

  /// Initializes the camera by setting [_cameraController]
  void _initializeCamera() async {
    cameras = await availableCameras();
    // cameras[0] for back-camera
    _cameraController = CameraController(
      cameras[0],
      ResolutionPreset.medium,
      enableAudio: false,
    )..initialize().then((_) async {
        await _controller.startImageStream(onLatestImageAvailable);
        setState(() {});

        /// previewSize is size of each image frame captured by controller
        ///
        /// 352x288 on iOS, 240p (320x240) on Android with ResolutionPreset.low
        ScreenParams.previewSize = _controller.value.previewSize!;
      });
  }

  @override
  Widget build(BuildContext context) {
    // Return empty container while the camera is not initialized
    if (_cameraController == null || !_controller.value.isInitialized) {
      return const SizedBox.shrink();
    }
    var aspect = 1 / _controller.value.aspectRatio;
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: aspect,
          child: CameraPreview(_controller),
        ),
        // Stats
        _labelWidget(),
        _addButton(),
        // Bounding boxes
        AspectRatio(
          aspectRatio: aspect,
          child: _boundingBoxes(),
        )
      ],
    );
  }

  void addObjectDeteced(String object) {
    ref.read(objectDetectedControllerProvider.notifier).addObjectDetected(
          context: context,
          object: object,
        );
  }

  Widget _addButton() => (results != null)
      ? Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: IconButton(
                onPressed: () {
                  addObjectDeteced(results!.first.label);
                }
                , icon: const Icon(Icons.add)),
          ))
      : const SizedBox.shrink();

  Widget _labelWidget() => (results != null)
      ? Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 100.0),
            child: Container(
              color: Colors.white.withAlpha(150),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(results!.first.label),
              ),
            ),
          ),
        )
      : Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 100.0),
            child: Container(
              color: Colors.white.withAlpha(150),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("Null"),
              ),
            ),
          ),
        );

  /// Returns Stack of bounding boxes
  Widget _boundingBoxes() {
    if (results == null) {
      return const SizedBox.shrink();
    }
    return Stack(
        children: results!.map((box) => BoxWidget(result: box)).toList());
  }

  void onLatestImageAvailable(CameraImage cameraImage) async {
    _detector?.processFrame(cameraImage);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
        _cameraController?.stopImageStream();
        _detector?.stop();
        _subscription?.cancel();
        break;
      case AppLifecycleState.resumed:
        _initStateAsync();
        break;
      default:
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    _detector?.stop();
    _subscription?.cancel();
    super.dispose();
  }
}
