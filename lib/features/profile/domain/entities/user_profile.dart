import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String userId;
  final int tokens;
  final List<String> favoriteCategories;

  const UserProfile({
    required this.userId,
    this.tokens = 0,
    this.favoriteCategories = const [],
  });

  UserProfile copyWith({
    String? userId,
    int? tokens,
    List<String>? favoriteCategories,
  }) {
    return UserProfile(
      userId: userId ?? this.userId,
      tokens: tokens ?? this.tokens,
      favoriteCategories: favoriteCategories ?? this.favoriteCategories,
    );
  }

  @override
  List<Object> get props => [userId, tokens, favoriteCategories];
}
