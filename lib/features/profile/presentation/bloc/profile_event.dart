import 'package:equatable/equatable.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

final class LoadProfile extends ProfileEvent {
  final String userId;
  final bool showLoading;

  const LoadProfile(this.userId, {this.showLoading = true});

  @override
  List<Object> get props => [userId, showLoading];
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
   final int amount;

   const ConsumeToken({
     required this.userId,
     required this.currentTokens,
     required this.amount,
   });

   @override
   List<Object> get props => [userId, currentTokens, amount];
}
