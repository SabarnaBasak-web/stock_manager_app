import 'package:flutter_test/flutter_test.dart';
import 'package:stock_manager/main.dart';

void main() {
  testWidgets('shows stock dashboard', (WidgetTester tester) async {
    await tester.pumpWidget(const StockManagerApp(initialDarkMode: false));

    expect(find.text('My Stock'), findsOneWidget);
    expect(find.text('Products'), findsWidgets);
    expect(find.text('Add'), findsOneWidget);
  });
}
