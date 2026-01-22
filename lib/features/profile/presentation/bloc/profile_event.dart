import 'package:equatable/equatable.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

final class LoadProfile extends ProfileEvent {
  final String userId;
  const LoadProfile(this.userId);

  @override
  List<Object> get props => [userId];
}

final class UpdateFavoriteCategories extends ProfileEvent {
  final String userId;
  final List<String> categories;

  const UpdateFavoriteCategories({required this.userId, required this.categories});

  @override
  List<Object> get props => [userId, categories];
}

final class ConsumeToken extends ProfileEvent {
   final String userId;
   final int currentTokens;

   const ConsumeToken({required this.userId, required this.currentTokens});

   @override
   List<Object> get props => [userId, currentTokens];
}
