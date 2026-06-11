A fine creazione tabelle si dovrà mettere/troviamo:

```dart
@DriftDatabase(
	tables: [
		AppSettings,
		Categories,
		ExpenseMovements,
		FuelRefills,
		Subscriptions,
		SavingsMovements,
	],
)
```

`@DriftDatabase` è un'**annotazione**.

Dice al generatore Drift:

> Queste sono le tabelle che appartengono al DataBase.

Se in futuro si creerà una nuova tabella, non basta solo dichiararla, ma anche aggiungerla qui.

---
# Classe AppDatabase
```dart
class AppDatabase extends _$AppDatabase_ {
```

La classe:
```
_$AppDatabase` 
```
Non la creiamo noi, ma viene creata da: `lib/core/database/app_database.g.dart`.

La nostra Classe `AppDatabase` estende solo quella autogenerata. Così da permettere a drift di aggiungere automaticamente le proprietà come:
```dart
appSettings
categories
expenseMovements
fuelRefills
```

---
# Costruttore del Database
```dart
AppDatabase([QueryExecutor? executor])
	: super(
		executor ??
			driftDatabase (
				name: 'tracker_spese',
			),
	);
```

Questa è una parte ***Complessa***.

## `AppDatabase(...)`
è il costruttore della classe.

Quando scriviamo:
```dart
AppDatabase()
```
Viene eseguito il codice.

## Parametro Opzionale
```dart
[QueryExecutor? executor]
```
Le parentesi quadrate indicano un parametro posizionale facoltativo.

Il simbolo `?` significa che può essere `null`.

Quindi possiamo usare `AppDatabase()` oppure passare un executor personalizzato durante i test.

### Operatore `??`
```dart
executor ?? driftDatabase(...)
```

Significa:
> Usa `executor` se non è null, altrimenti usa `driftDatabase(...)`.

Ovvero un if:
```dart
if(executor != null)
{
	return executor;
}else
{
	return driftDatabase(...);
}
```

### Nome del Database
```dart
driftDatabase(
	name: 'tracker_spese',
)
```
Apre o crea il database chiamato:
```
tracker_spese
```

---
## Versione dello schema
```dart
@override
int get schemaVersion => 1;
```
Questa è la versione della struttura DB.

è importante quando si modifica le colonne dell'app se è già stata utilizzata. Dovremmo aggiornare la versione e creare una migrazione. Questo perchè Dart non aggiorna automaticamente un vecchio DB già esistente.

## Strategia di Migrazione
```dart
@override
MigrationStrategy get migration{
	return MigrationStrategy (
```
Qui stabiliamo cosa fare in caso di:
* DB creato
* DB Aperto
* DB modificato/aggiornato

---
### On create
```dart
onCreate: (Migrator migrator) async {
```

# SOSPENSIONE => Riprendere successivamente