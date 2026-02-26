import 'package:equatable/equatable.dart';
import 'package:endless_trivia/features/profile/domain/entities/user_profile.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileLoaded extends ProfileState {
  final UserProfile profile;

  const ProfileLoaded(this.profile);

  @override
  List<Object?> get props => [profile];
}

final class ProfileError extends ProfileState {
  final String message;
  final String userId;

  const ProfileError(this.message, this.userId);

  @override
  List<Object?> get props => [message, userId];
}
