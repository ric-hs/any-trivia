import 'package:endless_trivia/features/profile/domain/entities/user_profile.dart';

abstract class ProfileRepository {
  Future<UserProfile> getProfile(String userId);
  Stream<UserProfile> getProfileStream(String userId);
  Future<void> createProfile(String userId);
  Future<void> consumeTokens(String userId, int numberOfTokens);
  Future<void> updateFavoriteCategories(String userId, List<String> categories);
}
