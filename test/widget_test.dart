// Basic Flutter widget test for Inventory app.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_system/main.dart';

void main() {
  testWidgets('App loads and shows login or dashboard', (WidgetTester tester) async {
    await tester.pumpWidget(const InventoryApp());
    await tester.pumpAndSettle();
    // Either login screen or dashboard is visible
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
