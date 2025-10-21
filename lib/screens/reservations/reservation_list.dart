import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/reservation.dart';
import '../../providers/reservation_provider.dart';
import 'add_reservation.dart';
import 'edit_reservation.dart';
import '../../widgets/reservation_card.dart';

class ReservationListScreen extends StatelessWidget {
  const ReservationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservations'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddReservationScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<ReservationProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.reservations.isEmpty) {
            return const Center(
              child: Text(
                'No reservations found',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            itemCount: provider.reservations.length,
            itemBuilder: (context, index) {
              final reservation = provider.reservations[index];
              return ReservationCard(
                reservation: reservation,
                onEdit: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditReservationScreen(
                        reservation: reservation,
                      ),
                    ),
                  );
                },
                onDelete: () {
                  _showDeleteDialog(context, provider, reservation);
                },
              );
            },
          );
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, ReservationProvider provider,
      Reservation reservation) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Reservation'),
          content: Text(
              'Are you sure you want to delete reservation for ${reservation.guestName}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await provider.deleteReservation(reservation.id!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Reservation deleted successfully'),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error deleting reservation: $e'),
                    ),
                  );
                }
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}