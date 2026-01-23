import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:endless_trivia/features/auth/domain/repositories/auth_repository.dart';

enum LoginStatus { initial, submitting, success, failure }

class LoginState extends Equatable {
  final LoginStatus status;
  final String? errorMessage;

  const LoginState({this.status = LoginStatus.initial, this.errorMessage});

  @override
  List<Object?> get props => [status, errorMessage];

  LoginState copyWith({LoginStatus? status, String? errorMessage}) {
    return LoginState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;

  LoginCubit(this._authRepository) : super(const LoginState());

  Future<void> logInWithCredentials(String email, String password) async {
    if (email.isEmpty || password.isEmpty) return;
    emit(state.copyWith(status: LoginStatus.submitting));
    try {
      await _authRepository.logIn(email: email, password: password);
      emit(state.copyWith(status: LoginStatus.success));
    } catch (e) {
      emit(
        state.copyWith(status: LoginStatus.failure, errorMessage: e.toString()),
      );
      // Reset status to initial or just keep failure? failure is fine.
    }
  }

  Future<void> logInAnonymously() async {
    emit(state.copyWith(status: LoginStatus.submitting));
    try {
      await _authRepository.logInAnonymously();
      emit(state.copyWith(status: LoginStatus.success));
    } catch (e) {
      emit(
        state.copyWith(status: LoginStatus.failure, errorMessage: e.toString()),
      );
    }
  }
}
