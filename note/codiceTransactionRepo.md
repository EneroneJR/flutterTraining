[[#Spiegazione]] del codice:
```dart
import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';

class MovementListItem {
  final ExpenseMovement movement;
  final String? categoryName;

  const MovementListItem({
    required this.movement,
    required this.categoryName,
  });
}

class TransactionsRepository {
  final AppDatabase database;

  const TransactionsRepository(this.database);

  /// Restituisce tutti i movimenti ordinati dal più recente.
  ///
  /// La JOIN permette di recuperare anche il nome della categoria.
  Stream<List<MovementListItem>> watchAllMovements() {
    final query = database.select(database.expenseMovements).join([
      leftOuterJoin(
        database.categories,
        database.categories.id.equalsExp(
          database.expenseMovements.categoryId,
        ),
      ),
    ]);

    query.orderBy([
      OrderingTerm.desc(database.expenseMovements.date),
      OrderingTerm.desc(database.expenseMovements.id),
    ]);

    return query.watch().map((rows) {
      return rows.map((row) {
        final movement = row.readTable(
          database.expenseMovements,
        );

        final category = row.readTableOrNull(
          database.categories,
        );

        return MovementListItem(
          movement: movement,
          categoryName: category?.name,
        );
      }).toList();
    });
  }

  /// Restituisce le categorie attive.
  Stream<List<Category>> watchActiveCategories() {
    return database.watchActiveCategories();
  }

  /// Inserisce un nuovo movimento.
  Future<int> addMovement({
    required DateTime date,
    required int? categoryId,
    required String type,
    required String description,
    required int amountCents,
    String? paymentMethod,
    String? notes,
  }) {
    return database.into(database.expenseMovements).insert(
          ExpenseMovementsCompanion.insert(
            date: date,
            categoryId: Value(categoryId),
            type: Value(type),
            description: description.trim(),
            amountCents: amountCents,
            paymentMethod: Value(
              _normalizeOptionalText(paymentMethod),
            ),
            notes: Value(
              _normalizeOptionalText(notes),
            ),
          ),
        );
  }

  /// Modifica un movimento esistente.
  ///
  /// Il valore restituito indica quante righe sono state modificate.
  Future<int> updateMovement({
    required int id,
    required DateTime date,
    required int? categoryId,
    required String type,
    required String description,
    required int amountCents,
    String? paymentMethod,
    String? notes,
  }) {
    final query = database.update(
      database.expenseMovements,
    )
      ..where((row) => row.id.equals(id));

    return query.write(
      ExpenseMovementsCompanion(
        date: Value(date),
        categoryId: Value(categoryId),
        type: Value(type),
        description: Value(description.trim()),
        amountCents: Value(amountCents),
        paymentMethod: Value(
          _normalizeOptionalText(paymentMethod),
        ),
        notes: Value(
          _normalizeOptionalText(notes),
        ),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Elimina un movimento.
  Future<int> deleteMovement(int id) {
    final query = database.delete(
      database.expenseMovements,
    )
      ..where((row) => row.id.equals(id));

    return query.go();
  }

  String? _normalizeOptionalText(String? value) {
    final normalized = value?.trim();

    if (normalized == null || normalized.isEmpty) {
      return null;
    }

    return normalized;
  }
}
```
# Spiegazione