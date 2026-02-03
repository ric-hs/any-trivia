import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:endless_trivia/l10n/app_localizations.dart';
import 'package:endless_trivia/core/di/injection_container.dart';
import 'package:endless_trivia/features/auth/presentation/cubit/login_cubit.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:endless_trivia/core/presentation/widgets/space_background.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LoginCubit>(),
      child: const _LoginForm(),
    );
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm();

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.status == LoginStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ?? AppLocalizations.of(context)!.errorAuth,
                ),
              ),
            );
          }
        },
        child: SpaceBackground(
          child: Padding(
            padding: const EdgeInsets.all(24.0), // Generous padding
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo Image
                      Image.asset(
                            'assets/logo/logo.png',
                            height: 180,
                            fit: BoxFit.contain,
                          )
                          .animate(
                            onPlay: (controller) =>
                                controller.repeat(reverse: true),
                          )
                          .moveY(
                            begin: -10,
                            end: 10,
                            duration: 3.seconds,
                            curve: Curves.easeInOutSine,
                          ),
                      const SizedBox(height: 16),
                      // Logo Title Image
                      Image.asset(
                        'assets/logo/logo_title.png',
                        height: 50,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 16),
                      // Slogan
                      Text(
                            AppLocalizations.of(context)!.appSlogan,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 18,
                                ),
                          )
                          .animate()
                          .fadeIn(duration: 800.ms, delay: 300.ms)
                          .shimmer(duration: 2.seconds, delay: 1.seconds),
                      const SizedBox(height: 48),

                      BlocBuilder<LoginCubit, LoginState>(
                        builder: (context, state) {
                          if (state.status == LoginStatus.submitting) {
                            return const CircularProgressIndicator();
                          }
                          return SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF00E5FF), // Cyan
                                    Color(0xFFD500F9), // Purple
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFD500F9).withOpacity(0.5),
                                    blurRadius: 20,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(30),
                                  onTap: () {
                                    context.read<LoginCubit>().logInAnonymously();
                                  },
                                  child: Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.play_arrow_rounded,
                                          color: Colors.white,
                                          size: 32,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          AppLocalizations.of(context)!.startGame,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .animate(
                              onPlay: (controller) => controller.repeat(reverse: true),
                            )
                            .scale(
                              begin: const Offset(1.0, 1.0),
                              end: const Offset(1.05, 1.05),
                              duration: 1500.ms,
                              curve: Curves.easeInOut,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 48),
                      // Footer
                      Text(
                        "POWERED BY AI ⚡️",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white24,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
