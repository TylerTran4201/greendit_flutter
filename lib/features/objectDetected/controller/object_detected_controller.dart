import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greendit/core/utils.dart';
import 'package:greendit/features/auth/controller/auth_controller.dart';
import 'package:greendit/features/objectDetected/repositoty/object_detected_repository.dart';
import 'package:greendit/models/electric_device_model.dart';
import 'package:greendit/models/object_detected_model.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

final objectDetectedControllerProvider =
    StateNotifierProvider<ObjectDetectedController, bool>((ref) {
  final objectDetectedRepository = ref.watch(objectDetectedProvider);
  return ObjectDetectedController(
    objectDetectedRepository: objectDetectedRepository,
    ref: ref,
  );
});

final userObjectDetectedProvider = StreamProvider((ref){
  final objectDetectedController = ref.watch(objectDetectedControllerProvider.notifier);
  return objectDetectedController.getUserObjectDetecteds();
});

const JsonDecoder decoder = JsonDecoder();
class ObjectDetectedController extends StateNotifier<bool> {
  final ObjectDetectedRepository _objectDetectedRepository;
  final Ref _ref;

  ObjectDetectedController(
      {required ObjectDetectedRepository objectDetectedRepository,
      required Ref ref})
      : _objectDetectedRepository = objectDetectedRepository,
        _ref = ref,
        super(false);


  Future<void> readJson(String object) async {
    const String filepath = 'assets/models/electric_device_to_Co2.json';

    var jsonString = File(filepath).readAsStringSync();

    final Map<String, dynamic> jsonmap = decoder.convert(jsonString);
    var values = jsonmap["electricDevices"];

    List<ElectricDevice>? electricDevices;
    if(values != null){
      electricDevices = <ElectricDevice>[];
      values.forEach((item) => electricDevices?.add(new ElectricDevice(device: item["device"], emission: item["emission"])));
      electricDevices?.forEach((element) => print(element));
    }
  }

  void addObjectDetected(
      {required BuildContext context, required String object}) async {

    if(object.compareTo('null') == true)
      return;
    state = true;
    String objectDetectedId = const Uuid().v1();
    final user = _ref.read(userProvider)!;

    await readJson(object);


    final ObjectDetected objectDetected = ObjectDetected(
      id: objectDetectedId,
      object: object,
      co2: 1.2,
      username: user.name,
      uid: user.uid,
      createdAt: DateTime.now(),
    );
    final res =
        await _objectDetectedRepository.addObjectDetected(objectDetected);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'add object detected successfully!');
      Routemaster.of(context).pop();
    });
  }

  Stream<List<ObjectDetected>> getUserObjectDetecteds() {
    final user = _ref.read(userProvider)!;
    return _objectDetectedRepository.getUserObjectDeteceds(user.uid);
  }

  void deleteObjectDetected(
      ObjectDetected objectDetected, BuildContext context) async {
    final res =
        await _objectDetectedRepository.deleteObjectDetected(objectDetected);
    res.fold((l) => null,
        (r) => showSnackBar(context, 'Post deleted successfully!'));
  }
}
