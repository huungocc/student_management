import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:student_management/screens/subject.dart';
import 'package:student_management/widgets/add_subject.dart';
import 'package:student_management/widgets/info_card.dart';
import 'package:student_management/widgets/info_screen.dart';

void main() {
  Widget createWidgetUnderTest() {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('vi'),
      ],
      home: const Subject(),
    );
  }

  group('Subject Widget Tests', () {
    testWidgets('Hiển thị đầy đủ các thành phần UI',
            (WidgetTester tester) async {
          await tester.pumpWidget(createWidgetUnderTest());

          // Kiểm tra AppBar
          final appBarFinder = find.byType(AppBar);
          expect(appBarFinder, findsOneWidget);

          final PreferredSize preferredSize = tester.widget(find.byType(PreferredSize));
          expect(preferredSize.preferredSize.height, 70.0);

          final AppBar appBar = tester.widget<AppBar>(
            find.descendant(
              of: find.byType(PreferredSize),
              matching: find.byType(AppBar),
            ),
          );
          expect(appBar.backgroundColor, Colors.white);
          expect(appBar.centerTitle, true);

          // Kiểm tra title của AppBar
          final Text titleWidget = tester.widget<Text>(
            find.descendant(
              of: find.byType(AppBar),
              matching: find.byType(Text),
            ),
          );
          expect(titleWidget.style?.fontSize, 20);
          expect(titleWidget.style?.color, Colors.black);
          expect(titleWidget.style?.fontWeight, FontWeight.bold);

          // Kiểm tra Search TextField
          final textFieldFinder = find.byType(TextFormField);
          expect(textFieldFinder, findsOneWidget);


          // Kiểm tra icon tìm kiếm trong TextField
          final searchIconFinder = find.byIcon(Icons.search_rounded);
          expect(searchIconFinder, findsOneWidget);

          // Kiểm tra FloatingActionButton
          final fabFinder = find.byType(FloatingActionButton);
          expect(fabFinder, findsOneWidget);

          final FloatingActionButton fab = tester.widget<FloatingActionButton>(fabFinder);
          expect(fab.backgroundColor, Colors.red);
          expect(fab.elevation, 0);
          expect(fab.shape, isA<CircleBorder>());

          // Kiểm tra icon
          final Icon fabIcon = tester.widget<Icon>(
            find.descendant(
              of: fabFinder,
              matching: find.byType(Icon),
            ),
          );
          expect(fabIcon.icon, Icons.add_rounded);
          expect(fabIcon.color, Colors.white);

          // Kiểm tra InfoCard
          final infoCardFinder = find.byType(InfoCard);
          expect(infoCardFinder, findsOneWidget);

          // Kiểm tra nội dung text trong InfoCard
          expect(find.text('Toan'), findsOneWidget);
          expect(find.text('Dai Cuong'), findsOneWidget);

          // Kiểm tra icon trong InfoCard
          final schoolIconFinder = find.byIcon(Icons.school_outlined);
          expect(schoolIconFinder, findsOneWidget);
    });
    testWidgets('Hiển thị bottom sheet khi chạm vào InfoCard',
            (WidgetTester tester) async {
          await tester.pumpWidget(createWidgetUnderTest());

          // Ấn vào InfoCard
          await tester.tap(find.byType(InfoCard));
          await tester.pumpAndSettle();

          // Bottom sheet sẽ hiển thị
          expect(find.byType(InfoScreen), findsOneWidget);
    });

    testWidgets('Hiển thị trang thêm môn học khi nhấn vào button +',
            (WidgetTester tester) async {
          await tester.pumpWidget(createWidgetUnderTest());

          // Ấn vào FloatingActionButton
          await tester.tap(find.byType(FloatingActionButton));
          await tester.pumpAndSettle();

          // Bottom sheet thêm môn học hiển thị
          expect(find.byType(AddSubject), findsOneWidget);
    });
  });
}