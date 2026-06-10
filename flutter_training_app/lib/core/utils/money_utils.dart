String formatEuro(int cents) {
  final isNegative = cents < 0;
  final absoluteCents = cents.abs();

  final euros = absoluteCents ~/ 100;
  final decimalCents = absoluteCents % 100;

  final groupedEuros = euros.toString().replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (match) => '.',
  );

  final decimals = decimalCents.toString().padLeft(2, '0');
  final sign = isNegative ? '-' : '';

  return '$sign€ $groupedEuros,$decimals';
}

/// Converte una stringa come:
///
/// 22,80
/// 22.80
/// € 22,80
/// 1.400,50
///
/// nel corrispondente valore in centesimi.
int? parseEuroToCents(String input) {
  var normalized = input.trim().replaceAll('€', '').replaceAll(' ', '');

  if (normalized.isEmpty) {
    return null;
  }

  if (normalized.contains(',')) {
    normalized = normalized.replaceAll('.', '').replaceAll(',', '.');
  }

  final value = double.tryParse(normalized);

  if (value == null || value < 0) {
    return null;
  }

  return (value * 100).round();
}
