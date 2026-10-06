// lib/data/models/mileage_entry.dart

import 'package:carlog/utils/formatting.dart';

class MileageEntry {
  const MileageEntry({
    required this.mileage,
    required this.recordedAt,
  });

  final int mileage;
  final DateTime recordedAt;

  factory MileageEntry.fromMap(Map<String, Object?> map) {
    return MileageEntry(
      mileage: (map['mileage'] as int?) ?? 0,
      recordedAt: parseDateOnly(map['recorded_at'] as String?) ??
          dateOnly(DateTime.now()),
    );
  }

  Map<String, Object?> toMap() {
    return {
      'mileage': mileage,
      'recorded_at': formatDateOnly(recordedAt),
    };
  }

  @override
  String toString() => 'MileageEntry(mileage: $mileage, '
      'recordedAt: ${formatDateOnly(recordedAt)})';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MileageEntry &&
        other.mileage == mileage &&
        other.recordedAt == recordedAt;
  }

  @override
  int get hashCode => Object.hash(mileage, recordedAt);
}
