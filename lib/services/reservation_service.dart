import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/reservation.dart';

class ReservationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Reservation>> getReservations() {
    return _firestore
        .collection('reservation')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Reservation.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  Future<void> addReservation(Reservation reservation) async {
    try {
      await _firestore
          .collection('reservation')
          .add(reservation.toMap());
    } catch (e) {
      throw Exception('Failed to add reservation: $e');
    }
  }

  Future<void> updateReservation(Reservation reservation) async {
    try {
      if (reservation.id == null) {
        throw Exception('Reservation ID is null');
      }
      await _firestore
          .collection('reservation')
          .doc(reservation.id!)
          .update(reservation.toMap());
    } catch (e) {
      throw Exception('Failed to update reservation: $e');
    }
  }

  Future<void> deleteReservation(String id) async {
    try {
      await _firestore
          .collection('reservation')
          .doc(id)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete reservation: $e');
    }
  }

  Future<Reservation?> getReservationById(String id) async {
    try {
      final doc = await _firestore
          .collection('reservation')
          .doc(id)
          .get();
      if (doc.exists) {
        return Reservation.fromMap(doc.id, doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get reservation: $e');
    }
  }

  Stream<List<Reservation>> getReservationsByStatus(bool status) {
    return _firestore
        .collection('reservation')
        .where('status', isEqualTo: status)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Reservation.fromMap(doc.id, doc.data()!))
        .toList());
  }

  Stream<List<Reservation>> getUpcomingReservations() {
    final now = Timestamp.now();
    return _firestore
        .collection('reservation')
        .where('checkInDate', isGreaterThanOrEqualTo: now)
        .orderBy('checkInDate', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Reservation.fromMap(doc.id, doc.data()!))
        .toList());
  }
}