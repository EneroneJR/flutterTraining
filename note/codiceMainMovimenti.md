[[#Spiegazione]] del codice:
```dart
import 'package:flutter/material.dart';

import 'core/database/database_provider.dart';
import 'features/transactions/data/transactions_repository.dart';
import 'features/transactions/presentation/transactions_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const TrackerSpeseApp());
}

class TrackerSpeseApp extends StatelessWidget {
  const TrackerSpeseApp({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionsRepository = TransactionsRepository(
      database,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tracker Spese',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
        useMaterial3: true,
      ),
      home: TransactionsPage(
        repository: transactionsRepository,
      ),
    );
  }
}
```
# Spiegazione