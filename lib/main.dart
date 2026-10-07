import 'package:flutter/material.dart';

void main() {
  runApp(const LaundryServicesApp());
}

class LaundryServicesApp extends StatelessWidget {
  const LaundryServicesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Laundry Services',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F766E),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
      ),
      home: const AppShell(),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  final List<_NavItem> _items = [
    _NavItem('Home', Icons.home_rounded, const HomeScreen()),
    _NavItem('Services', Icons.cleaning_services_rounded, const ServicesScreen()),
    _NavItem('Orders', Icons.receipt_long_rounded, const OrdersScreen()),
    _NavItem('Profile', Icons.person_rounded, const ProfileScreen()),
  ];

  @override
  Widget build(BuildContext context) {
    final currentScreen = _items[_currentIndex].screen;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _items.map((item) => item.screen).toList(),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: _items
            .map(
              (item) => NavigationDestination(
                icon: Icon(item.icon),
                label: item.title,
              ),
            )
            .toList(),
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ScannerScreen()),
                );
              },
              icon: const Icon(Icons.qr_code_scanner_rounded),
              label: const Text('Scan'),
            )
          : null,
    );
  }
}

class _NavItem {
  final String title;
  final IconData icon;
  final Widget screen;

  _NavItem(this.title, this.icon, this.screen);
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: ListView(
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 22,
                  backgroundColor: Color(0xFFDFF7F2),
                  child: Icon(Icons.person_rounded, color: Color(0xFF0F766E)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Good morning, Maya',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Your orders are moving smoothly',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PartnerTasksScreen()),
                    );
                  },
                  icon: const Icon(Icons.notifications_none_rounded),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F766E), Color(0xFF14B8A6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ready for pickup?',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '3 garments are processed and awaiting final seal confirmation.',
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const SealConfirmationScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF0F766E),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text('Confirm seal'),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: const [
                Expanded(child: StatTile(label: 'Completed', value: '128', color: Color(0xFFDFF7F2))),
                SizedBox(width: 12),
                Expanded(child: StatTile(label: 'In queue', value: '12', color: Color(0xFFE5EDFF))),
              ],
            ),
            const SizedBox(height: 20),
            const SectionHeader(title: 'Quick actions'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                QuickActionChip(
                  icon: Icons.cleaning_services_rounded,
                  label: 'Services',
                  onTap: () {},
                ),
                QuickActionChip(
                  icon: Icons.receipt_long_rounded,
                  label: 'Orders',
                  onTap: () {},
                ),
                QuickActionChip(
                  icon: Icons.qr_code_scanner_rounded,
                  label: 'Scanner',
                  onTap: () {},
                ),
                QuickActionChip(
                  icon: Icons.attach_money_rounded,
                  label: 'Earnings',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 22),
            const SectionHeader(title: 'Recent orders'),
            const SizedBox(height: 10),
            OrderTile(
              title: 'Express Delivery',
              subtitle: 'Order #EXP-2048 • Ready for pickup',
              status: 'In progress',
              amount: 'KES 1,850',
              accent: const Color(0xFF0F766E),
              onTap: null,
            ),
            const SizedBox(height: 10),
            OrderTile(
              title: 'Formal Wear Service',
              subtitle: 'Order #FWD-1891 • Pressing complete',
              status: 'Ready',
              amount: 'KES 2,350',
              accent: const Color(0xFF8B5CF6),
              onTap: null,
            ),
          ],
        ),
      ),
    );
  }
}

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final services = [
      _ServiceItem(
        title: 'Adjustable Pricing & Calculator',
        subtitle: 'Custom pricing based on garment type and service level',
        icon: Icons.calculate_rounded,
        color: const Color(0xFF0EA5E9),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AdjustablePricingScreen()),
          );
        },
      ),
      _ServiceItem(
        title: 'Traditional & Formal Wear',
        subtitle: 'Steam, tailoring, pressing, and finish care',
        icon: Icons.emoji_events_rounded,
        color: const Color(0xFF8B5CF6),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TraditionalWearScreen()),
          );
        },
      ),
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: ListView(
          children: [
            const SectionHeader(title: 'Services'),
            const SizedBox(height: 16),
            ...services.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: ServiceCard(
                  title: item.title,
                  subtitle: item.subtitle,
                  icon: item.icon,
                  color: item.color,
                  onTap: item.onTap,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: ListView(
          children: [
            const SectionHeader(title: 'Orders'),
            const SizedBox(height: 16),
            OrderTile(
              title: 'Express Delivery',
              subtitle: 'Order #EXP-2048 • 3 items • 2h ago',
              status: 'In transit',
              amount: 'KES 1,850',
              accent: const Color(0xFF0F766E),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ExpressOrderDetailsScreen()),
                );
              },
            ),
            const SizedBox(height: 12),
            OrderTile(
              title: 'Regular wash & fold',
              subtitle: 'Order #REG-1072 • 8 items • scheduled',
              status: 'Scheduled',
              amount: 'KES 950',
              accent: const Color(0xFF2563EB),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const OrderDetailsScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: ListView(
          children: [
            const SectionHeader(title: 'Profile'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                    color: Colors.black.withOpacity(0.04),
                  )
                ],
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 32,
                    backgroundColor: Color(0xFFDFF7F2),
                    child: Icon(Icons.person_rounded, size: 32, color: Color(0xFF0F766E)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Maya Njeri', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        Text('Silver Member', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const Row(
              children: [
                Expanded(child: StatTile(label: 'Savings', value: 'KES 4.2k', color: Color(0xFFE0F2FE))),
                SizedBox(width: 12),
                Expanded(child: StatTile(label: 'Loyalty', value: '86%', color: Color(0xFFF3E8FF))),
              ],
            ),
            const SizedBox(height: 22),
            _ProfileAction(
              title: 'Partner earnings & payouts',
              subtitle: 'Track your wallet and transfer status',
              icon: Icons.account_balance_wallet_rounded,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PartnerEarningsScreen()),
                );
              },
            ),
            const SizedBox(height: 12),
            _ProfileAction(
              title: 'Partner tasks',
              subtitle: 'Open and complete current jobs',
              icon: Icons.task_rounded,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PartnerTasksScreen()),
                );
              },
            ),
            const SizedBox(height: 12),
            _ProfileAction(
              title: 'Garment processing hub',
              subtitle: 'Monitor quality checks and workflow status',
              icon: Icons.factory_rounded,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GarmentProcessingHubScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order details')),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: ListView(
          children: [
            _DetailHeader(title: 'Order #REG-1072', status: 'Scheduled'),
            const SizedBox(height: 16),
            _InfoCard(
              title: 'Order summary',
              rows: const [
                _InfoRow('Items', '8 garments'),
                _InfoRow('Pickup window', 'Tue 10:00 - 12:00'),
                _InfoRow('Service', 'Wash & fold'),
                _InfoRow('Total', 'KES 950'),
              ],
            ),
            const SizedBox(height: 14),
            _InfoCard(
              title: 'Processing notes',
              rows: const [
                _InfoRow('Care instructions', 'Cold wash only'),
                _InfoRow('Bag label', 'Green / Priority'),
                _InfoRow('Priority', 'Standard'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ExpressOrderDetailsScreen extends StatelessWidget {
  const ExpressOrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Express delivery')),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: ListView(
          children: [
            _DetailHeader(title: 'Order #EXP-2048', status: 'In transit'),
            const SizedBox(height: 16),
            _InfoCard(
              title: 'Delivery timeline',
              rows: const [
                _InfoRow('Pickup', 'Completed'),
                _InfoRow('Processing', 'Final press in progress'),
                _InfoRow('ETA', 'Arrives in 40 mins'),
                _InfoRow('Driver', 'Sam • Toyota AXIO'),
              ],
            ),
            const SizedBox(height: 14),
            _InfoCard(
              title: 'Package details',
              rows: const [
                _InfoRow('Items', '3 garments'),
                _InfoRow('Service', 'Express tailoring'),
                _InfoRow('Status', 'Ready to handoff'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PartnerTasksScreen extends StatelessWidget {
  const PartnerTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Partner tasks')),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: ListView(
          children: [
            TaskCard(
              title: 'Task Execution & Intake',
              subtitle: 'Receive package and confirm garment details',
              tag: 'Open',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TaskExecutionScreen()),
                );
              },
            ),
            const SizedBox(height: 12),
            TaskCard(
              title: 'Garment processing hub',
              subtitle: 'Inspect fabric, finish, and update workflow',
              tag: 'In progress',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GarmentProcessingHubScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TaskExecutionScreen extends StatelessWidget {
  const TaskExecutionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task execution & intake')),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: ListView(
          children: [
            _InfoCard(
              title: 'Job intake',
              rows: const [
                _InfoRow('Customer', 'Maya Njeri'),
                _InfoRow('Items counted', '4 garments'),
                _InfoRow('Service timeline', 'Pickup today at 15:30'),
                _InfoRow('Assigned partner', 'Samuel'),
              ],
            ),
            const SizedBox(height: 14),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ScannerScreen()),
                );
              },
              icon: const Icon(Icons.qr_code_scanner_rounded),
              label: const Text('Open scanner'),
            )
          ],
        ),
      ),
    );
  }
}

class ScannerScreen extends StatelessWidget {
  const ScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Barcode & QR scanner')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(22.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF0F766E), width: 3),
                  borderRadius: BorderRadius.circular(24),
                  color: Colors.white,
                ),
                child: const Center(
                  child: Icon(Icons.qr_code_2_rounded, size: 120, color: Color(0xFF0F766E)),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Scan item barcode or QR code',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Demo mode: scanning is simulated for UI preview.',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PartnerEarningsScreen extends StatelessWidget {
  const PartnerEarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Partner earnings & payouts')),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: ListView(
          children: const [
            StatTile(label: 'This week', value: 'KES 18,200', color: Color(0xFFDCFCE7)),
            SizedBox(height: 14),
            _InfoCard(
              title: 'Payout summary',
              rows: [
                _InfoRow('Pending', 'KES 4,300'),
                _InfoRow('Released', 'KES 13,900'),
                _InfoRow('Next payout', 'Friday, 3:00 PM'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class GarmentProcessingHubScreen extends StatelessWidget {
  const GarmentProcessingHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Garment processing hub')),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: ListView(
          children: [
            const SectionHeader(title: 'Workflow status'),
            const SizedBox(height: 12),
            ProcessStateCard(title: 'Intake received', subtitle: 'Checked and tagged', status: 'Complete'),
            const SizedBox(height: 10),
            ProcessStateCard(title: 'Wash cycle', subtitle: 'Temperature calibrated', status: 'Complete'),
            const SizedBox(height: 10),
            ProcessStateCard(title: 'Final press', subtitle: 'Awaiting quality review', status: 'In review'),
          ],
        ),
      ),
    );
  }
}

class SealConfirmationScreen extends StatelessWidget {
  const SealConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Seal confirmation')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 110,
                height: 110,
                decoration: const BoxDecoration(
                  color: Color(0xFFE0FCE5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A), size: 72),
              ),
              const SizedBox(height: 18),
              const Text(
                'Seal confirmed successfully',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'The garment has been successfully sealed and released for pickup.',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Back to home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AdjustablePricingScreen extends StatelessWidget {
  const AdjustablePricingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adjustable pricing & calculator')),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: ListView(
          children: const [
            _InfoCard(
              title: 'Current estimate',
              rows: [
                _InfoRow('Service tier', 'Premium'),
                _InfoRow('Garment count', '5'),
                _InfoRow('Base price', 'KES 1,200'),
                _InfoRow('Extra treatment', 'KES 350'),
                _InfoRow('Total estimate', 'KES 1,550'),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class TraditionalWearScreen extends StatelessWidget {
  const TraditionalWearScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Traditional & formal wear')),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: ListView(
          children: const [
            _InfoCard(
              title: 'Available treatments',
              rows: [
                _InfoRow('Suit pressing', 'KES 650'),
                _InfoRow('Gentle steam', 'KES 400'),
                _InfoRow('Tailoring adjustment', 'KES 950'),
                _InfoRow('Final finish & polish', 'KES 300'),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }
}

class StatTile extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const StatTile({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class QuickActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const QuickActionChip({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              blurRadius: 12,
              offset: const Offset(0, 4),
              color: Colors.black.withOpacity(0.04),
            )
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF0F766E)),
            const SizedBox(width: 10),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class OrderTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String status;
  final String amount;
  final Color accent;
  final VoidCallback? onTap;

  const OrderTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.amount,
    required this.accent,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              blurRadius: 12,
              offset: const Offset(0, 4),
              color: Colors.black.withOpacity(0.04),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: accent.withOpacity(0.14),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.local_laundry_service_rounded, color: accent),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(status, style: TextStyle(fontSize: 12, color: accent, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(amount, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const ServiceCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              blurRadius: 12,
              offset: const Offset(0, 4),
              color: Colors.black.withOpacity(0.04),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color.withOpacity(0.14),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String tag;
  final VoidCallback? onTap;

  const TaskCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.tag,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFE0F2FE),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                tag,
                style: const TextStyle(color: Color(0xFF0369A1), fontWeight: FontWeight.w600, fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProcessStateCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String status;

  const ProcessStateCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: status == 'Complete' ? const Color(0xFFDCFCE7) : const Color(0xFFFDE68A),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: status == 'Complete' ? const Color(0xFF166534) : const Color(0xFF92400E),
                fontWeight: FontWeight.w700,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileAction extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onTap;

  const _ProfileAction({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFDFF7F2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFF0F766E)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

class _DetailHeader extends StatelessWidget {
  final String title;
  final String status;

  const _DetailHeader({required this.title, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2FE),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              status,
              style: const TextStyle(color: Color(0xFF0369A1), fontWeight: FontWeight.w700, fontSize: 12),
            ),
          )
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final List<_InfoRow> rows;

  const _InfoCard({required this.title, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 14),
          ...rows.map(
            (row) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(row.label, style: const TextStyle(color: Colors.grey)),
                  Text(row.value, style: const TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow {
  final String label;
  final String value;

  const _InfoRow(this.label, this.value);
}

class _ServiceItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _ServiceItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.onTap,
  });
}

class _NavItemModel {
  final String label;
  final IconData icon;

  const _NavItemModel({required this.label, required this.icon});
}
