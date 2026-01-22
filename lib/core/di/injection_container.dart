import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:endless_trivia/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:endless_trivia/features/auth/domain/repositories/auth_repository.dart';
import 'package:endless_trivia/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:endless_trivia/features/auth/presentation/cubit/login_cubit.dart';
import 'package:endless_trivia/features/auth/presentation/cubit/signup_cubit.dart';
import 'package:endless_trivia/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:endless_trivia/features/profile/domain/repositories/profile_repository.dart';
import 'package:endless_trivia/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:endless_trivia/features/game/data/datasources/gemini_service.dart';
import 'package:endless_trivia/features/game/data/repositories/game_repository_impl.dart';
import 'package:endless_trivia/features/game/domain/repositories/game_repository.dart';
import 'package:endless_trivia/features/game/presentation/bloc/game_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Auth
  // Bloc
  sl.registerFactory(() => AuthBloc(authRepository: sl()));
  sl.registerFactory(() => LoginCubit(sl()));
  sl.registerFactory(() => SignupCubit(sl()));
  sl.registerFactory(() => ProfileBloc(profileRepository: sl()));
  sl.registerFactory(() => GameBloc(gameRepository: sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(firebaseAuth: FirebaseAuth.instance),
  );
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(firestore: FirebaseFirestore.instance),
  );
  sl.registerLazySingleton<GameRepository>(
    () => GameRepositoryImpl(geminiService: sl()),
  );

  // Data sources
  sl.registerLazySingleton<GeminiService>(
    () => GeminiService(apiKey: "AIzaSyBtCX2eZwU2BCsTctV-RV1ralZBOnDGsI8"),
  );

  // External
}
