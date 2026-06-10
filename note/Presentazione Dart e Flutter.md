È importante definire un concetto importante:

Flutter = Framework
Dart = Il linguaggio effettivo.
Drift = Libreria aggiuntiva per il database.

Dart stabilisce:
- come si dichiarano variabili;
- come si creano funzioni;
- come si creano classi;
- come si eseguono condizioni;
- come si gestiscono operazioni asincrone;
- come si organizzano i file.

Flutter usa Dart per costruire:
- finestre;
- pulsanti;
- testi;
- moduli;
- liste;
- navigazione;
- applicazioni Android, Windows, web e altre piattaforme.

# Elementi
Flutter:
```
MaterialApp
```

```
Scaffold
```

```
Text
```

```
Card
```

```
ListView
```

Dart:
```
class AppDatabase
```

```
Future<int>
```

```
final database = AppDatabase();
```

```
if (snapshot.hasError)
```

Drift:
```
class AppSettings extends Table
```

```
select(appSettings)
```

```
integer().autoIncrement()
```

# Struttura logica.

```
Dart
└── linguaggio

Flutter
└── interfaccia grafica

Drift
└── database
```

La struttura del progetto invece:
```
flutter_training_app/
│
├── pubspec.yaml
│
└── lib/
    ├── main.dart
    │
    └── core/
        └── database/
            ├── app_database.dart
            ├── app_database.g.dart
            └── database_provider.dart
```

# pubspec.yaml
È il file di configurazione generale del progetto.
Contiene:
* Nome dell'applicazione
* Versione
* Versione minima del Dart
* Dipendenze
* Immagini e Font
* Strumenti di Sviluppo

* Con il comando: `flutter pub add drift drift_flutter path_provider`
	* Flutter modifica automaticamente `pubspec.yaml`.
* Con il comando: `flutter pub add --dev drift_dev build_runner`
	* abbiamo aggiunto strumenti utilizzati durante lo sviluppo.

