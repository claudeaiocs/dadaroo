import 'package:flutter_test/flutter_test.dart';
import 'package:dadaroo/main.dart';

void main() {
  testWidgets('App renders smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const DadarooApp());
    await tester.pump();

    // Verify the main screen loads with the big button
    expect(find.text("I'VE GOT\nTHE\nFOOD!"), findsOneWidget);
    // Verify bottom navigation is present
    expect(find.text('Dad'), findsOneWidget);
    expect(find.text('Family'), findsOneWidget);
    expect(find.text('Rate Dad'), findsOneWidget);
    expect(find.text('History'), findsOneWidget);
  });
}
