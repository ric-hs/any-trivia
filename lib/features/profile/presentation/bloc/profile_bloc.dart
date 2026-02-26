import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:endless_trivia/features/profile/domain/entities/user_profile.dart';
import 'package:endless_trivia/features/profile/domain/repositories/profile_repository.dart';
import 'package:endless_trivia/features/profile/presentation/bloc/profile_event.dart';
import 'package:endless_trivia/features/profile/presentation/bloc/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _profileRepository;
  StreamSubscription<UserProfile>? _profileSubscription;

  ProfileBloc({required ProfileRepository profileRepository}) 
      : _profileRepository = profileRepository, 
        super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateFavoriteCategories>(_onUpdateFavorites);
    on<ProfileUpdated>(_onProfileUpdated);
  }

  Future<void> _onLoadProfile(LoadProfile event, Emitter<ProfileState> emit) async {
    if (event.showLoading) {
      emit(ProfileLoading());
    }
    
    try {
      // Ensure profile exists (creation happens here if needed)
      await _profileRepository.getProfile(event.userId);
    } catch (e) {
      emit(ProfileError(e.toString(), event.userId));
      return;
    }

    await _profileSubscription?.cancel();
    
    _profileSubscription = _profileRepository
        .getProfileStream(event.userId)
        .listen(
          (profile) => add(ProfileUpdated(profile)),
          onError: (error) => emit(ProfileError(error.toString(), event.userId)),
        );
  }

  void _onProfileUpdated(ProfileUpdated event, Emitter<ProfileState> emit) {
    emit(ProfileLoaded(event.profile));
  }

  // Internal event for stream updates
  // Place this inside or outside the class depending on visibility preference
  // If inside, we need to register it in the constructor or dynamically.
  // Actually, better to register it in the constructor.

  Future<void> _onUpdateFavorites(UpdateFavoriteCategories event, Emitter<ProfileState> emit) async {
    final currentState = state;
    if (currentState is ProfileLoaded) {
      // Optimistic Update
      final optimisticProfile = currentState.profile.copyWith(
        favoriteCategories: event.categories,
      );
      emit(ProfileLoaded(optimisticProfile));
    }

     try {
       await _profileRepository.updateFavoriteCategories(event.userId, event.categories);
     } catch(e) {
      // TODO: Add error logging
       // Optional: Could emit a transient error message or snackbar event here
     }
  }

  @override
  Future<void> close() {
    _profileSubscription?.cancel();
    return super.close();
  }
}

