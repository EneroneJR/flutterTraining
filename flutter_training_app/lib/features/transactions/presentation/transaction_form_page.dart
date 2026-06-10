import 'package:flutter/material.dart';

import '../../../core/database/app_database.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/utils/money_utils.dart';
import '../data/transactions_repository.dart';

class TransactionFormPage extends StatefulWidget {
  final TransactionsRepository repository;

  /// Quando movement è null, il form inserisce un nuovo movimento.
  /// Quando movement è valorizzato, il form modifica quello esistente.
  final ExpenseMovement? movement;

  const TransactionFormPage({
    super.key,
    required this.repository,
    this.movement,
  });

  @override
  State<TransactionFormPage> createState() {
    return _TransactionFormPageState();
  }
}

class _TransactionFormPageState extends State<TransactionFormPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _descriptionController;
  late final TextEditingController _amountController;
  late final TextEditingController _notesController;

  late DateTime _selectedDate;

  int? _selectedCategoryId;
  String _selectedType = 'essential';
  String? _selectedPaymentMethod;

  bool _saving = false;

  static const Map<String, String> _types = {
    'essential': 'Imprescindibile',
    'leisure': 'Svago',
    'extra': 'Extra',
  };

  static const List<String> _paymentMethods = [
    'Carta',
    'Contanti',
    'Bonifico',
    'Addebito',
    'Altro',
  ];

  bool get _isEditing => widget.movement != null;

  @override
  void initState() {
    super.initState();

    final movement = widget.movement;

    _selectedDate = movement?.date ?? DateTime.now();
    _selectedCategoryId = movement?.categoryId;
    _selectedType = movement?.type ?? 'essential';

    final existingPaymentMethod = movement?.paymentMethod;

    if (existingPaymentMethod != null &&
        _paymentMethods.contains(existingPaymentMethod)) {
      _selectedPaymentMethod = existingPaymentMethod;
    }

    _descriptionController = TextEditingController(
      text: movement?.description ?? '',
    );

    _amountController = TextEditingController(
      text: movement == null
          ? ''
          : (movement.amountCents / 100)
                .toStringAsFixed(2)
                .replaceAll('.', ','),
    );

    _notesController = TextEditingController(text: movement?.notes ?? '');
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    _notesController.dispose();

    super.dispose();
  }

  Future<void> _selectDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      helpText: 'Seleziona la data',
      cancelText: 'Annulla',
      confirmText: 'Conferma',
    );

    if (selectedDate == null) {
      return;
    }

    setState(() {
      _selectedDate = selectedDate;
    });
  }

  Future<void> _save() async {
    final formState = _formKey.currentState;

    if (formState == null || !formState.validate()) {
      return;
    }

    final amountCents = parseEuroToCents(_amountController.text);

    if (amountCents == null || amountCents <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Inserisci un importo valido maggiore di zero.'),
        ),
      );

      return;
    }

    setState(() {
      _saving = true;
    });

    try {
      final movement = widget.movement;

      if (movement == null) {
        await widget.repository.addMovement(
          date: _selectedDate,
          categoryId: _selectedCategoryId,
          type: _selectedType,
          description: _descriptionController.text,
          amountCents: amountCents,
          paymentMethod: _selectedPaymentMethod,
          notes: _notesController.text,
        );
      } else {
        await widget.repository.updateMovement(
          id: movement.id,
          date: _selectedDate,
          categoryId: _selectedCategoryId,
          type: _selectedType,
          description: _descriptionController.text,
          amountCents: amountCents,
          paymentMethod: _selectedPaymentMethod,
          notes: _notesController.text,
        );
      }

      if (!mounted) {
        return;
      }

      Navigator.pop(context, true);
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Errore durante il salvataggio: $error')),
      );

      setState(() {
        _saving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Modifica movimento' : 'Nuovo movimento'),
      ),
      body: StreamBuilder<List<Category>>(
        stream: widget.repository.watchActiveCategories(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: SelectableText(
                'Errore durante il caricamento delle categorie:\n\n'
                '${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final categories = snapshot.data!;

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                InkWell(
                  onTap: _saving ? null : _selectDate,
                  borderRadius: BorderRadius.circular(12),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Data',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_month),
                    ),
                    child: Text(formatItalianDate(_selectedDate)),
                  ),
                ),
                const SizedBox(height: 16),

                DropdownButtonFormField<int>(
                  initialValue: _selectedCategoryId,
                  decoration: const InputDecoration(
                    labelText: 'Categoria',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.category),
                  ),
                  items: categories.map((category) {
                    return DropdownMenuItem<int>(
                      value: category.id,
                      child: Text(category.name),
                    );
                  }).toList(),
                  onChanged: _saving
                      ? null
                      : (value) {
                          setState(() {
                            _selectedCategoryId = value;
                          });
                        },
                  validator: (value) {
                    if (value == null) {
                      return 'Seleziona una categoria.';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  initialValue: _selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Tipo',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.label),
                  ),
                  items: _types.entries.map((entry) {
                    return DropdownMenuItem<String>(
                      value: entry.key,
                      child: Text(entry.value),
                    );
                  }).toList(),
                  onChanged: _saving
                      ? null
                      : (value) {
                          if (value == null) {
                            return;
                          }

                          setState(() {
                            _selectedType = value;
                          });
                        },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _descriptionController,
                  enabled: !_saving,
                  decoration: const InputDecoration(
                    labelText: 'Descrizione',
                    hintText: 'Esempio: Spesa supermercato',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.description),
                  ),
                  textInputAction: TextInputAction.next,
                  maxLength: 250,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Inserisci una descrizione.';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 8),

                TextFormField(
                  controller: _amountController,
                  enabled: !_saving,
                  decoration: const InputDecoration(
                    labelText: 'Importo',
                    hintText: 'Esempio: 22,80',
                    prefixText: '€ ',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.euro),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    final cents = parseEuroToCents(value ?? '');

                    if (cents == null || cents <= 0) {
                      return 'Inserisci un importo valido.';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  initialValue: _selectedPaymentMethod,
                  decoration: const InputDecoration(
                    labelText: 'Metodo di pagamento',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.payment),
                  ),
                  items: _paymentMethods.map((method) {
                    return DropdownMenuItem<String>(
                      value: method,
                      child: Text(method),
                    );
                  }).toList(),
                  onChanged: _saving
                      ? null
                      : (value) {
                          setState(() {
                            _selectedPaymentMethod = value;
                          });
                        },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _notesController,
                  enabled: !_saving,
                  decoration: const InputDecoration(
                    labelText: 'Note',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.notes),
                    alignLabelWithHint: true,
                  ),
                  minLines: 3,
                  maxLines: 5,
                ),
                const SizedBox(height: 24),

                FilledButton.icon(
                  onPressed: _saving ? null : _save,
                  icon: _saving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save),
                  label: Text(
                    _saving
                        ? 'Salvataggio...'
                        : _isEditing
                        ? 'Salva modifiche'
                        : 'Aggiungi movimento',
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
