import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/main.dart';

void main() {
  testWidgets('News App loads', (WidgetTester tester) async {
    await tester.pumpWidget(const NewsApp());

    expect(find.text('News App'), findsOneWidget);
  });
}