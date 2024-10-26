// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:student_management/screens/subject.dart';
// import 'package:student_management/widgets/add_subject.dart';
// import 'package:student_management/widgets/info_card.dart';
// import 'package:student_management/widgets/info_screen.dart';
//
// void main() {
//   Widget createWidgetUnderTest() {
//     return MaterialApp(
//       localizationsDelegates: const [
//         AppLocalizations.delegate,
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//       ],
//       supportedLocales: const [
//         Locale('en'),
//         Locale('vi'),
//       ],
//       home: const Subject(),
//     );
//   }
//
//   group('Subject Widget Tests', () {
//     testWidgets('Hiển thị đầy đủ các thành phần UI',
//             (WidgetTester tester) async {
//           await tester.pumpWidget(createWidgetUnderTest());
//
//           // Kiểm tra title của AppBar
//           final Text titleWidget = tester.widget<Text>(
//             find.descendant(
//               of: find.byType(AppBar),
//               matching: find.byType(Text),
//             ),
//           );
//           expect(titleWidget.style?.fontSize, 20);
//           expect(titleWidget.style?.color, Colors.black);
//           expect(titleWidget.style?.fontWeight, FontWeight.bold);
//
//           // Kiểm tra Search TextField
//           final textFieldFinder = find.byType(TextFormField);
//           expect(textFieldFinder, findsOneWidget);
//
//
//           // Kiểm tra icon tìm kiếm trong TextField
//           final searchIconFinder = find.byIcon(Icons.search_rounded);
//           expect(searchIconFinder, findsOneWidget);
//
//           // Kiểm tra FloatingActionButton
//           final fabFinder = find.byType(FloatingActionButton);
//           expect(fabFinder, findsOneWidget);
//
//           final FloatingActionButton fab = tester.widget<FloatingActionButton>(fabFinder);
//           expect(fab.backgroundColor, Colors.red);
//           expect(fab.elevation, 0);
//           expect(fab.shape, isA<CircleBorder>());
//
//           // Kiểm tra icon
//           final Icon fabIcon = tester.widget<Icon>(
//             find.descendant(
//               of: fabFinder,
//               matching: find.byType(Icon),
//             ),
//           );
//           expect(fabIcon.icon, Icons.add_rounded);
//           expect(fabIcon.color, Colors.white);
//
//           // Kiểm tra InfoCard
//           final infoCardFinder = find.byType(InfoCard);
//           expect(infoCardFinder, findsOneWidget);
//
//           // Kiểm tra nội dung text trong InfoCard
//           expect(find.text('Toan'), findsOneWidget);
//           expect(find.text('Dai Cuong'), findsOneWidget);
//
//           // Kiểm tra icon trong InfoCard
//           final schoolIconFinder = find.byIcon(Icons.school_outlined);
//           expect(schoolIconFinder, findsOneWidget);
//     });
//     testWidgets('Hiển thị bottom sheet khi chạm vào InfoCard',
//             (WidgetTester tester) async {
//           await tester.pumpWidget(createWidgetUnderTest());
//
//           // Ấn vào InfoCard
//           await tester.tap(find.byType(InfoCard));
//           await tester.pumpAndSettle();
//
//           // Bottom sheet sẽ hiển thị
//           expect(find.byType(InfoScreen), findsOneWidget);
//
//           //Delete
//           final deleteButtonFinder = find.widgetWithText(ElevatedButton, 'Delete');
//           expect(deleteButtonFinder, findsOneWidget);
//
//           final deleteButton = tester.widget<ElevatedButton>(deleteButtonFinder);
//           final deleteButtonStyle = deleteButton.style as ButtonStyle;
//
//           // Kiểm tra style của nút Delete
//           expect(deleteButtonStyle.backgroundColor?.resolve({}), Colors.red[600]);
//           expect(deleteButtonStyle.elevation?.resolve({}), 0);
//
//           final deleteShape = deleteButtonStyle.shape?.resolve({}) as RoundedRectangleBorder;
//           expect(deleteShape.borderRadius, BorderRadius.circular(15));
//
//           // Kiểm tra icon Delete
//           final deleteIconFinder = find.descendant(
//             of: deleteButtonFinder,
//             matching: find.byIcon(Icons.delete_outline_outlined),
//           );
//           expect(deleteIconFinder, findsOneWidget);
//
//           final deleteIcon = tester.widget<Icon>(deleteIconFinder);
//           expect(deleteIcon.color, Colors.white);
//
//
//           // Edit
//           final editButtonFinder = find.widgetWithText(ElevatedButton, 'Edit');
//           expect(editButtonFinder, findsOneWidget);
//
//           final editButton = tester.widget<ElevatedButton>(editButtonFinder);
//           final editButtonStyle = editButton.style as ButtonStyle;
//
//           // Kiểm tra style của nút Edit
//           expect(editButtonStyle.backgroundColor?.resolve({}), Colors.black87);
//           expect(editButtonStyle.elevation?.resolve({}), 0);
//
//           final editShape = editButtonStyle.shape?.resolve({}) as RoundedRectangleBorder;
//           expect(editShape.borderRadius, BorderRadius.circular(15));
//
//           // Kiểm tra icon Edit
//           final editIconFinder = find.descendant(
//             of: editButtonFinder,
//             matching: find.byIcon(Icons.edit_outlined),
//           );
//           expect(editIconFinder, findsOneWidget);
//
//           final editIcon = tester.widget<Icon>(editIconFinder);
//           expect(editIcon.color, Colors.white);
//     });
//
//     testWidgets('Hiển thị trang thêm môn học khi nhấn vào button +',
//             (WidgetTester tester) async {
//           await tester.pumpWidget(createWidgetUnderTest());
//
//           // Ấn vào FloatingActionButton
//           await tester.tap(find.byType(FloatingActionButton));
//           await tester.pumpAndSettle();
//
//           // Bottom sheet thêm môn học hiển thị
//           expect(find.byType(AddSubject), findsOneWidget);
//
//
//           // Kiểm tra TextField tên môn
//           final textField = find.byType(TextField).first;
//           expect(textField, findsOneWidget);
//
//           // Kiểm tra DropdownButtonFormField2 category
//           final dropdownSubjectCategory = find.byType(DropdownButtonFormField2<String>).first;
//           expect(dropdownSubjectCategory, findsOneWidget);
//
//           // Kiểm tra DropdownButtonFormField2 tin chỉ
//           final dropdownTinChi = find.byType(DropdownButtonFormField2<String>).last;
//           expect(dropdownTinChi, findsOneWidget);
//
//           // Kiểm tra Container
//           final containers = find.byType(Container);
//           expect(containers, findsWidgets);
//
//           // Kiểm tra TextField số môn học
//           final textField2 = find.byType(TextField).last;
//           expect(textField2, findsOneWidget);
//
//
//
//           // Nút cancel
//           final cancelButton = tester.widget<ElevatedButton>(
//               find.widgetWithText(ElevatedButton, 'Cancel'));
//
//           final cancelButtonStyle = cancelButton.style as ButtonStyle;
//
//           expect(
//               cancelButtonStyle.backgroundColor?.resolve({}), Colors.black87);
//           expect(
//               (cancelButtonStyle.fixedSize?.resolve({})! as Size).width, 130.0);
//           expect(
//               (cancelButtonStyle.fixedSize?.resolve({})! as Size).height, 30.0);
//           expect(
//               (cancelButtonStyle.elevation?.resolve({}) ?? 0), 0);
//
//           // Nút Ok
//           final okButton = tester.widget<ElevatedButton>(
//               find.widgetWithText(ElevatedButton, 'OK')
//           );
//           final okButtonStyle = okButton.style as ButtonStyle;
//
//           expect(
//               okButtonStyle.backgroundColor?.resolve({}), Colors.teal);
//           expect(
//               (okButtonStyle.fixedSize?.resolve({})! as Size).width, 130.0);
//           expect(
//               (okButtonStyle.fixedSize?.resolve({})! as Size).height, 30.0);
//     });
//   });
// }