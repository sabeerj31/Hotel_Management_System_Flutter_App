import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_management_system/main.dart';

void main() {
  testWidgets('Dashboard screen loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const HotelManagementSystemApp());

    // Verify that the dashboard screen loads
    expect(find.text('Hotel Management System'), findsOneWidget);
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Reservations'), findsOneWidget);
    expect(find.text('Add Booking'), findsOneWidget);
  });

  testWidgets('Navigate to reservations screen', (WidgetTester tester) async {
    await tester.pumpWidget(const HotelManagementSystemApp());

    // Tap the Reservations card
    await tester.tap(find.text('Reservations'));
    await tester.pumpAndSettle();

    // Verify that we navigate to reservations screen
    expect(find.text('Reservations'), findsOneWidget);
  });
}