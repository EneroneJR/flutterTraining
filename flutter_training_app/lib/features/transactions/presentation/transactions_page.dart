import 'package:flutter/material.dart';

import '../../../core/database/app_database.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/utils/money_utils.dart';
import '../data/transactions_repository.dart';
import 'transaction_form_page.dart';

class TransactionsPage extends StatelessWidget {
  final TransactionsRepository repository;

  const TransactionsPage({super.key, required this.repository});

  Future<void> _openForm(
    BuildContext context, {
    ExpenseMovement? movement,
  }) async {
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute<bool>(
        builder: (context) {
          return TransactionFormPage(
            repository: repository,
            movement: movement,
          );
        },
      ),
    );

    if (saved == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            movement == null
                ? 'Movimento aggiunto correttamente.'
                : 'Movimento modificato correttamente.',
          ),
        ),
      );
    }
  }

  Future<void> _deleteMovement(
    BuildContext context,
    ExpenseMovement movement,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Eliminare il movimento?'),
          content: Text(
            'Stai per eliminare:\n\n'
            '${movement.description}\n'
            '${formatEuro(movement.amountCents)}',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Annulla'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Elimina'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    try {
      await repository.deleteMovement(movement.id);

      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Movimento eliminato.')));
    } catch (error) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Errore durante l’eliminazione: $error')),
      );
    }
  }

  String _typeLabel(String type) {
    switch (type) {
      case 'essential':
        return 'Imprescindibile';

      case 'leisure':
        return 'Svago';

      case 'extra':
        return 'Extra';

      default:
        return type;
    }
  }

  IconData _typeIcon(String type) {
    switch (type) {
      case 'essential':
        return Icons.home_work_outlined;

      case 'leisure':
        return Icons.sports_esports_outlined;

      case 'extra':
        return Icons.auto_awesome_outlined;

      default:
        return Icons.receipt_long;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Movimenti')),
      body: StreamBuilder<List<MovementListItem>>(
        stream: repository.watchAllMovements(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: SelectableText(
                'Errore durante il caricamento dei movimenti:\n\n'
                '${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data!;

          if (items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.receipt_long_outlined,
                      size: 80,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Nessun movimento inserito',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Premi il pulsante + per aggiungere '
                      'la prima spesa.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
            itemCount: items.length,
            separatorBuilder: (context, index) {
              return const SizedBox(height: 8);
            },
            itemBuilder: (context, index) {
              final item = items[index];
              final movement = item.movement;

              return Card(
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {
                    _openForm(context, movement: movement);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(child: Icon(_typeIcon(movement.type))),
                        const SizedBox(width: 16),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                movement.description,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                [
                                  item.categoryName ?? 'Senza categoria',
                                  _typeLabel(movement.type),
                                  if (movement.paymentMethod != null)
                                    movement.paymentMethod!,
                                ].join(' · '),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                formatItalianDate(movement.date),
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 12),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              formatEuro(movement.amountCents),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              tooltip: 'Elimina',
                              onPressed: () {
                                _deleteMovement(context, movement);
                              },
                              icon: const Icon(Icons.delete_outline),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _openForm(context);
        },
        icon: const Icon(Icons.add),
        label: const Text('Aggiungi'),
      ),
    );
  }
}
