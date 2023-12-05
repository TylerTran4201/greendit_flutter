import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:greendit/core/constants/firebase_constants.dart';
import 'package:greendit/core/failure.dart';
import 'package:greendit/core/providers/firebase_provider.dart';
import 'package:greendit/core/type_def.dart';
import 'package:greendit/models/object_detected_model.dart';

final objectDetectedProvider = Provider((ref) {
  return ObjectDetectedRepository(
    firestore: ref.watch(firestoreProvider),
  );
});

class ObjectDetectedRepository {
  final FirebaseFirestore _firestore;

  ObjectDetectedRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _objectDetecteds =>
      _firestore.collection(FirebaseConstants.objectDetectedCollection);

  FutureVoid addObjectDetected(ObjectDetected objectDetected) async {
    try {
      return right(
          _objectDetecteds.doc(objectDetected.id).set(objectDetected.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<ObjectDetected>> getUserObjectDeteceds(String uid) {
    return _objectDetecteds
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((event) {
      List<ObjectDetected> objectDetecteds = [];
      for (var objectDetected in event.docs) {
        objectDetecteds.add(ObjectDetected.fromMap(
            objectDetected.data() as Map<String, dynamic>));
      }
      return objectDetecteds;
    });
  }

  FutureVoid deleteObjectDetected(ObjectDetected objectDetected) async {
    try {
      return right(_objectDetecteds.doc(objectDetected.id).delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
