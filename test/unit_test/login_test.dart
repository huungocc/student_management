import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:student_management/managers/validator.dart';
import 'package:student_management/screens/login.dart';
import 'package:student_management/services/auth_service.dart';

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
}

class MockAuthService extends Mock implements AuthService {}

// Helper function để wrap widget với MaterialApp và Localizations
Widget createTestWidget() {
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
    home: const Login(),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAuthService mockAuthService;
  const MethodChannel channel = MethodChannel('plugins.flutter.io/firebase_core');
  const MethodChannel authChannel = MethodChannel('plugins.flutter.io/firebase_auth');

  setUp(() async {
    mockAuthService = MockAuthService();

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

  group('Kiểm tra chức năng login', ()
  {
    test('Xử lý các định dạng email khác nhau', () {
      expect(Validator.validateEmail(''), false);
      expect(Validator.validateEmail('test'), false);
      expect(Validator.validateEmail('test@'), false);
      expect(Validator.validateEmail('test@gmail'), false);
      expect(Validator.validateEmail('test@gmail.'), false);
      expect(Validator.validateEmail('test@gmail.com'), true);
      expect(Validator.validateEmail('test.name@gmail.com'), true);
      expect(Validator.validateEmail('test+label@gmail.com'), true);
    });

    test('validatePassword should enforce password rules', () {
      expect(Validator.validatePassword(''), false);
      expect(Validator.validatePassword('12345'), false);
      expect(Validator.validatePassword('123456'), true);
      expect(Validator.validatePassword('abcdef'), true);
      expect(Validator.validatePassword('abc123'), true);
      expect(Validator.validatePassword('abc123!@#'), true);
    });
  });
}