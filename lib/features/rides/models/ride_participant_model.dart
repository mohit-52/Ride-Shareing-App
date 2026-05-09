import 'package:cloud_firestore/cloud_firestore.dart';

class RideParticipantModel {
  final String id;
  final String journeyId;
  final String riderUid;
  final String captainUid;
  final ParticipantStatus status;
  final Timestamp joinedAt;
  final Timestamp updatedAt;

  RideParticipantModel({
    required this.id,
    required this.journeyId,
    required this.riderUid,
    required this.captainUid,
    required this.status,
    required this.joinedAt,
    required this.updatedAt,
  });

  /// 🔁 FROM FIRESTORE
  factory RideParticipantModel.fromMap(Map<String, dynamic> map, String id) {
    return RideParticipantModel(
      id: id,
      journeyId: map['journey_id'] ?? '',
      riderUid: map['rider_uid'] ?? '',
      captainUid: map['captain_uid'] ?? '',
      status: ParticipantStatusX.fromString(map['status']),
      joinedAt: map['joined_at'] ?? Timestamp.now(),
      updatedAt: map['updated_at'] ?? Timestamp.now(),
    );
  }

  /// 🔼 TO FIRESTORE
  Map<String, dynamic> toMap() {
    return {
      'journey_id': journeyId,
      'rider_uid': riderUid,
      'captain_uid': captainUid,
      'status': status.value,
      'joined_at': joinedAt,
      'updated_at': updatedAt,
    };
  }

  /// 🧬 COPY WITH
  RideParticipantModel copyWith({
    String? id,
    String? journeyId,
    String? riderUid,
    String? captainUid,
    ParticipantStatus? status,
    Timestamp? joinedAt,
    Timestamp? updatedAt,
  }) {
    return RideParticipantModel(
      id: id ?? this.id,
      journeyId: journeyId ?? this.journeyId,
      riderUid: riderUid ?? this.riderUid,
      captainUid: captainUid ?? this.captainUid,
      status: status ?? this.status,
      joinedAt: joinedAt ?? this.joinedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

enum ParticipantStatus {
  pending,
  confirmed,
  rejected,
  cancelled,
}

extension ParticipantStatusX on ParticipantStatus {
  String get value {
    switch (this) {
      case ParticipantStatus.pending:
        return "pending";
      case ParticipantStatus.confirmed:
        return "confirmed";
      case ParticipantStatus.rejected:
        return "rejected";
      case ParticipantStatus.cancelled:
        return "cancelled";
    }
  }

  static ParticipantStatus fromString(String? value) {
    switch (value) {
      case "confirmed":
        return ParticipantStatus.confirmed;
      case "rejected":
        return ParticipantStatus.rejected;
      case "cancelled":
        return ParticipantStatus.cancelled;
      case "pending":
      default:
        return ParticipantStatus.pending;
    }
  }
}
