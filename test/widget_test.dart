import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arcana_app/app.dart';

void main() {
  testWidgets('Arcana app arranca correctamente', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: ArcanaApp()),
    );

    // Verifica que el onboarding se muestra
    expect(find.text('¿Quién eres, aventurero?'), findsOneWidget);
  });
}
