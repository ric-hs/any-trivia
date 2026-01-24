import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:endless_trivia/features/profile/domain/repositories/profile_repository.dart';
import 'package:endless_trivia/features/profile/presentation/bloc/profile_event.dart';
import 'package:endless_trivia/features/profile/presentation/bloc/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _profileRepository;

  ProfileBloc({required ProfileRepository profileRepository}) 
      : _profileRepository = profileRepository, 
        super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateFavoriteCategories>(_onUpdateFavorites);
    on<ConsumeToken>(_onConsumeToken);
  }

  Future<void> _onLoadProfile(LoadProfile event, Emitter<ProfileState> emit) async {
    if (event.showLoading) {
      emit(ProfileLoading());
    }
    try {
      final profile = await _profileRepository.getProfile(event.userId);
      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

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
       // Confirm sync with server
       add(LoadProfile(event.userId, showLoading: false));
     } catch(e) {
       // Revert to server state on error
       add(LoadProfile(event.userId, showLoading: false));
       // Optional: Could emit a transient error message or snackbar event here if we had a way to do so without replacing state
     }
  }

  Future<void> _onConsumeToken(ConsumeToken event, Emitter<ProfileState> emit) async {
    try {
      await _profileRepository.consumeTokens(event.userId, event.amount);
      add(LoadProfile(event.userId, showLoading: false));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
