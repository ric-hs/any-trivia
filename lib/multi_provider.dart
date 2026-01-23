import 'package:endless_trivia/core/di/injection_container.dart' as di;
import 'package:endless_trivia/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MultiProvider extends StatelessWidget {
  final Widget child;
  const MultiProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider<ProfileBloc>(
          create: (_) => di.sl<ProfileBloc>(),
        ),
      ],
      child: child,
    );
  }
}
