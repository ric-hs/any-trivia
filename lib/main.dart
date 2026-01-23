import 'package:endless_trivia/multi_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:endless_trivia/core/di/injection_container.dart' as di;
import 'package:endless_trivia/core/theme/app_theme.dart';
import 'package:endless_trivia/l10n/app_localizations.dart';
import 'package:endless_trivia/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:endless_trivia/features/auth/presentation/bloc/auth_event.dart';
import 'package:endless_trivia/features/auth/presentation/bloc/auth_state.dart';
import 'package:endless_trivia/features/auth/presentation/pages/login_page.dart';
import 'package:endless_trivia/features/game/presentation/pages/home_page.dart';
import 'package:endless_trivia/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:endless_trivia/features/profile/presentation/bloc/profile_event.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await di.init();

  runApp(MultiProvider(child: const EndlessTriviaApp()));
}

class EndlessTriviaApp extends StatelessWidget {
  const EndlessTriviaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<AuthBloc>()..add(AuthSubscriptionRequested()),
      child: MaterialApp(
        title: 'Endless Trivia',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state.status == AuthStatus.authenticated &&
                state.user != null) {
              context.read<ProfileBloc>().add(LoadProfile(state.user!.id));
            }
          },
          builder: (context, state) {
            if (state.status == AuthStatus.authenticated) {
              return const HomePage();
            } else if (state.status == AuthStatus.unauthenticated) {
              return const LoginPage();
            }
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          },
        ),
      ),
    );
  }
}
