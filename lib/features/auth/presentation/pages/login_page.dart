import 'package:deskdose/core/constants/app_constants.dart';
import 'package:deskdose/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:deskdose/features/auth/presentation/bloc/auth_event.dart';
import 'package:deskdose/features/auth/presentation/bloc/auth_state.dart';
import 'package:deskdose/features/auth/presentation/widgets/google_sign_in_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const Spacer(flex: 2),
                Icon(
                  Icons.self_improvement,
                  size: 72,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 20),
                Text(
                  AppConstants.appName,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your daily wellness dose',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(flex: 3),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    final loading = state is AuthLoading;
                    return GoogleSignInButton(
                      isLoading: loading,
                      onPressed: () => context.read<AuthBloc>().add(
                            const SignInWithGoogleRequested(),
                          ),
                    );
                  },
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
