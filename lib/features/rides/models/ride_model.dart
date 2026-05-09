import 'package:cloud_firestore/cloud_firestore.dart';

class JourneyModel {
  final String id;

  final String captainUid;
  final String captainName;
  final String captainPhone;

  final String fromCity;
  final String fromDisplay;
  final String toCity;
  final String toDisplay;

  final String departureDate;     // YYYY-MM-DD
  final String departureTime;     // HH:MM
  final Timestamp departureDateTime;

  final int seatsTotal;

  final int farePerSeat;

  final JourneyStatus status;

  final bool isRecurring;
  final String? recurringGroupId;

  final Timestamp createdAt;

  JourneyModel({
    required this.id,
    required this.captainUid,
    required this.captainName,
    required this.captainPhone,
    required this.fromCity,
    required this.fromDisplay,
    required this.toCity,
    required this.toDisplay,
    required this.departureDate,
    required this.departureTime,
    required this.departureDateTime,
    required this.seatsTotal,
    required this.farePerSeat,
    required this.status,
    required this.isRecurring,
    this.recurringGroupId,
    required this.createdAt,
  });

  /// 🔁 FROM FIRESTORE
  factory JourneyModel.fromMap(Map<String, dynamic> map, String id) {
    return JourneyModel(
      id: id,
      captainUid: map['captain_uid'] ?? '',
      captainName: map['captain_name'] ?? '',
      captainPhone: map['captain_phone'] ?? '',
      fromCity: map['from_city'] ?? '',
      fromDisplay: map['from_display'] ?? '',
      toCity: map['to_city'] ?? '',
      toDisplay: map['to_display'] ?? '',
      departureDate: map['departure_date'] ?? '',
      departureTime: map['departure_time'] ?? '',
      departureDateTime: map['departure_datetime'] ?? Timestamp.now(),
      seatsTotal: map['seats_total'] ?? 0,
      farePerSeat: map['fare_per_seat'] ?? 0,
      status: JourneyStatusX.fromString(map['status']),
      isRecurring: map['is_recurring'] ?? false,
      recurringGroupId: map['recurring_group_id'],
      createdAt: map['created_at'] ?? Timestamp.now(),
    );
  }

  /// 🔼 TO FIRESTORE
  Map<String, dynamic> toMap() {
    return {
      'captain_uid': captainUid,
      'captain_name': captainName,
      'captain_phone': captainPhone,
      'from_city': fromCity,
      'from_display': fromDisplay,
      'to_city': toCity,
      'to_display': toDisplay,
      'departure_date': departureDate,
      'departure_time': departureTime,
      'departure_datetime': departureDateTime,
      'seats_total': seatsTotal,
      'fare_per_seat': farePerSeat,
      'status': status.value,
      'is_recurring': isRecurring,
      'recurring_group_id': recurringGroupId,
      'created_at': createdAt,
    };
  }

  /// 🧬 COPY WITH (for immutability)
  JourneyModel copyWith({
    String? id,
    String? captainUid,
    String? captainName,
    String? captainPhone,
    String? fromCity,
    String? fromDisplay,
    String? toCity,
    String? toDisplay,
    String? departureDate,
    String? departureTime,
    Timestamp? departureDateTime,
    int? seatsTotal,
    int? farePerSeat,
    JourneyStatus? status,
    bool? isRecurring,
    String? recurringGroupId,
    Timestamp? createdAt,
  }) {
    return JourneyModel(
      id: id ?? this.id,
      captainUid: captainUid ?? this.captainUid,
      captainName: captainName ?? this.captainName,
      captainPhone: captainPhone ?? this.captainPhone,
      fromCity: fromCity ?? this.fromCity,
      fromDisplay: fromDisplay ?? this.fromDisplay,
      toCity: toCity ?? this.toCity,
      toDisplay: toDisplay ?? this.toDisplay,
      departureDate: departureDate ?? this.departureDate,
      departureTime: departureTime ?? this.departureTime,
      departureDateTime: departureDateTime ?? this.departureDateTime,
      seatsTotal: seatsTotal ?? this.seatsTotal,
      farePerSeat: farePerSeat ?? this.farePerSeat,
      status: status ?? this.status,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringGroupId: recurringGroupId ?? this.recurringGroupId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}





enum JourneyStatus {
  active,
  cancelled,
  completed,
}

extension JourneyStatusX on JourneyStatus {
  String get value {
    switch (this) {
      case JourneyStatus.active:
        return "active";
      case JourneyStatus.cancelled:
        return "cancelled";
      case JourneyStatus.completed:
        return "completed";
    }
  }

  static JourneyStatus fromString(String? value) {
    switch (value) {
      case "cancelled":
        return JourneyStatus.cancelled;
      case "completed":
        return JourneyStatus.completed;
      case "active":
      default:
        return JourneyStatus.active;
    }
  }
}