import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:student_management/managers/routes.dart';
import 'package:student_management/screens/home.dart';
import 'package:student_management/screens/login.dart';
import 'package:student_management/screens/notif.dart';
import 'package:student_management/screens/screen.dart';
import 'package:student_management/services/auth_service.dart';
import 'package:student_management/widgets/schedule_subject.dart';
import 'package:student_management/widgets/setting.dart';
import 'package:student_management/widgets/user_screen.dart';

class MockAuthService extends Mock implements AuthService {}

Widget createHomeScreen() {
  return MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [
      Locale('en'),
      Locale('vi'),
    ],
    onGenerateRoute: (settings) {
      if (settings.name == '/notif') {
        return MaterialPageRoute(builder: (context) => Notif());
      }
      if (settings.name == '/subject') {
        return MaterialPageRoute(builder: (context) => Subject());
      }
      if (settings.name == '/classes') {
        return MaterialPageRoute(builder: (context) => Classes());
      }
      if (settings.name == '/account') {
        return MaterialPageRoute(builder: (context) => Account());
      }
      if (settings.name == '/login') {
        return MaterialPageRoute(builder: (context) => Login());
      }
      return null; // Handle other routes if necessary
    },
    home: Home(),
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
      : super(
            defaultFirebaseAppName,
            const FirebaseOptions(
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
  const MethodChannel channel =
      MethodChannel('plugins.flutter.io/firebase_core');
  const MethodChannel authChannel =
      MethodChannel('plugins.flutter.io/firebase_auth');

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

  group('Home Widget UI Tests', () {
    testWidgets('Kiểm tra giao diện của widget Home',
        (WidgetTester tester) async {
      final size = tester.binding.window.physicalSize;
      await tester.binding.setSurfaceSize(Size(size.width, size.height));

      // Khởi chạy widget Home
      await tester.pumpWidget(createHomeScreen());

      // Kiểm tra sự tồn tại của Scaffold
      expect(find.byType(Scaffold), findsOneWidget);

      // Kiểm tra gradient trong Container tiêu đề
      final Container headerContainer = find
          .descendant(
            of: find.byType(Column).first,
            matching: find.byType(Container),
          )
          .evaluate()
          .first
          .widget as Container;
      final BoxDecoration decoration =
          headerContainer.decoration as BoxDecoration;
      expect(decoration.gradient, isNotNull);
      expect((decoration.gradient as LinearGradient).colors,
          [Colors.blueAccent, Colors.redAccent]);

      // Kiểm tra các icon và vị trí hiển thị của chúng
      expect(find.byIcon(Icons.notifications_active_outlined), findsOneWidget);
      expect(find.byIcon(Icons.schedule_outlined), findsOneWidget);
      expect(find.byIcon(Icons.school_outlined), findsOneWidget);
      expect(find.byIcon(Icons.calendar_month_outlined), findsOneWidget);
      expect(find.byIcon(Icons.people_alt_outlined), findsOneWidget);

      // Kiểm tra BottomAppBar
      final BottomAppBar bottomAppBar =
          tester.widget(find.byType(BottomAppBar));
      expect(bottomAppBar.color, Colors.white70);

      // Kiểm tra vị trí các icon trong BottomAppBar
      expect(find.byIcon(Icons.edit_note_outlined), findsOneWidget);
      expect(find.byIcon(Icons.settings_outlined), findsOneWidget);

      // Kiểm tra văn bản "Welcome" từ AppLocalizations
      final context = tester.element(find.byType(Home));
      final String welcomeText = AppLocalizations.of(context)!.welcome;

      // Tìm văn bản "Welcome" từ AppLocalizations
      expect(find.text(welcomeText), findsOneWidget);

      // Kiểm tra các thuộc tính của văn bản "Welcome"
      final Text welcomeTextWidget = tester.widget(find.text(welcomeText));
      expect(welcomeTextWidget.style?.color, Colors.white);
      expect(welcomeTextWidget.style?.fontSize, 28);
      expect(welcomeTextWidget.style?.fontWeight, FontWeight.bold);

      // Kiểm tra văn bản "N/A" hoặc email hiển thị cho currentUserData
      expect(find.text('N/A'), findsOneWidget);

      // Kiểm tra sự tồn tại của CircleAvatar
      expect(find.byType(CircleAvatar), findsOneWidget);

      // Khôi phục kích thước màn hình sau khi kiểm thử
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('Kiểm tra hiển thị modal khi gọi _onSchedulePressed',
        (WidgetTester tester) async {
      final size = tester.binding.window.physicalSize;
      await tester.binding.setSurfaceSize(Size(size.width, size.height));

      await tester.pumpWidget(createHomeScreen());

      final schedule_button = find.byIcon(Icons.schedule_outlined);
      expect(schedule_button, findsOneWidget);
      // Gọi hàm _onSchedulePressed
      await tester.tap(schedule_button);
      await tester.pump(const Duration(milliseconds: 100));

      // Kiểm tra xem modal có được hiển thị không
      expect(find.byType(ScheduleSubject), findsOneWidget);
    });

    testWidgets('Kiểm tra hiển thị modal khi gọi _onInfoPressed',
        (WidgetTester tester) async {
      final size = tester.binding.window.physicalSize;
      await tester.binding.setSurfaceSize(Size(size.width, size.height));

      await tester.pumpWidget(createHomeScreen());

      final accountButtonFinder = find.byIcon(Icons.edit_note_outlined);
      expect(accountButtonFinder, findsOneWidget);

      await tester.tap(accountButtonFinder);
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(UserScreen), findsOneWidget);
    });


    testWidgets('Chuyển đến màn hình thông báo khi nút thông báo được nhấn', (WidgetTester tester) async {
      final size = tester.binding.window.physicalSize;
      await tester.binding.setSurfaceSize(Size(size.width, size.height));
      await tester.pumpWidget(createHomeScreen());

      final notif_button = find.byIcon(Icons.notifications_active_outlined);
      expect(notif_button, findsOneWidget);

      // Act: Press the notification button to trigger _onNotiPressed
      await tester.tap(notif_button); // Ensure this key is set on the notification button
      await tester.pumpAndSettle();

      // Assert: Verify navigation to NotifScreen
      expect(find.byType(Notif), findsOneWidget);
    });

    testWidgets('Chuyển đến màn hình môn học khi nút môn học được nhấn', (WidgetTester tester) async {
      final size = tester.binding.window.physicalSize;
      await tester.binding.setSurfaceSize(Size(size.width, size.height));
      await tester.pumpWidget(createHomeScreen());

      final subject_button = find.byIcon(Icons.school_outlined);
      expect(subject_button, findsOneWidget);

      // Act: Press the notification button to trigger _onNotiPressed
      await tester.tap(subject_button); // Ensure this key is set on the notification button
      await tester.pumpAndSettle();

      // Assert: Verify navigation to NotifScreen
      expect(find.byType(Subject), findsOneWidget);
    });

    testWidgets('Chuyển đến màn hình lớp học khi nút lớp học được nhấn', (WidgetTester tester) async {
      final size = tester.binding.window.physicalSize;
      await tester.binding.setSurfaceSize(Size(size.width, size.height));
      await tester.pumpWidget(createHomeScreen());

      final classes_button = find.byIcon(Icons.calendar_month_outlined);
      expect(classes_button, findsOneWidget);

      // Act: Press the notification button to trigger _onNotiPressed
      await tester.tap(classes_button); // Ensure this key is set on the notification button
      await tester.pumpAndSettle();

      // Assert: Verify navigation to NotifScreen
      expect(find.byType(Classes), findsOneWidget);
    });

    testWidgets('Chuyển đến màn hình tài khoản khi nút tài khoản được nhấn', (WidgetTester tester) async {
      final size = tester.binding.window.physicalSize;
      await tester.binding.setSurfaceSize(Size(size.width, size.height));
      await tester.pumpWidget(createHomeScreen());

      final account_button = find.byIcon(Icons.people_alt_outlined);
      expect(account_button, findsOneWidget);

      // Act: Press the notification button to trigger _onNotiPressed
      await tester.tap(account_button); // Ensure this key is set on the notification button
      await tester.pumpAndSettle();

      // Assert: Verify navigation to NotifScreen
      expect(find.byType(Account), findsOneWidget);
    });

  });
}
