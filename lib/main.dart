import 'package:flutter/material.dart';
import 'core/app_routes.dart';
import 'core/app_theme.dart';

// 🔹 Pantallas
import 'ui/screens/home/home_screen.dart';
import 'ui/screens/vehicles/vehicles_list_screen.dart';
import 'ui/screens/vehicles/vehicle_form_screen.dart';
import 'ui/screens/clients/clients_list_screen.dart';
import 'ui/screens/clients/client_form_screen.dart';
import 'ui/screens/reservations/reservations_list_screen.dart';
import 'ui/screens/reservations/reservation_form_screen.dart';
import 'ui/screens/deliveries/deliveries_list_screen.dart';
import 'ui/screens/deliveries/delivery_form_screen.dart';
import 'ui/screens/stats/stats_screen.dart';

void main() {
  runApp(const RentaCarApp());
}

class RentaCarApp extends StatelessWidget {
  const RentaCarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RentaCar',
      theme: AppTheme.light(),
      initialRoute: AppRoutes.home,
      routes: {
        AppRoutes.home: (_) => const HomeScreen(),

        // 🔹 Vehículos
        AppRoutes.vehiclesList: (_) => const VehiclesListScreen(),
        AppRoutes.vehicleForm: (_) => const VehicleFormScreen(),

        // 🔹 Clientes
        AppRoutes.clientsList: (_) => const ClientsListScreen(),
        AppRoutes.clientForm: (_) => const ClientFormScreen(),

        // 🔹 Reservas
        AppRoutes.reservationsList: (_) => const ReservationsListScreen(),
        AppRoutes.reservationForm: (_) => const ReservationFormScreen(),

        // 🔹 Entregas
        AppRoutes.deliveriesList: (_) => const DeliveriesListScreen(),
        AppRoutes.deliveryForm: (_) => const DeliveryFormScreen(),

        // 🔹 Estadísticas
        AppRoutes.stats: (_) => const StatsScreen(),
      },
    );
  }
}
