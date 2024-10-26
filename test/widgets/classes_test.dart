import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:mockito/mockito.dart';
import 'package:student_management/screens/classes.dart';
import 'package:student_management/screens/classname.dart';
import 'package:student_management/widgets/add_classes.dart';
import 'package:student_management/widgets/info_card.dart';

// Mock Navigator observer
class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  late MockNavigatorObserver mockObserver;

  setUp(() {
    mockObserver = MockNavigatorObserver();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
      ],
      routes: {
        '/': (context) => const Classes(),
        '/classname': (context) => const ClassName(),
      },
      navigatorObservers: [mockObserver],
    );
  }

  group('Classes Screen Widget Tests', () {
    testWidgets('Hiển thị chính xác tiêu đề', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Class'), findsOneWidget);
    });

    testWidgets('Hiển thị dropdown với các mục', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Hiển thị dropdown
      expect(find.byType(DropdownButtonFormField2<String>), findsOneWidget);

      // Tìm và ấn vào dropdown
      final dropdownFinder = find.byType(DropdownButtonFormField2<String>);
      await tester.tap(dropdownFinder);
      await tester.pumpAndSettle();

      // Hiển thị các mục
      expect(find.text('mon 1'), findsOneWidget);
      expect(find.text('mon 2'), findsOneWidget);
      expect(find.text('mon 3'), findsOneWidget);
    });

    testWidgets('Hiển thị InfoCard', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(InfoCard), findsOneWidget);
      expect(find.text('Toan'), findsOneWidget);
      expect(find.text('Dai Cuong'), findsOneWidget);
      expect(find.byIcon(Icons.school_outlined), findsOneWidget);
    });

    testWidgets('Hiển thị FloatingActionButton', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Kiểm tra FloatingActionButton
      final fabFinder = find.byType(FloatingActionButton);
      expect(fabFinder, findsOneWidget);

      final FloatingActionButton fab = tester.widget<FloatingActionButton>(fabFinder);
      expect(fab.backgroundColor, Colors.orange);
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
    });

    testWidgets('Hiển thị trang thêm môn học khi nhấn vào button +', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Ấn vào FloatingActionButton
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Bottom sheet thêm lớp học hiển thị
      expect(find.byType(AddClasses), findsOneWidget);
    });

    testWidgets('Điều hướng đến màn hình ClassName khi ấn vào InfoCard và xác minh các thành phần UI',
            (WidgetTester tester) async {
          await tester.pumpWidget(createWidgetUnderTest());
          await tester.pumpAndSettle();

          // Tìm và nhấn vào InfoCard
          final infoCardFinder = find.byType(InfoCard);
          expect(infoCardFinder, findsOneWidget);
          await tester.tap(infoCardFinder);
          await tester.pumpAndSettle();

          // Màn hình tên lớp học hiển thị
          expect(find.byType(ClassName), findsOneWidget);

          // Hiển thị tiêu đề
          expect(find.byType(AppBar), findsOneWidget);
          expect(find.text('Tên lớp học'), findsOneWidget);

          // Hiển thị TextFormField nội dung lớp học
          final textFormFieldFinder = find.byType(TextFormField);
          expect(textFormFieldFinder, findsOneWidget);


          // Xác minh các nút điều hướng phía dưới
          expect(find.byType(BottomAppBar), findsOneWidget);

          // Tìm và xác minh nút điểm
          final scoreButtonFinder = find.widgetWithText(ElevatedButton, "Điểm");
          expect(scoreButtonFinder, findsOneWidget);

          // Tìm và xác minh nút edit
          final editButtonFinder = find.byType(ElevatedButton).last;
          expect(editButtonFinder, findsOneWidget);
        });
  });
}