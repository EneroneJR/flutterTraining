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
* [Presentazione Dart e Flutter](Presentazione%20Dart%20e%20Flutter.md).
* [Sintassi Dart](Sintassi%20Dart.md).
* [DataBase (definire le Tabelle)](DataBase%20(definire%20le%20Tabelle).md).
* [Registrazione Tabelle pt2](Registrazione%20Tabelle%20pt2.md).
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

---
# Movimenti e Main

Puntiamo adesso

---

# Front End Focus

Flutter come FrontEnd si sfrutta piccoli oggetti/container chiamati [[Widget]].

Testi, pulsanti, spazi, righe e persino pagine sono windget. L'interfaccia quindi è un albero di widget.
## Percorso di apprendimento frontend

Procederemo in questo ordine:

1. struttura minima di un’app Flutter;
2. sintassi Dart necessaria per il frontend;
3. widget e albero dei widget;
4. `Row`, `Column`, `Padding`, `Expanded`, `ListView`;
5. widget personalizzati;
6. `StatelessWidget` e `StatefulWidget`;
7. variabili e `setState`;
8. pulsanti e callback;
9. campi di testo e form;
10. liste dinamiche;
11. navigazione tra pagine;
12. layout responsive per Windows e Android;
13. tema, colori e stile;
14. organizzazione frontend in più file.

Iniziamo dalla base reale.

---
## 1. Struttura Minima di un'app

Il file da modificare spesso è: `lib/main.dart`.

Codice di esempio -> [CodiceMainFrontExample](CodiceMainFrontExample.md).

La prima riga è:
```dart
import 'package:flutter/material.dart';
```
`import` rende disponibile codice scritto in un altro file o pacchetto. In questo caso `material.dart`.

Il quale ha diversi widget base come:

```dart
MaterialApp
Scaffold
AppBar
Text
Row
Column
Card
FilledButton
Icon
```
### Funzione `Main`
```dart
void main()
{
	runApp(const TrackerApp());
}
```
* Ogni programma Dart comincia dalla funzione `main()`. 
* `void` indica che la funzione non restituisce risultato.
* `runApp` dice a Flutter di avviare l'applicazione usando `TrackerApp` come widget principale.

## Che cosa è un Widget?
```dart
const TrackerApp()
```
Crea un oggeto della classe `TrackerApp`.

La classe è definita come:
```dart
class TrackerApp extends StatelessWidget (
```
StatelessWidget è nativo Flutter. Un widget non per forza è qualcosa di visibile. Esempi:
```dart
Text('Ciao') // mostra un testo
Padding(...) // aggiunge spazio
Row(...) // Dispone gli elemeneti orizzontalmente
MaterialApp(...) // configura l'intera app.
```

## Metodo `Build`
Ogni Widget deve descrivere la propria interfaccia:
```dart
@override
Widget build(BuildContext context) {
	return MaterialApp(...);
}
```
* `Widget` è il tipo restituito dalla funzione.
* `build` è la funzione flutter che chiama per sapere cosa visualizzare
* `BuildContext context` contiene informazioni sulla posizione del widget nell'app.

Attraverso `context` possiamo recuperare:
* Tema
* Dimensioni
* Navigazione
* Messaggi
* Widget Genitori

`Return` => abbastanza ovvio.
### `MaterialApp`

```dart
return MaterialApp(
	debugShowCheckedModeBanner: false,
	title: 'Tracker Spese',
	theme: ThemeData(...),
	home: const DashboardPage(),
)
```
`MaterialApp` rappresenta la configurazione generale dell'applicazione.

#### Parametri Nominati
Dentro le parentesi abbiamo:
```dart
title: 'Tracker Spese',
theme: ThemeData(...),
home: const DashboardPage(),
```

La struttura generale è:
```dart
HomeParametro: valore
``` 
e sono separati dalle virgole.

***Anche se vi è una virgola finale, è consigliato metterla per aiutare Flutter e VSC a formattare il codice.***

---

## Pagina principale
```dart
class DashboardPage extends StatelessWidget
```
il suo metodo `build` restituisce:
```dart
Scaffold(
	appBar: ...,
	body: ...,
)
```
`Scaffold` crea la struttura standard di una schermata Material.

Questa può contenere:
```dart
appBar
body
floatingActionButton
bottomNavigationBar
drawer
```

nel nostro caso usiamo 
```dart
appBar: AppBar(...)
```
e
```dart
body: ListView(...)
```

### Albero dei Widget
```dart
Scaffold(  
	appBar: AppBar(  
		title: Text('Tracker spese'),  
	),  
	body: ListView(  
		children: [  
			Text('Maggio 2026'),  
			SummaryCard(...),  
			FilledButton(...),  
		],  
	),  
)
```
forma un albero:

```
Scaffold  
├── AppBar  
│   └── Text  
└── ListView  
	├── Text  
	├── SummaryCard  
	└── FilledButton
```
Flutter funziona componendo prima i Widget piccoli e poi quelli più grandi.

---
## Differenza tra `Child` e `Children`
Questa differenza è importante in Flutter,

`Child`
Contiene un solo Widget:
```dart
Padding(
	child: Text('ciao'),
)
```

`Padding` può avere un solo figlio.

`Children`
Contiene una lista di Widget:
```dart
Column(
	children: [
		Text('Primo'), // widget 1
		Text('Secondo'), // widget 2
		Text('Terzo'), // widget 3
	],
)
```
Le parentesi quadre `[]` rappresentano una lista.

---
## ListView
```dart
body: ListView(
	padding: const EdgeInsets.all(16),
	children: [
		//contenuto
	],
)
```
`ListView` dispone i widget verticalmente e permette lo scorrimento.

È utile perchè la Dashboard potrebbe essere più alta dello schermo.

Se avessimo usato `Column(...)` il contenuto avrebbe potuto uscire dallo schermo, provocando un errore grafico di overflow.

---

## Padding
```dart
padding: const EdgeInsets.all(16)
```
Aggiunge spazzio interno di N pixel:

```
┌─────────────────────────┐  
│        spazio 16        │  
│   contenuto interno     │  
│        spazio 16        │  
└─────────────────────────┘
```

#### Esempi:
```dart
const EdgeInsets.symmetric(
  horizontal: 16,
  vertical: 8,
)

const EdgeInsets.only(
  left: 16,
  top: 8,
)
```

---
## SizedBox

```dart
const SizedBox(height: 24) // spazio verticale.
const SizedBox(width: 12) // spazio orizzontale.
```

Non mostrano nulla, occupano solo spazio.

---
## Row

```dart
Row(
  children: [
    widget1,
    widget2,
  ],
)
```

`Row` dispone i widget orizzontalmente: `    [Widget 1]         [Widget 2]     `.

Nel codice:
```dart
const Row(
  children: [
    Expanded(
      child: SummaryCard(...),
    ),
    SizedBox(width: 12),
    Expanded(
      child: SummaryCard(...),
    ),
  ],
)
```

Sono due schede affiancate.

---
## Expanded
```dart
Expanded(
	child: SummaryCart(...),
)
```

Questo indica che deve occupare tutto lo spazio disponibile in riga.

Se abbiamo 2 expanded, verrà diviso in parti uguali. Senza questo attributo le schede occuperebbero il minimo necessario.

---
# Text
```dart
const Text(
	'Maggio 2026',
	style: textStyle(
		fontSize: 28,
		fontWeight: FontWeight.bold,
	),
)
```

Il primo è il testo, lo `style` è lo stile.

---
## Const
Come già detto, variabili non già conosciuto da un hardcode ecc. non possono essere dichiarate come Const. Non vanno bene dati conosciuti solo dopo l'esecuzione.

---
# Widget personalizzato

```dart
class SummaryCard extends StatelessWidget
```
Questo è un widget che creiamo noi, non esiste in flutter.

Serve anche ad evitare spesso codice come:
```dart
Card(
  child: Padding(
    child: Column(
      children: [
        Icon(...),
        Text(...),
        Text(...),
      ],
    ),
  ),
)
```

Che viene magari trasformato in:

```dart
const SummaryCard(
  title: 'Stipendio',
  value: '€ 1.400,00',
  icon: Icons.account_balance_wallet,
)
```

---
## Proprietà del Widget

Dentro a `SummaryCard` abbiamo:
```dart
final String title;
final String value;
final iconData icon;
```
Che sono variabili appartenenti al widget.
### IconData
```dart
IconData: icon
```
Indica un icona Flutter.
### Final
Il valore viene assegnato una volta durante la costruzione del widget e non verrà modificato.

---
## Costruttore
```dart
const SummaryCard({
	super.key,
	required this.title,
	required this.value,
	required this.icon,
});
```

questo è un costruttore. Motivo per il quale quando li chiamiamo...
```dart
SummaryCard(
  title: 'Spese',
  value: '€ 732,69',
  icon: Icons.shopping_cart,
)
```

Ed il `required` indica che è obbligatorio. Se manca uno dei required, vi sarà un errore.

---
## Pulsante
```dart
FilledButton.icon(
  onPressed: () {
    // codice eseguito al click
  },
  icon: const Icon(Icons.add),
  label: const Text('Aggiungi movimento'),
)
```

Il pulsante ha 3 elementi importanti:
* `onPressed`
* `icon`
* `label`
### onPressed
è ciò che succede quando il pulsante viene premuto:
```dart
onPressed: () {
	print('Premuto');
}
```

Ma con sopra scritto:
```dart
(){
}
```
Indica una funzione anonima, usata solo e soltanto dal pulsante.

---
## Messaggio SnackBar
```dart
ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(
    content: Text('Pulsante premuto'),
  ),
);
```

Mostra temporaneamente un messaggio nella parte inferiore della pagina:
```dart
ScaffoldMessenger.of(context)
```

Cerca il gestore dei messaggi associato allo Scaffold corrente e poi:
```dart
showSnackBar(...)
```

---
## StatelessWidget

Tutti i widget creati finora sono: `extends StatelessWidget`. Il quale riceve dati e li mostra, ma non li modifica direttamente da uno stato interno.

Per quello si dovrebbe usare...

---
## StatefulWidget

Gibberish buffer.
