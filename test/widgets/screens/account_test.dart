import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:student_management/managers/constants.dart';
import 'package:student_management/managers/font.dart';
import 'package:student_management/screens/account.dart';
import 'package:student_management/services/account_service.dart';
import 'package:student_management/widgets/add_account.dart';
import 'package:student_management/widgets/info_card.dart';
import 'package:student_management/widgets/info_screen.dart';

// Helper function to create the Account screen wrapped in MaterialApp and Localizations
Widget createAccountScreen() {
  return MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [Locale('en'), Locale('vi')],
    home: const Account(),
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

Widget createAccountScreenWithMockData(
    List<Map<String, dynamic>> mockAdminData) {
  return MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [Locale('en'), Locale('vi')],
    home: Account(),
  );
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

  group('Account Widget UI Appearance Tests', () {

    testWidgets('Kiểm tra hiển thị các thành phần UI',
            (WidgetTester tester) async {
      await tester.pumpWidget(createAccountScreen());

      final appBarFinder = find.byType(AppBar);
      expect(appBarFinder, findsOneWidget);

      expect(
        (tester.widget<AppBar>(appBarFinder).backgroundColor),
        Colors.white,
        reason: 'AppBar background should be white',
      );

      // Check AppBar title's text style
      final appBarTitle = find.text(
          AppLocalizations.of(tester.element(find.byType(Account)))!.account);
      expect(appBarTitle, findsOneWidget);
      final appBarTitleText = tester.widget<Text>(appBarTitle);
      expect(appBarTitleText.style?.fontWeight, FontWeight.bold);
      expect(appBarTitleText.style?.fontSize, 20);
      expect(appBarTitleText.style?.color, Colors.black);

      // Verify the presence and properties of TextFormField (Search)
      final searchField = find.byType(TextFormField);
      expect(searchField, findsOneWidget);

      // Find the TextFormField
      final textField = tester.widget<TextField>(find.descendant(
        of: searchField,
        matching: find.byType(TextField),
      ));

      expect(textField.decoration!.hintText,
          AppLocalizations.of(tester.element(searchField))!.search);
      expect(textField.decoration!.hintStyle!.color, Colors.black26);

      final textFieldStyle = textField.style!;
      expect(textFieldStyle.fontSize, 16);
      expect(textFieldStyle.color, Colors.black87);
      expect(textFieldStyle.fontFamily , Fonts.display_font);

      // Check the TextFormField's border radius and colors
      final OutlineInputBorder border =
          textField.decoration?.border as OutlineInputBorder;
      expect(border.borderRadius, BorderRadius.circular(15));

      final OutlineInputBorder enabledBorder =
          textField.decoration?.enabledBorder as OutlineInputBorder;
      expect(enabledBorder.borderRadius, BorderRadius.circular(15));

      final OutlineInputBorder focusedBorder =
          textField.decoration?.focusedBorder as OutlineInputBorder;
      expect(focusedBorder.borderRadius, BorderRadius.circular(15));

      // Verify ExpansionTile widgets for Admin, Teacher, and Student
      final expansionTiles = find.byType(ExpansionTile);
      expect(expansionTiles, findsNWidgets(3));

      // Check individual ExpansionTile titles and styles
      await tester.tap(find.text('Admin'));
      await tester.pumpAndSettle();
      expect(
        tester.widget<Text>(find.text('Admin')).style?.fontWeight,
        FontWeight.bold,
      );
      expect(
        tester.widget<Text>(find.text('Admin')).style?.fontSize,
        16,
      );
      await tester.pumpAndSettle();
      expect(find.byType(ListView), findsWidgets);

      await tester.tap(find.text('Teacher'));
      await tester.pumpAndSettle();
      expect(
        tester.widget<Text>(find.text('Teacher')).style?.fontWeight,
        FontWeight.bold,
      );
      await tester.pumpAndSettle();
      expect(find.byType(ListView), findsWidgets);

      await tester.tap(find.text('Student'));
      await tester.pumpAndSettle();
      expect(
        tester.widget<Text>(find.text('Student')).style?.fontWeight,
        FontWeight.bold,
      );
      await tester.pumpAndSettle();
      expect(find.byType(ListView), findsWidgets);

      // Verify presence and properties of FloatingActionButton (FAB)
      final fab = find.byType(FloatingActionButton);
      expect(fab, findsOneWidget);
      expect(
        tester.widget<FloatingActionButton>(fab).backgroundColor,
        Colors.indigo,
      );
      expect(
        (tester.widget<FloatingActionButton>(fab).shape as CircleBorder),
        isA<CircleBorder>(),
        reason: 'FloatingActionButton should have a CircleBorder',
      );
      expect(find.byIcon(Icons.add_rounded), findsOneWidget);
    });

    testWidgets('Kiểm tra hiển thị màn hình thêm tài khoản khi bấm AddAccount',
        (WidgetTester tester) async {
      await tester.pumpWidget(createAccountScreen());

      final fab = find.byType(FloatingActionButton);
      // Nhấn FloatingActionButton để kiểm tra nếu `AddAccount` modal được mở
      await tester.tap(fab);
      await tester.pumpAndSettle();

      expect(find.byType(AddAccount), findsOneWidget);
    });

  });
}

