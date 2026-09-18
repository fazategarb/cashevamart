import 'package:flutter_test/flutter_test.dart';
import 'package:cashevamart/main.dart';

void main() {
  testWidgets('CashevaApp smoke test initializes properly', (WidgetTester tester) async {
    await tester.pumpWidget(const CashevaApp());
    expect(find.byType(CashevaApp), findsOneWidget);
  });
}
