import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// ---------------------------------------------------------------------------
/// IMPOSTAZIONI GENERALI
/// ---------------------------------------------------------------------------
///
/// Questa tabella avrà normalmente una sola riga, con id = 1.
///
/// Gli importi sono salvati in centesimi:
/// 140000 = € 1.400,00
/// 100000 = € 1.000,00
/// 540000 = € 5.400,00
class AppSettings extends Table {
  @override
  String get tableName => 'app_settings';

  late final id = integer().withDefault(const Constant(1))();

  late final monthlySalaryCents = integer().withDefault(
    const Constant(140000),
  )();

  late final monthlySavingsTargetCents = integer().withDefault(
    const Constant(100000),
  )();

  late final initialSavingsCents = integer().withDefault(
    const Constant(540000),
  )();

  late final periodStartDay = integer().withDefault(const Constant(15))();

  late final referenceYear = integer().withDefault(const Constant(2026))();

  late final createdAt = dateTime().withDefault(currentDateAndTime)();

  late final updatedAt = dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// ---------------------------------------------------------------------------
/// CATEGORIE
/// ---------------------------------------------------------------------------
///
/// Le categorie potranno essere selezionate quando inseriamo una spesa.
class Categories extends Table {
  late final id = integer().autoIncrement()();

  late final name = text().withLength(min: 1, max: 100)();

  /// Valori previsti:
  /// essential = imprescindibile
  /// leisure = svago
  /// extra = extra
  late final suggestedType = text().withDefault(const Constant('essential'))();

  late final active = boolean().withDefault(const Constant(true))();

  late final sortOrder = integer().withDefault(const Constant(0))();

  late final createdAt = dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {name},
  ];
}

/// ---------------------------------------------------------------------------
/// MOVIMENTI / SPESE
/// ---------------------------------------------------------------------------
///
/// La classe Dart si chiama ExpenseMovements.
/// La tabella SQLite si chiamerà transactions.
class ExpenseMovements extends Table {
  @override
  String get tableName => 'transactions';

  late final id = integer().autoIncrement()();

  late final date = dateTime()();

  late final categoryId = integer()
      .references(
        Categories,
        #id,
        onUpdate: KeyAction.cascade,
        onDelete: KeyAction.setNull,
      )
      .nullable()();

  /// Valori previsti:
  /// essential
  /// leisure
  /// extra
  late final type = text().withDefault(const Constant('essential'))();

  late final description = text().withLength(min: 1, max: 250)();

  /// Importo salvato in centesimi.
  late final amountCents = integer()();

  late final paymentMethod = text().nullable()();

  late final notes = text().nullable()();

  late final createdAt = dateTime().withDefault(currentDateAndTime)();

  late final updatedAt = dateTime().withDefault(currentDateAndTime)();
}

/// ---------------------------------------------------------------------------
/// RIFORNIMENTI
/// ---------------------------------------------------------------------------
class FuelRefills extends Table {
  late final id = integer().autoIncrement()();

  late final date = dateTime()();

  /// Importo pagato in centesimi.
  late final amountCents = integer()();

  /// Litri moltiplicati per 1000.
  ///
  /// 28,530 litri vengono salvati come 28530.
  late final litersMilli = integer()();

  /// Chilometri percorsi dal precedente rifornimento.
  late final kilometers = integer().nullable()();

  late final fuelType = text().withDefault(const Constant('GPL'))();

  late final notes = text().nullable()();

  late final createdAt = dateTime().withDefault(currentDateAndTime)();

  late final updatedAt = dateTime().withDefault(currentDateAndTime)();
}

/// ---------------------------------------------------------------------------
/// ABBONAMENTI
/// ---------------------------------------------------------------------------
class Subscriptions extends Table {
  late final id = integer().autoIncrement()();

  late final name = text().withLength(min: 1, max: 150)();

  late final category = text().nullable()();

  /// essential, leisure oppure extra.
  late final type = text().withDefault(const Constant('essential'))();

  /// Costo mensile in centesimi.
  late final monthlyCostCents = integer()();

  late final active = boolean().withDefault(const Constant(true))();

  /// Giorno del mese in cui viene addebitato.
  late final chargeDay = integer().nullable()();

  late final notes = text().nullable()();

  late final createdAt = dateTime().withDefault(currentDateAndTime)();

  late final updatedAt = dateTime().withDefault(currentDateAndTime)();
}

/// ---------------------------------------------------------------------------
/// MOVIMENTI DEL SALVADANAIO
/// ---------------------------------------------------------------------------
class SavingsMovements extends Table {
  late final id = integer().autoIncrement()();

  late final date = dateTime()();

  late final description = text().withLength(min: 1, max: 250)();

  /// deposit = versamento
  /// withdrawal = prelievo
  late final type = text()();

  /// Importo in centesimi.
  late final amountCents = integer()();

  late final notes = text().nullable()();

  late final createdAt = dateTime().withDefault(currentDateAndTime)();
}

/// ---------------------------------------------------------------------------
/// DATABASE PRINCIPALE
/// ---------------------------------------------------------------------------
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
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'tracker_spese'));

  /// Versione iniziale della struttura del database.
  @override
  int get schemaVersion => 1;

  /// Creazione iniziale e dati predefiniti.
  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator migrator) async {
        await migrator.createAll();

        await into(appSettings).insert(
          const AppSettingsCompanion(
            id: Value(1),
            monthlySalaryCents: Value(140000),
            monthlySavingsTargetCents: Value(100000),
            initialSavingsCents: Value(540000),
            periodStartDay: Value(15),
            referenceYear: Value(2026),
          ),
        );

        await batch((batch) {
          batch.insertAll(categories, [
            CategoriesCompanion.insert(
              name: 'Benzina',
              suggestedType: const Value('essential'),
              sortOrder: const Value(1),
            ),
            CategoriesCompanion.insert(
              name: 'Abbonamenti',
              suggestedType: const Value('essential'),
              sortOrder: const Value(2),
            ),
            CategoriesCompanion.insert(
              name: 'Bollette',
              suggestedType: const Value('essential'),
              sortOrder: const Value(3),
            ),
            CategoriesCompanion.insert(
              name: 'Spesa/Alimentari',
              suggestedType: const Value('essential'),
              sortOrder: const Value(4),
            ),
            CategoriesCompanion.insert(
              name: 'Casa',
              suggestedType: const Value('essential'),
              sortOrder: const Value(5),
            ),
            CategoriesCompanion.insert(
              name: 'Trasporti',
              suggestedType: const Value('essential'),
              sortOrder: const Value(6),
            ),
            CategoriesCompanion.insert(
              name: 'Salute',
              suggestedType: const Value('essential'),
              sortOrder: const Value(7),
            ),
            CategoriesCompanion.insert(
              name: 'Svago',
              suggestedType: const Value('leisure'),
              sortOrder: const Value(8),
            ),
            CategoriesCompanion.insert(
              name: 'Ristoranti',
              suggestedType: const Value('leisure'),
              sortOrder: const Value(9),
            ),
            CategoriesCompanion.insert(
              name: 'Shopping',
              suggestedType: const Value('leisure'),
              sortOrder: const Value(10),
            ),
            CategoriesCompanion.insert(
              name: 'Viaggi',
              suggestedType: const Value('leisure'),
              sortOrder: const Value(11),
            ),
            CategoriesCompanion.insert(
              name: 'Extra',
              suggestedType: const Value('extra'),
              sortOrder: const Value(12),
            ),
            CategoriesCompanion.insert(
              name: 'Altro',
              suggestedType: const Value('extra'),
              sortOrder: const Value(13),
            ),
          ]);
        });
      },

      /// SQLite non abilita automaticamente le chiavi esterne.
      beforeOpen: (OpeningDetails details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }

  // --------------------------------------------------------------------------
  // QUERY IMPOSTAZIONI
  // --------------------------------------------------------------------------

  Future<AppSetting> getSettings() {
    return (select(appSettings)..where((row) => row.id.equals(1))).getSingle();
  }

  Stream<AppSetting> watchSettings() {
    return (select(
      appSettings,
    )..where((row) => row.id.equals(1))).watchSingle();
  }

  Future<int> updateSettings(AppSettingsCompanion newSettings) {
    return (update(
      appSettings,
    )..where((row) => row.id.equals(1))).write(newSettings);
  }

  // --------------------------------------------------------------------------
  // QUERY CATEGORIE
  // --------------------------------------------------------------------------

  Future<List<Category>> getAllCategories() {
    return (select(categories)..orderBy([
          (row) => OrderingTerm.asc(row.sortOrder),
          (row) => OrderingTerm.asc(row.name),
        ]))
        .get();
  }

  Stream<List<Category>> watchActiveCategories() {
    return (select(categories)
          ..where((row) => row.active.equals(true))
          ..orderBy([
            (row) => OrderingTerm.asc(row.sortOrder),
            (row) => OrderingTerm.asc(row.name),
          ]))
        .watch();
  }
}
