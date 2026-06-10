Un progetto in base Flutter ha diverse cartelle:
* android
* ios
* build
* linux
* macos
* web
* windows
La realtà è che l'unica effettiva cartella su cui il progetto si svilupperà principalmente è:
# lib.

Prendiamo quindi ora di esempio il file tracker spese excel e puntiamo a renderlo un applicazione:

Lib non può avere quindi solo "main.dart" => dove effettivamente ci sarà il main eseguibile. Bensì dobbiamo riuscire a creare tutte le pagine dell'applicativo e le feature.

* Cartella Core (logica)
	* Database (dove avremo i dati)
	* Temi (semplici temi applicativi)
	* Utili (date, soldi e periodi.)
* Features (la cartella degli effettivi elementi)
	* Dashboard (pagina e modelli viste)
	* Transazioni/movimenti
	* Benzina
	* Iscrizioni
	* Risparmi
	* Impostazioni
* Shared (i file condivisi:)
	* Widget (Ovvero i macro elementi condivisi tra tutti.)

Stiamo quindi dividendo l'applicazione in un architettura a livelli:

* **UI**: schermate e widget;
- **LOGICA**: calcoli e gestione dello stato;
- **DATI**: database e repository.

# Database
Il database per essere compatibile il più possibile può usare sqflite oppure DRIFT.
Per installarlo/aggiungerlo basta anche un comando come:

```PowerShell
flutter pub add drift drift_flutter intl fl_chart
flutter pub add --dev drift_dev build_runner
```

Questo scaricherà la libreria e dipendenze richieste ovviamente.

-> Parlando quindi del database, che verrà contenuto in app_database.dart. Alla prima generazione ci saranno sicuramente degli errori come

```dart
part 'app_database.g.dart';
```

e

```dart
_$AppDatabase
```

ma il `.g.dart` non deve esser creato Manualmente -> [Creare il g.dart](#Creare%20il%20g.dart).

Le tabelle ed il codice ispirate al tracker spese si trova in -> [trackerTable](trackerTable.md).

# Database Dart
OBJ: Spiegare poi i vari elementi.
[Presentazione Dart e Flutter](Presentazione%20Dart%20e%20Flutter.md).
[Sintassi Dart](Sintassi%20Dart.md).
# Creare il g.dart

Drift (il tipo di database che stiamo usando), lo genererà una volta scritto tutte le tabelle e codice entità.

Dalla cartella del progetto basta eseguire:

`dart run build_runner build --delete-conflicting-outputs`

Da qui quindi si dovrebbe creare da solo il file.

***NON MODIFICATE IL FILE G.DART.***
***Quando modificate una tabella, rimandate il comando sul prompt!***
***Si potrebbe anche evitare la rigenerazione se questi cambiamenti non cambiano la struttura.***

Creato il g.dart possiamo concludere con `database_provider.dart` e  semplicemente inserire

Questo agirà come istanza unica del database:
```dart
import 'app_database.dart';

/// Unica istanza del database utilizzata dall'intera applicazione.
final AppDatabase database = AppDatabase();
```

È consigliabile avere un istanza unica così da non aprire un database ad ogni nuova schermata.

# Colleghiamolo per test al Main.
Giusto per verificare che il DB sia funzionante e sistemato risaliamo a `lib/main.dart` e colleghiamolo. Temporaneamente potremmo inserire questo [codiceMainTest](codiceMainTest.md).


# Creiamo il modulo dei "Movimenti"
Usiamo quindi la cartella "Features", alla quale dentro inseriremo "transactions"(movimenti) e altre 2 cartelle:
* data
* presentation

NB: Ricorda anche ci servirà la cartella `utils` così da avere anche `lib/core/utils/money_utils.dart`.

Dentro al quale inserirai il codice [codiceMoneyUtils](codiceMoneyUtils.md).

Poi `lib/core/utils/date_utils.dart`. -> [codiceDateUtils](codiceDateUtils.md). 

Ed infine creiamo la repository dei movimenti. -> [codiceTransactionRepo](codiceTransactionRepo.md).
## Infine Penseremo al form di Inserimento e modifica
Questo tipo di form usa un globalKey `GlobalKey<FormState>` e `TextEditingController`. Questa struttura serve per raggruppare e validare i campi prima del Salvataggio. I Controller devono essere liberati con `dispose()`.

percorso: `lib/feature/transactions/presentation/transaction_form_page.dart`

[codiceTransactionFormPage](codiceTransactionFormPage.md).

e si finisce con: `lib/feature/transactions/presentation/transaction_page.dart`

[codiceTrasactionPage](codiceTrasactionPage.md).

La schermata viene aperta e chiusa con Navigator. `push()` o `pop()`.

## Da qui, Modifichiamo di nuovo il Main

[codiceMainMovimenti](codiceMainMovimenti.md).

# Test
Potremmo tranquillamente runnare e controllare, ma se vogliamo controllare il codice prima di eseguirlo:

* Riorganizzare (identazione ecc.)
```PowerShell
dart format lib
```
* Analizzare (controllare il codice)
```PowerShell
flutter analyze
```

Ma si può tranquillamente runnare a questo punto.

## Arrivati a questo punto => TROUBLESHOOTING
Se avete copiato il codice in modo brainless, facendo analyze flutter troverà degli errori:

### 1.
`lib/features/transactions/presentation/transaction_form_page.dart` verso riga 234 - 264 - 338

```dart
value: _selectedType,
```

in:

```dart
initialValue: _selectedType_
```

Semplice problema di versionamento Flutter.

### 2.
Il test predefinito creato automaticamente dal progetto Flutter iniziale si chiama `MyApp`, ma noi lo abbiamo rinominato in: `TrackerSpeseApp`.

Quindi Flutter cerca il vecchio, non il nuovo.

In: `test\widget_test.dart` può esser cambiato in: [oldWidgetTestChange](oldWidgetTestChange.md).

Per esser sicuri che il nome del package sia giusto, si può controllare nel `pubspec.yaml`.

