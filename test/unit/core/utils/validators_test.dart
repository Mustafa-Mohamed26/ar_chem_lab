import 'package:ar_chem_lab/core/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Validators Unit Tests', () {
    group('validateEmail', () {
      test('should return required error if email is null', () {
        final result = Validators.validateEmail(null);
        expect(result, 'this field is required');
      });

      test('should return required error if email is empty', () {
        final result = Validators.validateEmail('');
        expect(result, 'this field is required');
      });

      test('should return required error if email is whitespace only', () {
        final result = Validators.validateEmail('   ');
        expect(result, 'this field is required');
      });

      test('should return invalid email error if email is missing @', () {
        final result = Validators.validateEmail('invalidemail.com');
        expect(result, 'enter valid email');
      });

      test('should return invalid email error if email is missing domain', () {
        final result = Validators.validateEmail('invalid@email');
        expect(result, 'enter valid email');
      });

      test('should return null for valid email address', () {
        final result = Validators.validateEmail('test@example.com');
        expect(result, isNull);
      });
    });

    group('validatePassword', () {
      test('should return required error if password is null', () {
        final result = Validators.validatePassword(null);
        expect(result, 'this field is required');
      });

      test('should return required error if password is empty', () {
        final result = Validators.validatePassword('');
        expect(result, 'this field is required');
      });

      test('should return strong password error if password length < 8', () {
        final result = Validators.validatePassword('a1');
        expect(result, 'strong password please');
      });

      test('should return strong password error if password has no numbers', () {
        final result = Validators.validatePassword('abcdefgh');
        expect(result, 'strong password please');
      });

      test('should return strong password error if password has no letters', () {
        final result = Validators.validatePassword('12345678');
        expect(result, 'strong password please');
      });

      test('should return null for valid password with letters and numbers (>= 8 chars)', () {
        final result = Validators.validatePassword('password123');
        expect(result, isNull);
      });
    });

    group('validateConfirmPassword', () {
      test('should return required error if confirm password is null', () {
        final result = Validators.validateConfirmPassword(null, 'password123');
        expect(result, 'this field is required');
      });

      test('should return required error if confirm password is empty', () {
        final result = Validators.validateConfirmPassword('', 'password123');
        expect(result, 'this field is required');
      });

      test('should return mismatch error if confirm password does not match password', () {
        final result = Validators.validateConfirmPassword('pass123', 'password123');
        expect(result, 'Passwords not matching');
      });

      test('should return null if passwords match', () {
        final result = Validators.validateConfirmPassword('password123', 'password123');
        expect(result, isNull);
      });
    });

    group('validateUsername', () {
      test('should return required error if username is null', () {
        final result = Validators.validateUsername(null);
        expect(result, 'this field is required');
      });

      test('should return required error if username is empty', () {
        final result = Validators.validateUsername('');
        expect(result, 'this field is required');
      });

      test('should return invalid error if username has special characters', () {
        final result = Validators.validateUsername('user!@#');
        expect(result, 'enter valid username');
      });

      test('should return null if username is valid alphanumeric (dots, commas, hyphens allowed)', () {
        final result = Validators.validateUsername('user.name-123,');
        expect(result, isNull);
      });
    });

    group('validateFullName', () {
      test('should return required error if full name is null', () {
        final result = Validators.validateFullName(null);
        expect(result, 'this field is required');
      });

      test('should return required error if full name is empty', () {
        final result = Validators.validateFullName('');
        expect(result, 'this field is required');
      });

      test('should return null if full name is valid', () {
        final result = Validators.validateFullName('John Doe');
        expect(result, isNull);
      });
    });

    group('validatePhoneNumber', () {
      test('should return required error if phone number is null', () {
        final result = Validators.validatePhoneNumber(null);
        expect(result, 'this field is required');
      });

      test('should return invalid characters error if phone number is non-numeric', () {
        final result = Validators.validatePhoneNumber('0123456789a');
        expect(result, 'enter numbers only');
      });

      test('should return length error if phone number is less than 11 digits', () {
        final result = Validators.validatePhoneNumber('012345678');
        expect(result, 'enter value must equal 11 digit');
      });

      test('should return length error if phone number is more than 11 digits', () {
        final result = Validators.validatePhoneNumber('0123456789012');
        expect(result, 'enter value must equal 11 digit');
      });

      test('should return null if phone number is exactly 11 digits and numeric', () {
        final result = Validators.validatePhoneNumber('01020304050');
        expect(result, isNull);
      });
    });
  });
}
