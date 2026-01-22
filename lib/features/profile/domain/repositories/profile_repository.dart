import 'package:endless_trivia/features/profile/domain/entities/user_profile.dart';

abstract class ProfileRepository {
  Future<UserProfile> getProfile(String userId);
  Future<void> createProfile(String userId);
  Future<void> updateTokens(String userId, int newTokens);
  Future<void> updateFavoriteCategories(String userId, List<String> categories);
}
