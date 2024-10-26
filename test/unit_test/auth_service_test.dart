import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student_management/services/auth_service.dart';  // Đường dẫn đến file AuthService

// Tạo các mock cho FirebaseAuth và FirebaseFirestore
class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class MockUserCredential extends Mock implements UserCredential {}
class MockUser extends Mock implements User {}
class MockDocumentReference extends Mock implements DocumentReference<Map<String, dynamic>> {}

void main() {
  late AuthService authService;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockFirebaseFirestore mockFirebaseFirestore;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockFirebaseFirestore = MockFirebaseFirestore();
    authService = AuthService();
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();
  });

  group('AuthService Sign In', () {
    test('Đăng nhập thành công với email và password đúng', () async {
      // Set up mock trả về UserCredential
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: 'admin2@gmail.com',
        password: 'admin2',
      )).thenAnswer((_) async => mockUserCredential);
      when(mockUserCredential.user).thenReturn(mockUser);

      // Thực hiện đăng nhập
      final user = await authService.signInWithEmailAndPassword(
        'admin2@gmail.com',
        'admin2',
      );

      // Kiểm tra kết quả
      expect(user, mockUser);
    });

    test('Đăng nhập thất bại với thông tin không chính xác', () async {
      // Set up mock trả về lỗi cho trường hợp đăng nhập thất bại
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: 'wrong_email@gmail.com',
        password: 'wrong_password',
      )).thenThrow(FirebaseAuthException(code: 'user-not-found'));

      // Thực hiện đăng nhập và kiểm tra xem có lỗi không
      expect(
            () async => await authService.signInWithEmailAndPassword(
          'wrong_email@gmail.com',
          'wrong_password',
        ),
        throwsA(isA<FirebaseAuthException>()),
      );
    });
  });

  group('AuthService Sign Up', () {
    test('Đăng ký thành công với email, password và role', () async {
      // Set up mock trả về UserCredential
      when(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: 'admin2@gmail.com',
        password: 'admin2',
      )).thenAnswer((_) async => mockUserCredential);
      when(mockUserCredential.user).thenReturn(mockUser);

      // Set up mock cho Firestore
      final mockDocumentReference = MockDocumentReference();
      when(mockFirebaseFirestore.collection('admin').doc('admin2@gmail.com'))
          .thenReturn(mockDocumentReference);

      // Thực hiện đăng ký
      final user = await authService.signUpWithEmailAndPassword(
        'admin2@gmail.com',
        'admin2',
        'admin',
        'admin2',
      );

      // Kiểm tra kết quả
      expect(user, mockUser);
      verify(mockDocumentReference.set({
        'email': 'admin2@gmail.com',
        'role': 'admin',
        'userID': 'admin2',
      })).called(1);
    });

    test('Đăng ký thất bại', () async {
      // Set up mock trả về lỗi cho trường hợp đăng ký thất bại
      when(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: 'invalid_email',
        password: 'short',
      )).thenThrow(FirebaseAuthException(code: 'invalid-email'));

      // Thực hiện đăng ký và kiểm tra xem có lỗi không
      expect(
            () async => await authService.signUpWithEmailAndPassword(
          'invalid_email',
          'short',
          'admin',
          'admin2',
        ),
        throwsA(isA<FirebaseAuthException>()),
      );
    });
  });

  group('AuthService Sign Out', () {
    test('Đăng xuất thành công', () async {
      // Không cần thiết lập mock cho signOut vì nó chỉ gọi phương thức không trả về gì
      await authService.signOut();
      verify(mockFirebaseAuth.signOut()).called(1);
    });

    test('Đăng xuất thất bại', () async {
      // Set up mock trả về lỗi cho trường hợp đăng xuất thất bại
      when(mockFirebaseAuth.signOut()).thenThrow(Exception('Sign out failed'));

      // Thực hiện đăng xuất và kiểm tra xem có lỗi không
      expect(
            () async => await authService.signOut(),
        throwsA(isA<Exception>()),
      );
    });
  });
}
