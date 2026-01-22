import 'package:endless_trivia/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Stream<UserEntity?> get user;
  Future<UserEntity> signUp({required String email, required String password});
  Future<UserEntity> logIn({required String email, required String password});
  Future<void> logOut();
}
