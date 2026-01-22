import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:endless_trivia/features/auth/domain/repositories/auth_repository.dart';

enum SignupStatus { initial, submitting, success, failure }

class SignupState extends Equatable {
  final SignupStatus status;
  final String? errorMessage;

  const SignupState({
    this.status = SignupStatus.initial,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [status, errorMessage];
  
  SignupState copyWith({
    SignupStatus? status,
    String? errorMessage,
  }) {
    return SignupState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class SignupCubit extends Cubit<SignupState> {
  final AuthRepository _authRepository;

  SignupCubit(this._authRepository) : super(const SignupState());

  Future<void> signupWithCredentials(String email, String password) async {
    if (email.isEmpty || password.isEmpty) return;
    emit(state.copyWith(status: SignupStatus.submitting));
    try {
      await _authRepository.signUp(email: email, password: password);
      emit(state.copyWith(status: SignupStatus.success));
    } catch (e) {
      emit(state.copyWith(status: SignupStatus.failure, errorMessage: e.toString()));
    }
  }
}
