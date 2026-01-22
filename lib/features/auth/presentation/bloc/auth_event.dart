import 'package:equatable/equatable.dart';
import 'package:endless_trivia/features/auth/domain/entities/user_entity.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

final class AuthSubscriptionRequested extends AuthEvent {}

final class AuthLogoutRequested extends AuthEvent {}

final class AuthUserChanged extends AuthEvent {
  final UserEntity? user;

  const AuthUserChanged(this.user);

  @override
  List<Object> get props => [user ?? 'null'];
}
