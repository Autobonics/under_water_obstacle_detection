/// Institution model
class DeviceData {
  double distance;
  DateTime lastSeen;

  DeviceData({
    required this.distance,
    required this.lastSeen,
  });

  factory DeviceData.fromMap(Map data) {
    return DeviceData(
      // distance: data['d'] ?? 0,
      distance: data['d'] != null
          ? (data['d'] % 1 == 0
              ? data['d'] + 0.1
              : data['d'])
          : 0,
      lastSeen: DateTime.fromMillisecondsSinceEpoch(data['ts']),
    );
  }
}
