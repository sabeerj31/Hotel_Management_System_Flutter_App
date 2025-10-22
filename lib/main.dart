import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'providers/reservation_provider.dart';
import 'screens/dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const HotelManagementSystemApp());
}

class HotelManagementSystemApp extends StatelessWidget {
  const HotelManagementSystemApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ReservationProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Hotel Management System',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          useMaterial3: true,
        ),
        home: const DashboardScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}