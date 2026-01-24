import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:endless_trivia/features/profile/domain/entities/user_profile.dart';
import 'package:endless_trivia/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final FirebaseFirestore _firestore;

  ProfileRepositoryImpl({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<UserProfile> getProfile(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        final data = doc.data()!;
        return UserProfile(
          userId: userId,
          tokens: data['tokens'] as int? ?? 0,
          favoriteCategories: List<String>.from(
            data['favoriteCategories'] ?? [],
          ),
        );
      } else {
        // Create default profile if not found
        final newProfile = UserProfile(userId: userId);
        await createProfile(userId);
        return newProfile;
      }
    } catch (e) {
      throw Exception('Error fetching profile: $e');
    }
  }

  @override
  Future<void> createProfile(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'favoriteCategories': [],
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Error creating profile: $e');
    }
  }

  @override
  Future<void> consumeTokens(String userId, int numberOfTokens) async {
    try {
      final result = await FirebaseFunctions.instance
          .httpsCallable('consumeTokens')
          .call({'userId': userId, 'numberOfTokens': numberOfTokens});

      final data = result.data as Map<dynamic, dynamic>;
      if (data['status'] == 'insufficient_balance') {
        throw Exception(data['message']);
      }
    } catch (e) {
      throw Exception('Error consuming tokens: $e');
    }
  }

  @override
  Future<void> updateFavoriteCategories(
    String userId,
    List<String> categories,
  ) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'favoriteCategories': categories,
      });
    } catch (e) {
      throw Exception('Error updating categories: $e');
    }
  }
}
