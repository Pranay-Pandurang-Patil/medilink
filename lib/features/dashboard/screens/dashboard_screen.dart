import 'package:flutter/material.dart';

import 'package:medilink/features/inventory/screens/add_medicine_screen.dart';
import 'package:medilink/features/inventory/screens/inventory_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  void _openAddMedicine(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddMedicineScreen(),
      ),
    );
  }

  void _openInventory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const InventoryScreen(),
      ),
    );
  }

  void _openAlerts(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Expiry Alerts coming soon'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MediLink'),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              _openAlerts(context);
            },
            icon: const Icon(Icons.notifications_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Medical Shop Dashboard',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Manage your medicines and stock',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 25),

            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.25,
              children: const [
                _DashboardCard(
                  title: 'Total Medicines',
                  value: '0',
                  icon: Icons.medication_outlined,
                ),
                _DashboardCard(
                  title: 'Total Stock',
                  value: '0',
                  icon: Icons.inventory_2_outlined,
                ),
                _DashboardCard(
                  title: 'Low Stock',
                  value: '0',
                  icon: Icons.warning_amber_outlined,
                ),
                _DashboardCard(
                  title: 'Expiring Soon',
                  value: '0',
                  icon: Icons.event_outlined,
                ),
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            _QuickActionButton(
              title: 'Add Medicine',
              icon: Icons.add_circle_outline,
              onPressed: () {
                _openAddMedicine(context);
              },
            ),

            const SizedBox(height: 12),

            _QuickActionButton(
              title: 'View Inventory',
              icon: Icons.inventory_outlined,
              onPressed: () {
                _openInventory(context);
              },
            ),

            const SizedBox(height: 12),

            _QuickActionButton(
              title: 'View Expiry Alerts',
              icon: Icons.notification_important_outlined,
              onPressed: () {
                _openAlerts(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _DashboardCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              icon,
              size: 30,
              color: Colors.green,
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;

  const _QuickActionButton({
    required this.title,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: OutlinedButton.styleFrom(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}