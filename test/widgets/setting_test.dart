import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:student_management/managers/manager.dart';
import 'package:student_management/widgets/setting.dart';

void main() {
  group('SettingScreen Tests', () {
    late Widget testWidget;
    late LocaleProvider mockLocaleProvider;

    setUp(() {
      mockLocaleProvider = LocaleProvider();

      testWidget = MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            child: ChangeNotifierProvider<LocaleProvider>.value(
              value: mockLocaleProvider,
              child: SettingScreen(
                onLogOut: () {},
              ),
            ),
          ),
        ),
      );
    });
    testWidgets('Màn hình setting hiển thị các thành phần UI cơ bản',
        (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      //Xác minh trang trí thả xuống
      expect(find.byType(DropdownButtonFormField2<String>), findsOneWidget);

      final dropdownField = tester.widget<DropdownButtonFormField2<String>>(
          find.byType(DropdownButtonFormField2<String>));
      final decoration = dropdownField.decoration as InputDecoration;
      expect(decoration.border, isInstanceOf<OutlineInputBorder>());
      expect((decoration.border as OutlineInputBorder).borderRadius,
          BorderRadius.circular(20));

      // Tìm nút đăng xuất
      final logoutButton = find.byType(ElevatedButton);
      expect(logoutButton, findsOneWidget);

      // Xác minh kiểu dáng nút
      final button = tester.widget<ElevatedButton>(logoutButton);
      final buttonStyle = button.style as ButtonStyle;

      // Kiểm tra màu nền
      final backgroundColor = buttonStyle.backgroundColor?.resolve({});
      expect(backgroundColor, Colors.red[600]);

      // Kiểm tra hình dạng nút
      final shape = buttonStyle.shape?.resolve({}) as RoundedRectangleBorder;
      expect(shape.borderRadius, BorderRadius.circular(20));

      // Kiểm tra độ cao
      final elevation = buttonStyle.elevation?.resolve({});
      expect(elevation, 0);

      // Kiểm tra kích thước tối thiểu
      final minimumSize = buttonStyle.minimumSize?.resolve({});
      expect(minimumSize?.height, 60);
    });
    testWidgets('Kiểm tra các ngôn ngữ có trong dropdown không',
        (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      //Kiểm tra hành động ấn để thả xống
      await tester.tap(find.byType(DropdownButtonFormField2<String>));
      await tester.pumpAndSettle();

      //Tìm danh sách thả xuống
      final dropdownList = find.byType(Scrollable).last;

      //Xác minh cả hai tùy chọn đều có trong danh sách thả xuống
      final findEnglish = find.descendant(
        of: dropdownList,
        matching: find.text('English'),
      );

      final findVietnamese = find.descendant(
        of: dropdownList,
        matching: find.text('Tiếng Việt'),
      );

      //Xác minh mỗi tùy chọn tồn tại chính xác một lần trong danh sách thả xuống
      expect(findEnglish.evaluate().length, 1);
      expect(findVietnamese.evaluate().length, 1);
    });
  });
}
