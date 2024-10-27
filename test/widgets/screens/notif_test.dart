import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:student_management/screens/notif.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:student_management/widgets/edit_noti.dart';
import 'package:student_management/widgets/info_card.dart';
import 'package:student_management/widgets/info_screen.dart';


// Hàm tạo Notif widget được bọc với MaterialApp và Localizations
Widget createNotifScreen() {
  return MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [Locale('en'), Locale('vi')],
    home: Notif(),
  );
}

// Mock classes
class MockFirebaseAuth extends Mock implements FirebaseAuth {
  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return MockUserCredential();
  }
}

class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}

class MockFirebasePlatform extends FirebasePlatform {
  @override
  FirebaseAppPlatform app([String name = defaultFirebaseAppName]) {
    return MockFirebaseAppPlatform();
  }

  @override
  Future<FirebaseAppPlatform> initializeApp({
    String? name,
    FirebaseOptions? options,
  }) async {
    return MockFirebaseAppPlatform();
  }
}

class MockFirebaseAppPlatform extends FirebaseAppPlatform {
  MockFirebaseAppPlatform()
      : super(defaultFirebaseAppName, const FirebaseOptions(
    apiKey: 'mock-api-key',
    appId: 'mock-app-id',
    messagingSenderId: 'mock-sender-id',
    projectId: 'mock-project-id',
  ));

  @override
  String get name => '[DEFAULT]';

  @override
  FirebaseOptions get options => const FirebaseOptions(
    apiKey: 'mock-api-key',
    appId: 'mock-app-id',
    messagingSenderId: 'mock-sender-id',
    projectId: 'mock-project-id',
  );

  @override
  bool get isAutomaticDataCollectionEnabled => true;

  @override
  Future<void> delete() async {}

  @override
  Future<void> setAutomaticDataCollectionEnabled(bool enabled) async {}

  @override
  Future<void> setAutomaticResourceManagementEnabled(bool enabled) async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockFirebaseAuth mockFirebaseAuth;

  // Setup mock handlers for platform channels
  const MethodChannel channel = MethodChannel('plugins.flutter.io/firebase_core');
  const MethodChannel authChannel = MethodChannel('plugins.flutter.io/firebase_auth');

  setUp(() async {
    mockFirebaseAuth = MockFirebaseAuth();

    // Register mock platform
    Firebase.delegatePackingProperty = MockFirebasePlatform();

    // Handle method calls for core
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'Firebase#initializeCore':
          return [
            {
              'name': '[DEFAULT]',
              'options': {
                'apiKey': 'mock-api-key',
                'appId': 'mock-app-id',
                'messagingSenderId': 'mock-sender-id',
                'projectId': 'mock-project-id',
              },
              'pluginConstants': {},
            }
          ];
        case 'Firebase#initializeApp':
          return {
            'name': '[DEFAULT]',
            'options': {
              'apiKey': 'mock-api-key',
              'appId': 'mock-app-id',
              'messagingSenderId': 'mock-sender-id',
              'projectId': 'mock-project-id',
            },
            'pluginConstants': {},
          };
        default:
          return null;
      }
    });

    // Handle method calls for auth
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(authChannel, (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'Auth#initializeAuth':
          return {
            'APP_LANGUAGE_CODE': 'en',
            'APP_CURRENT_USER': null,
          };
        default:
          return null;
      }
    });

    // Initialize Firebase
    await Firebase.initializeApp();
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(authChannel, null);
  });
  group('Notif Widget UI Appearance Tests', () {
    testWidgets('Kiểm tra hiên thị các thành phần UI', (WidgetTester tester) async {
      await tester.pumpWidget(
        createNotifScreen()
      );
      await tester.pump(const Duration(milliseconds: 100));

      final appBarFinder = find.byType(AppBar);
      expect(appBarFinder, findsOneWidget);
      final AppBar appBarWidget = tester.widget(appBarFinder);
      expect(appBarWidget.backgroundColor, Colors.white);

      final appBarTitle = find.text(AppLocalizations.of(tester.element(find.byType(Notif)))!.notif);
      expect(appBarTitle, findsOneWidget);

      final Text titleText = tester.widget<Text>(appBarTitle);
      expect(titleText.style?.fontSize, 20);
      expect(titleText.style?.color, Colors.black);
      expect(titleText.style?.fontWeight, FontWeight.bold);

      // test TextFormField
      final textFieldFinder = find.byType(TextFormField);
      expect(textFieldFinder, findsOneWidget);

      // Access the InputDecoration by creating a Finder for the hint text directly
      final hintTextFinder = find.text(AppLocalizations.of(tester.element(textFieldFinder))!.search);
      expect(hintTextFinder, findsOneWidget);

      // Verify styling
      final Text textWidget = tester.widget(hintTextFinder) as Text;
      expect(textWidget.style?.color, Colors.black26);

      final textField = tester.widget<TextField>(find.descendant(
        of: textFieldFinder,
        matching: find.byType(TextField),
      ));

      // Lấy `decoration` của TextField và kiểm tra các border của nó
      final OutlineInputBorder border = textField.decoration?.border as OutlineInputBorder;
      expect(border.borderRadius, BorderRadius.circular(15));

      final OutlineInputBorder enabledBorder = textField.decoration?.enabledBorder as OutlineInputBorder;
      expect(enabledBorder.borderRadius, BorderRadius.circular(15));

      final OutlineInputBorder focusedBorder = textField.decoration?.focusedBorder as OutlineInputBorder;
      expect(focusedBorder.borderRadius, BorderRadius.circular(15));

      // Test Floating Button
      final floatingActionButtonFinder = find.byType(FloatingActionButton);
      expect(floatingActionButtonFinder, findsOneWidget);
      final FloatingActionButton floatingActionButtonWidget = tester.widget(floatingActionButtonFinder);
      expect(floatingActionButtonWidget.backgroundColor, Colors.teal);
      expect(floatingActionButtonWidget.child, isInstanceOf<Icon>());

      // Kiểm tra biểu tượng của FloatingActionButton
      final addIconFinder = find.byIcon(Icons.add_rounded);
      expect(addIconFinder, findsOneWidget);
      final Icon addIconWidget = tester.widget(addIconFinder);
      expect(addIconWidget.color, Colors.white);

      // Test InfoCard
      final infoCardFinder = find.byType(InfoCard);
      expect(infoCardFinder, findsOneWidget);

      // Check that any text is present within the InfoCard
      final textInsideInfoCardFinder = find.descendant(
        of: infoCardFinder,
        matching: find.byType(Text),
      );
      expect(textInsideInfoCardFinder, findsWidgets);

      // Check for the presence of the icon
      final infoIconFinder = find.byIcon(Icons.notifications_active_outlined);
      expect(infoIconFinder, findsOneWidget);
    });

    testWidgets('Kiểm tra hiển thị màn hình thông tin người dùng khi nhấn _onNotifPressed', (WidgetTester tester) async {
      await tester.pumpWidget(createNotifScreen());
      await tester.pump(const Duration(milliseconds: 100)); // Give time for initial animations

      // Find and tap on InfoCard to open the modal bottom sheet
      final infoCardFinder = find.byType(InfoCard);
      expect(infoCardFinder, findsOneWidget);

      await tester.tap(infoCardFinder);
      await tester.pump(const Duration(milliseconds: 100)); // Allow modal animation to start

      // Verify modal bottom sheet shows InfoScreen
      expect(find.byType(InfoScreen), findsOneWidget);
      expect(find.text(AppLocalizations.of(tester.element(infoCardFinder))!.delete), findsOneWidget);
      expect(find.text(AppLocalizations.of(tester.element(infoCardFinder))!.edit), findsOneWidget);

      // Add additional pump to ensure any remaining animations are handled
      await tester.pump();
    });

    testWidgets('Kiểm tra hiển thị màn hình Tạo thông báo khi nhấn _AddNotif', (WidgetTester tester) async {
      await tester.pumpWidget(
        createNotifScreen()
      );
      await tester.pump(const Duration(milliseconds: 100));

      // Nhấn nút thêm (FloatingActionButton)
      final addButtonFinder = find.byType(FloatingActionButton);
      expect(addButtonFinder, findsOneWidget);

      await tester.tap(addButtonFinder);
      await tester.pump(const Duration(milliseconds: 100));

      // Kiểm tra modal bottom sheet có hiển thị EditNoti hay không
      expect(find.byType(EditNoti), findsOneWidget);
      expect(find.text('OK'), findsOneWidget); // Xác minh nút OK
      expect(find.text('Cancel'), findsOneWidget); // Xác minh nút Cancel
    });

  });
}