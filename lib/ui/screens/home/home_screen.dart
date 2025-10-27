import 'package:flutter/material.dart';
import '../../../../core/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text(
          'RentaCar',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        elevation: 6,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        shadowColor: Colors.black26,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          childAspectRatio: 1,
          children: [
            _HomeMenuButton(
              icon: Icons.directions_car_filled_rounded,
              label: 'Vehículos',
              color: Colors.indigo,
              onTap: () =>
                  Navigator.pushNamed(context, AppRoutes.vehiclesList),
            ),
            _HomeMenuButton(
              icon: Icons.people_alt_rounded,
              label: 'Clientes',
              color: Colors.green,
              onTap: () =>
                  Navigator.pushNamed(context, AppRoutes.clientsList),
            ),
            _HomeMenuButton(
              icon: Icons.event_note_rounded,
              label: 'Reservas',
              color: Colors.orange,
              onTap: () =>
                  Navigator.pushNamed(context, AppRoutes.reservationsList),
            ),
            _HomeMenuButton(
              icon: Icons.delivery_dining_rounded,
              label: 'Entregas',
              color: Colors.purple,
              onTap: () =>
                  Navigator.pushNamed(context, AppRoutes.deliveriesList),
            ),
            _HomeMenuButton(
              icon: Icons.bar_chart_rounded,
              label: 'Estadísticas',
              color: Colors.teal,
              onTap: () => Navigator.pushNamed(context, AppRoutes.stats),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeMenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final MaterialColor color;
  final VoidCallback onTap;

  const _HomeMenuButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.white,
          boxShadow: [
            // sombra exterior de la tarjeta
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
            // leve luz superior (efecto de relieve)
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.5),
              blurRadius: 4,
              offset: const Offset(0, -1),
            ),
          ],
          border: Border.all(
            color: color.withValues(alpha: 0.25),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ícono en círculo con degradado y sombra interior
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      color.shade400,
                      color.shade700,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 14),

              // Título
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: color.shade800,
                  letterSpacing: 0.3,
                ),
              ),

              const SizedBox(height: 6),

              // Línea decorativa
              Container(
                width: 28,
                height: 3,
                decoration: BoxDecoration(
                  color: color.shade400,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.4),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
