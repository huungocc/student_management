// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:intl/intl.dart';
// import 'package:mockito/mockito.dart';
// import 'package:student_management/managers/constants.dart';
// import 'package:student_management/screens/classes.dart';
// import 'package:student_management/screens/classname.dart';
// import 'package:student_management/widgets/add_classes.dart';
// import 'package:student_management/widgets/info_card.dart';
//
// // Mock Navigator observer
// class MockNavigatorObserver extends Mock implements NavigatorObserver {}
//
// void main() {
//   late MockNavigatorObserver mockObserver;
//
//   setUp(() {
//     mockObserver = MockNavigatorObserver();
//   });
//
//   Widget createWidgetUnderTest() {
//     return MaterialApp(
//       localizationsDelegates: const [
//         AppLocalizations.delegate,
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//       ],
//       supportedLocales: const [
//         Locale('en'),
//       ],
//       routes: {
//         '/': (context) => const Classes(),
//         '/classname': (context) => const ClassName(),
//       },
//       navigatorObservers: [mockObserver],
//     );
//   }
//
//   group('Classes Screen Widget Tests', () {
//     testWidgets('Hiển thị chính xác tiêu đề', (WidgetTester tester) async {
//       await tester.pumpWidget(createWidgetUnderTest());
//       await tester.pumpAndSettle();
//
//       expect(find.byType(AppBar), findsOneWidget);
//       expect(find.text('Class'), findsOneWidget);
//     });
//
//     testWidgets('Hiển thị dropdown với các mục', (WidgetTester tester) async {
//       await tester.pumpWidget(createWidgetUnderTest());
//       await tester.pumpAndSettle();
//
//       // Hiển thị dropdown
//       expect(find.byType(DropdownButtonFormField2<String>), findsOneWidget);
//
//       // Tìm và ấn vào dropdown
//       final dropdownFinder = find.byType(DropdownButtonFormField2<String>);
//       await tester.tap(dropdownFinder);
//       await tester.pumpAndSettle();
//
//       // Hiển thị các mục
//       expect(find.text('mon 1'), findsOneWidget);
//       expect(find.text('mon 2'), findsOneWidget);
//       expect(find.text('mon 3'), findsOneWidget);
//     });
//
//     testWidgets('Hiển thị InfoCard', (WidgetTester tester) async {
//       await tester.pumpWidget(createWidgetUnderTest());
//       await tester.pumpAndSettle();
//
//       expect(find.byType(InfoCard), findsOneWidget);
//       expect(find.text('Toan'), findsOneWidget);
//       expect(find.text('Dai Cuong'), findsOneWidget);
//       expect(find.byIcon(Icons.school_outlined), findsOneWidget);
//     });
//
//     testWidgets('Hiển thị FloatingActionButton', (WidgetTester tester) async {
//       await tester.pumpWidget(createWidgetUnderTest());
//       await tester.pumpAndSettle();
//
//       // Kiểm tra FloatingActionButton
//       final fabFinder = find.byType(FloatingActionButton);
//       expect(fabFinder, findsOneWidget);
//
//       final FloatingActionButton fab = tester.widget<FloatingActionButton>(fabFinder);
//       expect(fab.backgroundColor, Colors.orange);
//       expect(fab.elevation, 0);
//       expect(fab.shape, isA<CircleBorder>());
//
//       // Kiểm tra icon
//       final Icon fabIcon = tester.widget<Icon>(
//         find.descendant(
//           of: fabFinder,
//           matching: find.byType(Icon),
//         ),
//       );
//       expect(fabIcon.icon, Icons.add_rounded);
//       expect(fabIcon.color, Colors.white);
//     });
//
//     testWidgets('Hiển thị trang thêm môn học khi nhấn vào button +', (WidgetTester tester) async {
//       await tester.pumpWidget(createWidgetUnderTest());
//
//       // Ấn vào FloatingActionButton
//       await tester.tap(find.byType(FloatingActionButton));
//       await tester.pumpAndSettle();
//
//       // Bottom sheet thêm lớp học hiển thị
//       expect(find.byType(AddClasses), findsOneWidget);
//
//
//       // Kiểm tra TextField tên lớp học
//       final textField = find.byType(TextField);
//       expect(textField, findsOneWidget);
//
//       // Kiểm tra DropdownButtonFormField2
//       final dropdownTinChi = find.byType(DropdownButtonFormField2<String>).first;
//       expect(dropdownTinChi, findsOneWidget);
//
//
//       // Kiểm tra Date Picker Container
//       final datePickerGesture = find.ancestor(
//           of: find.text(DateFormat(FormatDate.dateOfBirth).format(DateTime.now())),
//           matching: find.byType(GestureDetector)
//       );
//       expect(datePickerGesture, findsOneWidget);
//
//       final dateContainer = tester.widget<Container>(
//         find.descendant(
//           of: datePickerGesture,
//           matching: find.byType(Container),
//         ),
//       );
//       expect(dateContainer.constraints?.maxHeight, 53);
//
//       // Kiểm tra text ElevatedButton
//       final ele1 = find.byType(ElevatedButton).first;
//       expect(ele1, findsOneWidget);
//
//       // Kiểm tra DropdownButtonFormField2 cho phòng học
//       final dropdownPhongHoc = find.byType(DropdownButtonFormField2<String>).last;
//       expect(dropdownPhongHoc, findsOneWidget);
//
//       // Kiểm tra text ElevatedButton
//       final ele2 = find.byType(ElevatedButton).last;
//       expect(ele2, findsOneWidget);
//
//       // Nút Cancel
//       final cancelButton = tester.widget<ElevatedButton>(
//           find.widgetWithText(ElevatedButton, 'Cancel'));
//
//       final cancelButtonStyle = cancelButton.style as ButtonStyle;
//
//       expect(
//           cancelButtonStyle.backgroundColor?.resolve({}), Colors.black87);
//       expect(
//           (cancelButtonStyle.fixedSize?.resolve({})! as Size).width, 130.0);
//       expect(
//           (cancelButtonStyle.fixedSize?.resolve({})! as Size).height, 30.0);
//
//       // Nút OK
//       final okButton = tester.widget<ElevatedButton>(
//           find.widgetWithText(ElevatedButton, 'OK')
//       );
//       final okButtonStyle = okButton.style as ButtonStyle;
//
//       expect(
//           okButtonStyle.backgroundColor?.resolve({}), Colors.teal);
//       expect(
//           (okButtonStyle.fixedSize?.resolve({})! as Size).width, 130.0);
//       expect(
//           (okButtonStyle.fixedSize?.resolve({})! as Size).height, 30.0);
//     });
//
//     testWidgets('Điều hướng đến màn hình ClassName khi ấn vào InfoCard và xác minh các thành phần UI',
//             (WidgetTester tester) async {
//       await tester.pumpWidget(createWidgetUnderTest());
//       await tester.pumpAndSettle();
//
//       // Tìm và nhấn vào InfoCard
//       final infoCardFinder = find.byType(InfoCard);
//       expect(infoCardFinder, findsOneWidget);
//       await tester.tap(infoCardFinder);
//       await tester.pumpAndSettle();
//
//       // Màn hình tên lớp học hiển thị
//       expect(find.byType(ClassName), findsOneWidget);
//
//       // Hiển thị tiêu đề
//       expect(find.byType(AppBar), findsOneWidget);
//       expect(find.text('Tên lớp học'), findsOneWidget);
//
//       // Hiển thị TextFormField nội dung lớp học
//       final textFormFieldFinder = find.byType(TextFormField);
//       expect(textFormFieldFinder, findsOneWidget);
//
//       // Xác minh các nút điều hướng phía dưới
//       expect(find.byType(BottomAppBar), findsOneWidget);
//
//       // Tìm và xác minh nút điểm
//       final scoreButtonFinder = find.widgetWithText(ElevatedButton, "Điểm");
//       expect(scoreButtonFinder, findsOneWidget);
//
//       // Kiểm tra thuộc tính của nút điểm
//       final scoreButton = tester.widget<ElevatedButton>(scoreButtonFinder);
//       final scoreButtonStyle = scoreButton.style as ButtonStyle;
//
//       expect(scoreButtonStyle.backgroundColor?.resolve({}), Colors.black87);
//       expect(scoreButtonStyle.elevation?.resolve({}), 0);
//
//       // Kiểm tra kích thước của nút
//       expect((scoreButtonStyle.fixedSize?.resolve({}) as Size).width, 130);
//       expect((scoreButtonStyle.fixedSize?.resolve({}) as Size).height, 30);
//
//       // Kiểm tra text style của nút điểm
//       final scoreText = find.text("Điểm");
//       final scoreTextWidget = tester.widget<Text>(scoreText);
//       expect(scoreTextWidget.style?.color, Colors.white);
//       expect(scoreTextWidget.style?.fontSize, 16);
//
//       // Tìm và xác minh nút edit
//       final context = tester.element(find.byType(ClassName));
//       final editText = AppLocalizations.of(context)!.edit;
//
//       final editButtonFinder = find.widgetWithText(ElevatedButton, editText);
//       expect(editButtonFinder, findsOneWidget);
//
//       // Kiểm tra thuộc tính của nút edit
//       final editButton = tester.widget<ElevatedButton>(editButtonFinder);
//       final editButtonStyle = editButton.style as ButtonStyle;
//
//       expect(editButtonStyle.backgroundColor?.resolve({}), Colors.orange);
//       expect(editButtonStyle.elevation?.resolve({}), 0);
//
//       // Kiểm tra kích thước của nút edit
//       expect((editButtonStyle.fixedSize?.resolve({}) as Size).width, 130);
//       expect((editButtonStyle.fixedSize?.resolve({}) as Size).height, 30);
//
//       // Kiểm tra text style của nút edit
//       final editTextWidget = tester.widget<Text>(find.text(editText));
//       expect(editTextWidget.style?.color, Colors.white);
//       expect(editTextWidget.style?.fontSize, 16);
//
//     });
// });
// }