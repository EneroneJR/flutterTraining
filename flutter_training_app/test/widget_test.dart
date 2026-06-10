import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_training_app/main.dart';

void main() {
  testWidgets('L’applicazione viene avviata', (WidgetTester tester) async {
    await tester.pumpWidget(const TrackerSpeseApp());

    await tester.pump();

    expect(find.text('Movimenti'), findsOneWidget);
  });
}
