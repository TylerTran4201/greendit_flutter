// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ElectricDevice {
  final String device;
  final String emission;

  ElectricDevice({
    required this.device,
    required this.emission,
  });

  ElectricDevice copyWith({
    String? device,
    String? emission,
  }) {
    return ElectricDevice(
      device: device ?? this.device,
      emission: emission ?? this.emission,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'device': device,
      'emission': emission,
    };
  }

  factory ElectricDevice.fromMap(Map<String, dynamic> map) {
    return ElectricDevice(
      device: map['device'] as String,
      emission: map['emission'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ElectricDevice.fromJson(String source) =>
      ElectricDevice.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ElectricDevice(device: $device, emission: $emission)';

  @override
  bool operator ==(covariant ElectricDevice other) {
    if (identical(this, other)) return true;

    return other.device == device && other.emission == emission;
  }

  @override
  int get hashCode => device.hashCode ^ emission.hashCode;
}
