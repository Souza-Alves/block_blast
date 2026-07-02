import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:block_blast/main.dart';

void main() {
  testWidgets('App starts without crashing', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const BlockBlastApp());
    expect(find.text('BLOCK BLAST'), findsOneWidget);
  });
}
