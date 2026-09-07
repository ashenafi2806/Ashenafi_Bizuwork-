// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:safaricom_flutter_task/core/di/dependency_injection.dart';
import 'package:safaricom_flutter_task/domain/entities/user_entity.dart';
import 'package:safaricom_flutter_task/main.dart';
import 'package:safaricom_flutter_task/presentation/pages/home_page.dart';

void main() {
  testWidgets('welcome page routes to PIN page and validates PIN length', (tester) async {
    await setupInjector();
    await tester.pumpWidget(const SafaricomApp());

    expect(find.text('Sign in'), findsOneWidget);
    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();
    expect(find.text('Enter your M-PESA PIN'), findsOneWidget);

    await tester.tap(find.text('Continue'));
    await tester.pump();
    expect(find.text('Enter your 4-digit M-PESA PIN'), findsOneWidget);
  });

  testWidgets('home page masks and reveals balances', (tester) async {
    const user = UserEntity(
      id: 'USR-10001',
      name: 'John Doe',
      phoneNumber: '251911234567',
      balance: 1250.5,
      currency: 'ETB',
      token: 'token',
    );
    await tester.pumpWidget(const MaterialApp(home: HomePage(user: user)));

    expect(find.text('*****'), findsNWidgets(3));
    expect(find.text('Merchant Payment'), findsOneWidget);
    expect(find.text('Bill Payment'), findsOneWidget);
    expect(find.text('Credit & Saving'), findsOneWidget);
    expect(find.text('Transfer Money'), findsOneWidget);
    expect(find.text('Airtime / Package'), findsOneWidget);
    expect(find.text('More Services'), findsOneWidget);
    expect(find.text('Transactions'), findsOneWidget);
    expect(find.text('Aster Mequanint'), findsOneWidget);
    expect(find.text('Henok Chala'), findsOneWidget);
    expect(find.text('Mekdes Tadesse'), findsOneWidget);
    await tester.tap(find.byTooltip('Show balances'));
    await tester.pump();
    expect(find.text('1,250.50 ETB'), findsNothing);
    expect(find.text('1250.50 ETB'), findsOneWidget);
  });
}
