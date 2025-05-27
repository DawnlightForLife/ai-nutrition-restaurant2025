import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ai_nutrition_restaurant/domain/user/entities/user.dart';
import 'package:ai_nutrition_restaurant/domain/user/value_objects/user_value_objects.dart';
import 'package:ai_nutrition_restaurant/application/facades/user_facade.dart';
import '../../fixtures/mock_generator.dart';

/// Test suite for User module
class UserTestSuite {
  static void runAll() {
    group('User Module Tests', () {
      setUp(() {
        MockGenerator.resetIdCounter();
      });
      
      group('Entity Tests', () {
        test('User entity should be created with valid data', () {
          final user = MockGenerator.generateUser();
          
          expect(user.id.toString(), isNotEmpty);
          expect(user.nickname.toString(), isNotEmpty);
          expect(user.email.toString(), contains('@'));
          expect(user.role, isA<UserRole>());
          expect(user.isActive, isTrue);
        });
        
        test('User entity should validate email format', () {
          expect(
            () => Email('invalid-email'),
            throwsA(isA<ArgumentError>()),
          );
        });
        
        test('User entity should validate phone number format', () {
          expect(
            () => Phone('123'),
            throwsA(isA<ArgumentError>()),
          );
        });
      });
      
      group('Use Case Tests', () {
        // Add use case tests here
      });
      
      group('Facade Tests', () {
        // Add facade tests here
      });
      
      group('Repository Tests', () {
        // Add repository tests here
      });
    });
  }
}