import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:endless_trivia/core/services/device_info_service.dart';
import 'package:endless_trivia/features/profile/domain/entities/user_profile.dart';
import 'package:endless_trivia/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final FirebaseFirestore _firestore;
  final DeviceInfoService _deviceInfoService;

  ProfileRepositoryImpl({
    FirebaseFirestore? firestore,
    required DeviceInfoService deviceInfoService,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _deviceInfoService = deviceInfoService;

  @override
  Future<UserProfile> getProfile(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return _mapSnapshotToUserProfile(doc);
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
  Stream<UserProfile> getProfileStream(String userId) {
    return _firestore.collection('users').doc(userId).snapshots().map((doc) {
      if (!doc.exists) {
        throw Exception(
          'Error fetching profile stream: Document does not exist',
        );
      }
      return _mapSnapshotToUserProfile(doc);
    });
  }

  UserProfile _mapSnapshotToUserProfile(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return UserProfile(
      userId: doc.id,
      tokens: data['tokens'] as int? ?? 0,
      favoriteCategories: List<String>.from(data['favoriteCategories'] ?? []),
    );
  }

  @override
  Future<void> createProfile(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'favoriteCategories': [],
      }, SetOptions(merge: true));

      // Grant initial tokens if on iOS or Android
      final hardwareId = await _deviceInfoService.getHardwareId();
      if (hardwareId != null) {
        try {
          await FirebaseFunctions.instance
              .httpsCallable('grantInitialTokens')
              .call({'deviceId': hardwareId});
        } catch (e) {
          // Log error but don't fail profile creation
          // This might happen if tokens were already claimed for this device
          // TODO: Add warning log here
          print('Error granting initial tokens: $e');
        }
      }
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
