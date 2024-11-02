import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:student_management/managers/manager.dart';
import 'package:student_management/screens/screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:mockito/mockito.dart';

// Import for Firebase mocking
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:student_management/services/service.dart';
import 'package:student_management/widgets/dialog.dart';


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

class MockUserCredential extends Mock implements UserCredential {
  @override
  User? get user => MockUser();
}

class MockUser extends Mock implements User {
  @override
  String get uid => 'mock-uid';

  @override
  String? get email => 'test@example.com';
}

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


// Helper function to wrap widget with MaterialApp and Localizations
Widget createLoginScreen({AuthService? authService}) {
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
    home: Login(authService: authService),
  );
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

  group('Kiểm tra giao diện người dùng đăng nhập', () {
    testWidgets('Màn hình đăng nhập sẽ hiển thị tất cả các thành phần UI cơ bản', (WidgetTester tester) async {
      await tester.pumpWidget(createLoginScreen());
      await tester.pumpAndSettle();

      // 1. Vùng chứa nền có hình ảnh
      final backgroundContainer = tester.widget<Container>(
        find.byWidgetPredicate((widget) =>
        widget is Container &&
            widget.decoration is BoxDecoration &&
            (widget.decoration as BoxDecoration).image?.image is AssetImage),
      );
      expect(backgroundContainer, isNotNull);
      final backgroundDecoration = backgroundContainer.decoration as BoxDecoration;
      expect(
        (backgroundDecoration.image!.image as AssetImage).assetName,
        'assets/utc_background.png',
      );
      expect(backgroundDecoration.image!.fit, BoxFit.cover);

      // 2. Khung đăng nhập
      final loginContainer = tester.widget<Container>(
        find.byWidgetPredicate((widget) =>
        widget is Container &&
            widget.decoration is BoxDecoration &&
            (widget.decoration as BoxDecoration).color == const Color(0xFFFFFFFF)),
      );
      expect(loginContainer, isNotNull);

      // 3.Tiêu đề ứng dụng
      final appTitle = find.byWidgetPredicate((widget) =>
      widget is Text && widget.style?.fontSize == 35);
      expect(appTitle, findsOneWidget);

      final titleWidget = tester.widget<Text>(appTitle);
      expect(titleWidget.style?.color, const Color(0xDD000000)); // Colors.black87
      expect(titleWidget.style?.fontWeight, FontWeight.bold);

      // 4. Biểu tượng ứng dụng
      final appIcon = find.byIcon(Icons.account_balance_rounded);
      expect(appIcon, findsOneWidget);
      final icon = tester.widget<Icon>(appIcon);
      expect(icon.size, 30);

      //5. Kiểm tra xem cả hai trường văn bản có tồn tại không
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.byIcon(Icons.mail_outline_rounded), findsOneWidget);
      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);

      // 7. Nút đăng nhập
      final loginButton = find.byType(ElevatedButton);
      expect(loginButton, findsOneWidget);

      final button = tester.widget<ElevatedButton>(loginButton);
      final buttonStyle = button.style as ButtonStyle;

      expect(
        buttonStyle.backgroundColor?.resolve({}),
        const Color(0xDD000000), // Colors.black87
      );

      final buttonSize = buttonStyle.minimumSize?.resolve({});
      expect(buttonSize?.height, 50);

      final buttonShape = buttonStyle.shape?.resolve({}) as RoundedRectangleBorder;
      expect(buttonShape.borderRadius, BorderRadius.circular(20));

    });
    testWidgets('Trường nhập liệu email phải xử lý đầu vào chính xác', (WidgetTester tester) async {
      await tester.pumpWidget(createLoginScreen());
      await tester.pumpAndSettle();

      // Kiểm tra việc nhập email
      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      expect(find.text('test@example.com'), findsOneWidget);
    });

    testWidgets('Trường nhập liệu password phải xử lý đầu vào chính xác, tính năng bật/tắt hiển thị mật khẩu', (WidgetTester tester) async {
      await tester.pumpWidget(createLoginScreen());
      await tester.pumpAndSettle();

      // Kiểm tra việc nhập password
      await tester.enterText(find.byType(TextFormField).last, 'password123');
      expect(find.text('password123'), findsOneWidget);

      // Tìm và nhấn vào nút chuyển đổi chế độ hiển thị
      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pumpAndSettle();

      // Kiểm tra việc tắt hiển thị
      await tester.enterText(find.byType(TextFormField).last, '***********');
      expect(find.text('***********'), findsOneWidget);
    });
  });

  testWidgets('Kiểm tra hiển thị showDialog khi đăng nhập thành công', (WidgetTester tester) async {
    // Tạo mock cho FirebaseAuth và AuthService
    final mockFirebaseAuth = MockFirebaseAuth();
    final authService = AuthService(auth: mockFirebaseAuth);

    // Khởi tạo widget Login với mock AuthService
    await tester.pumpWidget(createLoginScreen(authService: authService));
    await tester.pumpAndSettle();

    // Nhập email và mật khẩu vào form
    await tester.enterText(find.byType(TextFormField).first, 'admin2@gmail.com');
    await tester.enterText(find.byType(TextFormField).last, 'admin2');

    // Nhấn nút đăng nhập
    await tester.tap(find.byType(ElevatedButton));

    // Chạy lại widget sau khi đăng nhập
    await tester.pump();
    await tester.pump(const Duration(seconds: 5));

    // Kiểm tra xem AlertDialog có được hiển thị hay không
    expect(find.byType(AlertDialog), findsOneWidget);

    // Kiểm tra nội dung của dialog
    expect(find.text('Thông báo'), findsOneWidget);
    expect(find.text('Đăng nhập thành công'), findsOneWidget);

    // // Tìm nút OK trong dialog và kiểm tra xem nó có xuất hiện không
    // final submitButton = find.widgetWithText(TextButton, 'OK');
    // expect(submitButton, findsOneWidget);
    //
    // // Nhấn nút OK để đóng dialog
    // await tester.tap(submitButton);
    // await tester.pumpAndSettle();
    //
    // // Kiểm tra xem dialog đã được đóng hay chưa
    // expect(find.byType(AlertDialog), findsNothing);
  });

}