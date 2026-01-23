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
     try {
       await _profileRepository.updateFavoriteCategories(event.userId, event.categories);
       add(LoadProfile(event.userId, showLoading: false));
     } catch(e) {
       emit(ProfileError(e.toString()));
     }
  }

  Future<void> _onConsumeToken(ConsumeToken event, Emitter<ProfileState> emit) async {
    if (event.currentTokens < event.amount) {
      emit(const ProfileError("No tokens left!"));
      return;
    }
    try {
      await _profileRepository.updateTokens(event.userId, event.currentTokens - event.amount);
       add(LoadProfile(event.userId, showLoading: false));
    } catch (e) {
       emit(ProfileError(e.toString()));
    }
  }
}
