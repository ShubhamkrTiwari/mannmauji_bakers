import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mannmauji_bakers/main.dart';
import 'package:mannmauji_bakers/providers/app_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Mannmauji Bakers app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppState(),
        child: const MannmaujiBakersApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify app title or home elements
    expect(find.text('MANNMAUJI BAKERS'), findsOneWidget);
  });
}
