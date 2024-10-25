class ZoneData {
  final String zone;
  final int estimatedCount;
  final DateTime firstSeen;
  final DateTime lastSeen;
  final double scannedMinutes;

  ZoneData({
    required this.zone,
    required this.estimatedCount,
    required this.firstSeen,
    required this.lastSeen,
    required this.scannedMinutes,
  });

  factory ZoneData.fromJson(Map<String, dynamic> json) {
    return ZoneData(
      zone: json['zone'] as String,
      estimatedCount: json['estimated_count'] as int,
      firstSeen: DateTime.parse(json['first_seen'] as String),
      lastSeen: DateTime.parse(json['last_seen'] as String),
      scannedMinutes: json['scanned_minutes'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'zone': zone,
      'estimated_count': estimatedCount,
      'first_seen': firstSeen.toIso8601String(),
      'last_seen': lastSeen.toIso8601String(),
      'scanned_minutes': scannedMinutes,
    };
  }
}
