```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const TrackerApp());
}

class TrackerApp extends StatelessWidget {
  const TrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tracker Spese',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
        useMaterial3: true,
      ),
      home: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tracker spese'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Maggio 2026',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Riepilogo del mese',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 24),
          const Row(
            children: [
              Expanded(
                child: SummaryCard(
                  title: 'Stipendio',
                  value: '€ 1.400,00',
                  icon: Icons.account_balance_wallet,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: SummaryCard(
                  title: 'Spese',
                  value: '€ 732,69',
                  icon: Icons.shopping_cart,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const SummaryCard(
            title: 'Risparmio previsto',
            value: '€ 667,31',
            icon: Icons.savings,
          ),
          const SizedBox(height: 24),
          const Text(
            'Spese per categoria',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          const ExpenseRow(
            name: 'Benzina',
            amount: '€ 84,19',
            icon: Icons.local_gas_station,
          ),
          const ExpenseRow(
            name: 'Abbonamenti',
            amount: '€ 14,00',
            icon: Icons.subscriptions,
          ),
          const ExpenseRow(
            name: 'Svago',
            amount: '€ 251,50',
            icon: Icons.sports_esports,
          ),
          const ExpenseRow(
            name: 'Extra',
            amount: '€ 33,00',
            icon: Icons.more_horiz,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Pulsante premuto'),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Aggiungi movimento'),
          ),
        ],
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExpenseRow extends StatelessWidget {
  final String name;
  final String amount;
  final IconData icon;

  const ExpenseRow({
    super.key,
    required this.name,
    required this.amount,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(name),
        trailing: Text(
          amount,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
```