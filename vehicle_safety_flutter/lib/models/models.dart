/// Institution model
class DeviceData {
  double distance;
  int angle;
  DateTime lastSeen;

  DeviceData({
    required this.distance,
    required this.angle,
    required this.lastSeen,
  });

  factory DeviceData.fromMap(Map data) {
    return DeviceData(
      angle: data['p'] ?? 0,
      distance: data['d'] != null
          ? (data['d'] % 1 == 0
              ? data['d'] + 0.1
              : data['d'])
          : 0,
      lastSeen: DateTime.fromMillisecondsSinceEpoch(data['ts']),
    );
  }
}
