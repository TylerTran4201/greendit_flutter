// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:greendit/models/post_model.dart';

class ObjectDetected {
  final String id;
  final String object;
  final double co2;
  final String username;
  final String uid;
  final DateTime createdAt;
  ObjectDetected({
    required this.id,
    required this.object,
    required this.co2,
    required this.username,
    required this.uid,
    required this.createdAt,
  });

  ObjectDetected copyWith({
    String? id,
    String? object,
    double? co2,
    String? username,
    String? uid,
    DateTime? createdAt,
  }) {
    return ObjectDetected(
      id: id ?? this.id,
      object: object ?? this.object,
      co2: co2 ?? this.co2,
      username: username ?? this.username,
      uid: uid ?? this.uid,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'object': object,
      'co2': co2,
      'username': username,
      'uid': uid,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory ObjectDetected.fromMap(Map<String, dynamic> map) {
    return ObjectDetected(
      id: map['id'] as String,
      object: map['object'] as String,
      co2: map['co2'] as double,
      username: map['username'] as String,
      uid: map['uid'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory ObjectDetected.fromJson(String source) =>
      ObjectDetected.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ObjectDetected(id: $id, object: $object, co2: $co2, username: $username, uid: $uid, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant ObjectDetected other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.object == object &&
        other.co2 == co2 &&
        other.username == username &&
        other.uid == uid &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        object.hashCode ^
        co2.hashCode ^
        username.hashCode ^
        uid.hashCode ^
        createdAt.hashCode;
  }
}
