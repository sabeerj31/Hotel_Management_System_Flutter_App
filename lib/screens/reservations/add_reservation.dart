import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/reservation.dart';
import '../../providers/reservation_provider.dart';

class AddReservationScreen extends StatefulWidget {
  const AddReservationScreen({super.key});

  @override
  State<AddReservationScreen> createState() => _AddReservationScreenState();
}

class _AddReservationScreenState extends State<AddReservationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _guestNameController = TextEditingController();
  final TextEditingController _guestEmailController = TextEditingController();
  final TextEditingController _guestPhoneController = TextEditingController();
  final TextEditingController _checkInController = TextEditingController();
  final TextEditingController _checkOutController = TextEditingController();
  final TextEditingController _guestsController = TextEditingController();
  final TextEditingController _totalAmountController = TextEditingController();

  String _selectedRoomType = 'Standard';
  final List<String> _roomTypes = ['Standard', 'Deluxe', 'Suite', 'Executive'];

  DateTime? _checkInDate;
  DateTime? _checkOutDate;

  // Validation states
  String? _guestNameError;
  String? _guestEmailError;
  String? _guestPhoneError;
  String? _guestsError;
  String? _totalAmountError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Reservation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Guest Name Field with real-time validation
              TextFormField(
                controller: _guestNameController,
                decoration: InputDecoration(
                  labelText: 'Guest Name',
                  border: const OutlineInputBorder(),
                  errorText: _guestNameError,
                ),
                onChanged: _validateGuestName,
                validator: (value) => _guestNameError,
              ),
              const SizedBox(height: 16),

              // Email Field with real-time validation
              TextFormField(
                controller: _guestEmailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: const OutlineInputBorder(),
                  errorText: _guestEmailError,
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: _validateEmail,
                validator: (value) => _guestEmailError,
              ),
              const SizedBox(height: 16),

              // Phone Field with real-time validation
              TextFormField(
                controller: _guestPhoneController,
                decoration: InputDecoration(
                  labelText: 'Phone',
                  border: const OutlineInputBorder(),
                  errorText: _guestPhoneError,
                ),
                keyboardType: TextInputType.phone,
                onChanged: _validatePhone,
                validator: (value) => _guestPhoneError,
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedRoomType,
                decoration: const InputDecoration(
                  labelText: 'Room Type',
                  border: OutlineInputBorder(),
                ),
                items: _roomTypes.map((String roomType) {
                  return DropdownMenuItem<String>(
                    value: roomType,
                    child: Text(roomType),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedRoomType = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _checkInController,
                decoration: const InputDecoration(
                  labelText: 'Check-in Date',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () => _selectCheckInDate(context),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select check-in date';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _checkOutController,
                decoration: const InputDecoration(
                  labelText: 'Check-out Date',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () => _selectCheckOutDate(context),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select check-out date';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Number of Guests with real-time validation
              TextFormField(
                controller: _guestsController,
                decoration: InputDecoration(
                  labelText: 'Number of Guests',
                  border: const OutlineInputBorder(),
                  errorText: _guestsError,
                ),
                keyboardType: TextInputType.number,
                onChanged: _validateGuests,
                validator: (value) => _guestsError,
              ),
              const SizedBox(height: 16),

              // Total Amount with real-time validation and ₹ symbol
              TextFormField(
                controller: _totalAmountController,
                decoration: InputDecoration(
                  labelText: 'Total Amount',
                  border: const OutlineInputBorder(),
                  prefixText: '₹ ',
                  errorText: _totalAmountError,
                ),
                keyboardType: TextInputType.number,
                onChanged: _validateTotalAmount,
                validator: (value) => _totalAmountError,
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Create Reservation',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Real-time validation methods
  void _validateGuestName(String value) {
    if (value.isEmpty) {
      setState(() => _guestNameError = 'Please enter guest name');
    } else if (RegExp(r'\d').hasMatch(value)) {
      setState(() => _guestNameError = 'Numbers are not allowed in guest name');
    } else {
      setState(() => _guestNameError = null);
    }
  }

  void _validateEmail(String value) {
    if (value.isEmpty) {
      setState(() => _guestEmailError = 'Please enter email');
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      setState(() => _guestEmailError = 'Please enter a valid email');
    } else {
      setState(() => _guestEmailError = null);
    }
  }

  void _validatePhone(String value) {
    if (value.isEmpty) {
      setState(() => _guestPhoneError = 'Please enter phone number');
    } else if (RegExp(r'[a-zA-Z]').hasMatch(value)) {
      setState(() => _guestPhoneError = 'Characters are not allowed in phone number');
    } else if (!RegExp(r'^[0-9+-\s()]+$').hasMatch(value)) {
      setState(() => _guestPhoneError = 'Only numbers and + - ( ) are allowed');
    } else {
      setState(() => _guestPhoneError = null);
    }
  }

  void _validateGuests(String value) {
    if (value.isEmpty) {
      setState(() => _guestsError = 'Please enter number of guests');
    } else if (int.tryParse(value) == null) {
      setState(() => _guestsError = 'Please enter a valid number');
    } else if (int.parse(value) <= 0) {
      setState(() => _guestsError = 'Number of guests must be greater than 0');
    } else {
      setState(() => _guestsError = null);
    }
  }

  void _validateTotalAmount(String value) {
    if (value.isEmpty) {
      setState(() => _totalAmountError = 'Please enter total amount');
    } else if (double.tryParse(value) == null) {
      setState(() => _totalAmountError = 'Please enter a valid amount');
    } else if (double.parse(value) <= 0) {
      setState(() => _totalAmountError = 'Amount must be greater than 0');
    } else {
      setState(() => _totalAmountError = null);
    }
  }

  Future<void> _selectCheckInDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _checkInDate = picked;
        _checkInController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectCheckOutDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _checkInDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: _checkInDate ?? DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _checkOutDate = picked;
        _checkOutController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _submitForm() async {
    // Trigger all validations one final time
    _validateGuestName(_guestNameController.text);
    _validateEmail(_guestEmailController.text);
    _validatePhone(_guestPhoneController.text);
    _validateGuests(_guestsController.text);
    _validateTotalAmount(_totalAmountController.text);

    if (_formKey.currentState!.validate() &&
        _guestNameError == null &&
        _guestEmailError == null &&
        _guestPhoneError == null &&
        _guestsError == null &&
        _totalAmountError == null &&
        _checkInDate != null &&
        _checkOutDate != null) {

      final reservation = Reservation(
        guestName: _guestNameController.text,
        guestEmail: _guestEmailController.text,
        guestPhone: _guestPhoneController.text,
        checkInDate: _checkInDate!,
        checkOutDate: _checkOutDate!,
        numberOfGuests: int.parse(_guestsController.text),
        roomType: _selectedRoomType,
        totalAmount: double.parse(_totalAmountController.text),
        status: false,
        createdAt: DateTime.now(),
      );

      try {
        final provider = Provider.of<ReservationProvider>(context, listen: false);
        await provider.addReservation(reservation);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Reservation created successfully!'),
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error creating reservation: $e'),
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _guestNameController.dispose();
    _guestEmailController.dispose();
    _guestPhoneController.dispose();
    _checkInController.dispose();
    _checkOutController.dispose();
    _guestsController.dispose();
    _totalAmountController.dispose();
    super.dispose();
  }
}