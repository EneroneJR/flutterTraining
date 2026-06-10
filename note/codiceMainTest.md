[[#Spiegazione]] del Codice:

```dart
import 'package:flutter/material.dart';

import 'core/database/app_database.dart';
import 'core/database/database_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const TrackerSpeseApp());
}

class TrackerSpeseApp extends StatelessWidget {
  const TrackerSpeseApp({super.key});

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
      home: const DatabaseTestPage(),
    );
  }
}

class DatabaseTestPage extends StatelessWidget {
  const DatabaseTestPage({super.key});

  String formatCents(int cents) {
    final value = cents / 100;

    return '€ ${value.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test database'),
      ),
      body: FutureBuilder<AppSetting>(
        future: database.getSettings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: SelectableText(
                'Errore database:\n\n${snapshot.error}',
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            );
          }

          final settings = snapshot.data;

          if (settings == null) {
            return const Center(
              child: Text(
                'Le impostazioni non sono state trovate.',
              ),
            );
          }

          return FutureBuilder<List<Category>>(
            future: database.getAllCategories(),
            builder: (context, categoriesSnapshot) {
              if (categoriesSnapshot.connectionState !=
                  ConnectionState.done) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (categoriesSnapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: SelectableText(
                    'Errore categorie:\n\n'
                    '${categoriesSnapshot.error}',
                    style: const TextStyle(
                      color: Colors.red,
                    ),
                  ),
                );
              }

              final categories =
                  categoriesSnapshot.data ?? <Category>[];

              return ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  const Icon(
                    Icons.check_circle,
                    size: 72,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Database creato correttamente',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Impostazioni iniziali',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Stipendio: '
                            '${formatCents(settings.monthlySalaryCents)}',
                          ),
                          Text(
                            'Obiettivo risparmio: '
                            '${formatCents(
                              settings.monthlySavingsTargetCents,
                            )}',
                          ),
                          Text(
                            'Salvadanaio iniziale: '
                            '${formatCents(
                              settings.initialSavingsCents,
                            )}',
                          ),
                          Text(
                            'Inizio periodo: giorno '
                            '${settings.periodStartDay}',
                          ),
                          Text(
                            'Anno: ${settings.referenceYear}',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Categorie create: '
                            '${categories.length}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          for (final category in categories)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(
                                vertical: 4,
                              ),
                              child: Text(
                                '• ${category.name} '
                                '(${category.suggestedType})',
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
```

# Spiegazione
