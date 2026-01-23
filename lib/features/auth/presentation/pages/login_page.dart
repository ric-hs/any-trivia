import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:endless_trivia/l10n/app_localizations.dart';
import 'package:endless_trivia/core/di/injection_container.dart';
import 'package:endless_trivia/features/auth/presentation/cubit/login_cubit.dart';
import 'package:endless_trivia/features/auth/presentation/pages/signup_page.dart';
import 'package:endless_trivia/core/utils/validators.dart';

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
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.status == LoginStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? AppLocalizations.of(context)!.errorAuth)),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(24.0), // Generous padding
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Title / Logo
                    Text(
                      AppLocalizations.of(context)!.appTitle.toUpperCase(),
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2.0,
                          ),
                    ),
                    const SizedBox(height: 48),
                    
                    // Email Input
                    TextFormField(
                      controller: _emailController,
                      validator: (value) => Validators.emailValidator(context, value),
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.email,
                        filled: true,
                        fillColor: const Color(0xFF2C2C2C),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    
                    // Password Input
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.password,
                        filled: true,
                        fillColor: const Color(0xFF2C2C2C),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(Icons.lock),
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Login Button
                    BlocBuilder<LoginCubit, LoginState>(
                      builder: (context, state) {
                        if (state.status == LoginStatus.submitting) {
                           return const CircularProgressIndicator();
                        }
                        return SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<LoginCubit>().logInWithCredentials(
                                      _emailController.text,
                                      _passwordController.text,
                                    );
                              }
                            },
                            child: Text(AppLocalizations.of(context)!.startGame),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Signup Link
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const SignupPage()),
                        );
                      },
                      child: Text(AppLocalizations.of(context)!.createAccount),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
