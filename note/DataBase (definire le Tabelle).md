Il database si troverà sempre nel core se è locale.

`lib/core/database/app_database.dart`

Il database conterrà:
* La descrizione delle tabelle.
* La struttura delle colonne.
* Apertura del database.
* Creazione dei dati iniziali.
* Eventuali Query.
---
# Import

All'inizio del file spesso abbiamo:

```dart
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
```

Abbiamo detto che usavamo drift per il db e per tanto importando `drift.dart` abbiamo disponibili elementi come:

```dart
import 'package:drift/drift.dart';

Table
integer()
text()
MigrationStrategy
Value
```

Mentre il secondo

```dart
import 'package:drift_flutter/drift_flutter.dart';

driftDatabase()
```

Questo comando, apre il database sulle diverse piattaforme.

---
# File generato
Abbiamo anche scritto:
```dart
part 'app_database.g.dart';
```

Che indica che il file fa parte di questo insieme di codice. la denominazione `.g.` indica però che è stato generato -> (rivedere il README di presentazione).

creato dal prompt:
```powershell
dart run build_runner build
```

Drift vi inserisce:

- classi per le righe delle tabelle;
- classi per gli inserimenti;
- classi per gli aggiornamenti;
- codice SQL;
- conversioni tra SQLite e Dart;
- controlli sui tipi.

---
# Tabella `AppSettings`

In `app_database.dart` abbiamo:
```dart
class AppSettings extends Table{
```

Molto banalmente abbiamo creato una classe `AppSettings`, ma che estende la classe `Table`.

* Table => Classe Drift => DB
* AppSettings => Estende Table => Si può considerare una table.

Con questo la tabella AppSettings recupera già proprietà della classe Table padre.

Di conseguenza servono piccole accortezze personalizzate tipo:

```dart
@override
String get tableName => 'app_settings';
```

>`@override`:
> Sto sostituendo una proprietà già prevista dalla classe genitore.

>`String get tableName` è un "getter".

> `=> 'app_settings';` è un abbreviazione di una funzione:
```dart
String get tableName { 
	return 'app_settings'; 
}
``` 

##### Quindi.
La classe Dart ed entità tabella si chiama:
`AppSettings`

La tabella SqLite si chiama invece:
`app_settings`

---
## Colonna ID

```dart
late final id = integer().withDefault(const Constant(1))();
```

late e final lo abbiamo già visto.

`id` => è il nome della colonna

`integer()` => è il tipo della colonna. Numeri interi.

`withDefault(...)` => stabilisce un valore predefinito.

`const Constat(1)` => significa che il valore predefinito SQL è `1`.

`()` => le parentesi finali servono per concludere la costruzione della colona.

Il risultato è praticamente:

```SQL
id INTEGER NOT NULL DEFAULT 1
```

## Autoincrement
Ovviamente le colonne id molteplici devono essere auto incrementate per assicurare unicità
```dart
late final id = integer().autoIncrement()();
```

---
### Altri dati

```dart
late final createdAt = dateTime().withDefault(currentDateAndTime)();
```
`dateTime()` indica una data con orario.

`currentDateAndTime` dice a SQLite:

> Quando viene creata la riga, usa automaticamente data e ora attuali.

---
# Chiave Primaria
```dart
@override
Set<Column<Object>> get primaryKey => {id};
```

Settiamo la chiave primaria, la quale identifica univocamente una riga. In questo caso la riga id

## Nota Bene
Si consiglia che le chiavi ID siano auto incrementate:

```dart
late final id = integer().autoIncrement()();
```

## Valori Unici
```dart
@override
List<Set<Column<Object>>> get uniqueKeys => [
	{name},
]
```

Significa che dentro la tabella, i valori nome devono essere UNICI e non uguali.

## Chiavi Esterne
```dart
late final categoryId = integer()
	.references(
		Categories,
		#id,
		onUpdate: KeyAction.cascade,
		onDelete: KeyAction.setNull,
	)
	.nullable()();
```

***Grazie a `.references(...)`.***

Significa che `Category Id` punta alla colonna `Id` di `Categories`.

Esempio:

```
categoriesTable
id: 10
name: Shopping
```

Movimento:

```
movimentoTable
description: Rasoio di sicurezza
categoryId: 10
```

Il movimento non salva nuovamente la parola `Shopping`. Salva l’ID `10`.

Questo evita duplicazioni e incongruenze.

### Simbolo #id
In Dart si crea un simbolo `Symbol`.
Drift lo usa per indicare:
> La colonna chiamata `id`.

### Aggiornamento e Cancellazione

```dart
onUpdate: KeyAction.cascade
```
Se il valore della chiave collegata cambia, Drift aggiorna i riferimenti.

```dart
onDelete: KeyAction.setNull
```
Se la categoria viene eliminata, non cancella il movimento.

---

## Altri esempi

### Null
```dart
late final notes = text().nullable()();
```

Se vuoi un dato che possa avere valori `NULL`, è essenziale che ci sia `nullable()`.
### Attributi Lengths
```dart
late final name = text().withLength(
	min:1,
	max: 100,
)();
```

`withLength()` => indica la lunghezza, in modo tale che possa non esser vuoto.

---
# Abbiamo concluso il come si definiscono le tabelle, per continuare => [Registrazione Tabelle pt2](Registrazione%20Tabelle%20pt2.md)

---
# Gibberish finale(?)
### Tipi Suggeriti

```dart
late final suggestedType = text().withDefault(const Constant('essential')).();
```

Questa colonna salva valori come:

```
essential
leisure
extra
```
Il come questi vengano sistemati verrà spiegato in -> [Migrazione&Extra](migration).

---
