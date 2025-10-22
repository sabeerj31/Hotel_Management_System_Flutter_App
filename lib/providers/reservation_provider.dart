import 'package:flutter/foundation.dart';
import 'dart:async';
import '../models/reservation.dart';
import '../services/reservation_service.dart';

class ReservationProvider with ChangeNotifier {
  final ReservationService _reservationService = ReservationService();
  List<Reservation> _reservations = [];
  bool _isLoading = false;
  String? _error;
  StreamSubscription? _reservationsSubscription;

  List<Reservation> get reservations => _reservations;
  bool get isLoading => _isLoading;
  String? get error => _error;

  ReservationProvider() {
    loadReservations();
  }

  void loadReservations() {
    _isLoading = true;
    _error = null;
    notifyListeners();

    _reservationsSubscription?.cancel();

    _reservationsSubscription = _reservationService.getReservations().listen(
          (reservations) {
        _reservations = reservations;
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (error) {
        _isLoading = false;
        _error = error.toString();
        notifyListeners();
      },
      cancelOnError: false,
    );
  }

  Future<void> addReservation(Reservation reservation) async {
    try {
      _error = null;
      notifyListeners();
      await _reservationService.addReservation(reservation);
      // No need to call loadReservations() here as the stream will update automatically
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateReservation(Reservation reservation) async {
    try {
      _error = null;
      notifyListeners();
      await _reservationService.updateReservation(reservation);
      // Force refresh after update
      loadReservations();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteReservation(String id) async {
    try {
      _error = null;
      notifyListeners();
      await _reservationService.deleteReservation(id);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Confirmed reservations (status = true)
  List<Reservation> get confirmedReservations {
    return _reservations.where((reservation) => reservation.status).toList();
  }

  // Pending reservations (status = false)
  List<Reservation> get pendingReservations {
    return _reservations.where((reservation) => !reservation.status).toList();
  }

  // Active reservations - currently checked in (confirmed only)
  List<Reservation> get activeReservations {
    final now = DateTime.now();
    return _reservations.where((reservation) {
      // Only confirmed reservations that are currently active
      return reservation.status &&
          now.isAfter(reservation.checkInDate) &&
          now.isBefore(reservation.checkOutDate);
    }).toList();
  }

  // Upcoming reservations - future check-ins (both confirmed and pending)
  List<Reservation> get upcomingReservations {
    final now = DateTime.now();
    return _reservations.where((reservation) {
      return reservation.checkInDate.isAfter(now);
    }).toList();
  }

  // Completed reservations - past check-outs
  List<Reservation> get completedReservations {
    final now = DateTime.now();
    return _reservations.where((reservation) {
      return reservation.checkOutDate.isBefore(now);
    }).toList();
  }

  // Active stays count (confirmed only)
  int get activeStaysCount => activeReservations.length;

  // Pending approval count
  int get pendingReservationsCount => pendingReservations.length;

  int get totalReservations => _reservations.length;
  int get confirmedReservationsCount => confirmedReservations.length;

  // Total revenue from confirmed reservations only
  double get totalRevenue {
    return _reservations.fold(0.0, (sum, reservation) =>
    reservation.status ? sum + reservation.totalAmount : sum
    );
  }

  // Pending revenue from unconfirmed reservations
  double get pendingRevenue {
    return _reservations.fold(0.0, (sum, reservation) =>
    !reservation.status ? sum + reservation.totalAmount : sum
    );
  }

  @override
  void dispose() {
    _reservationsSubscription?.cancel();
    super.dispose();
  }
}