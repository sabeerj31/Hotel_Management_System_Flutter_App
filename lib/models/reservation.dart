import 'package:cloud_firestore/cloud_firestore.dart';

class Reservation {
  String? id;
  final String guestName;
  final String guestEmail;
  final String guestPhone;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int numberOfGuests;
  final String roomType;
  final double totalAmount;
  final bool status;
  final DateTime createdAt;

  Reservation({
    this.id,
    required this.guestName,
    required this.guestEmail,
    required this.guestPhone,
    required this.checkInDate,
    required this.checkOutDate,
    required this.numberOfGuests,
    required this.roomType,
    required this.totalAmount,
    this.status = false,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'guestName': guestName,
      'guestEmail': guestEmail,
      'guestPhone': guestPhone,
      'checkInDate': Timestamp.fromDate(checkInDate),
      'checkOutDate': Timestamp.fromDate(checkOutDate),
      'numberOfGuests': numberOfGuests,
      'roomType': roomType,
      'totalAmount': totalAmount,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory Reservation.fromMap(String id, Map<String, dynamic> map) {
    DateTime parseTimestamp(dynamic timestamp) {
      if (timestamp is Timestamp) {
        return timestamp.toDate();
      } else if (timestamp is int) {
        return DateTime.fromMillisecondsSinceEpoch(timestamp);
      } else {
        return DateTime.now();
      }
    }

    bool parseStatus(dynamic status) {
      if (status is bool) {
        return status;
      } else if (status is String) {
        return status.toLowerCase() == 'true' || status.toLowerCase() == 'confirmed';
      } else {
        return false;
      }
    }

    return Reservation(
      id: id,
      guestName: map['guestName'] ?? '',
      guestEmail: map['guestEmail'] ?? '',
      guestPhone: map['guestPhone']?.toString() ?? '',
      checkInDate: parseTimestamp(map['checkInDate']),
      checkOutDate: parseTimestamp(map['checkOutDate']),
      numberOfGuests: (map['numberOfGuests'] ?? 0).toInt(),
      roomType: map['roomType'] ?? 'Standard',
      totalAmount: (map['totalAmount'] ?? 0.0).toDouble(),
      status: parseStatus(map['status']),
      createdAt: parseTimestamp(map['createdAt']),
    );
  }

  int get numberOfNights => checkOutDate.difference(checkInDate).inDays;

  bool get isActive {
    final now = DateTime.now();
    return now.isAfter(checkInDate) && now.isBefore(checkOutDate);
  }

  bool get isUpcoming {
    return DateTime.now().isBefore(checkInDate);
  }

  String get statusString {
    return status ? 'Confirmed' : 'Pending';
  }
}