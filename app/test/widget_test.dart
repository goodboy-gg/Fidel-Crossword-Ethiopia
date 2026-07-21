import 'package:flutter_test/flutter_test.dart';

import 'package:app/app/fidel_crossword_app.dart';

void main() {

  testWidgets(

    'Fidel Crossword app starts',

    (WidgetTester tester) async {

      await tester.pumpWidget(const FidelCrosswordApp());

      expect(find.byType(FidelCrosswordApp), findsOneWidget);

    },

  );

}

