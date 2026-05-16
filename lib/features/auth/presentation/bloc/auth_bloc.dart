import 'dart:async';

import 'package:deskdose/core/config/env_config.dart';
import 'package:deskdose/core/network/supabase_client_wrapper.dart';
import 'package:deskdose/core/usecases/usecase.dart';
import 'package:deskdose/features/auth/domain/usecases/get_current_user.dart';
import 'package:deskdose/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:deskdose/features/auth/domain/usecases/sign_out.dart';
import 'package:deskdose/features/auth/presentation/bloc/auth_event.dart';
import 'package:deskdose/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required SignInWithGoogleUseCase signInWithGoogle,
    required SignOutUseCase signOut,
    required GetCurrentUserUseCase getCurrentUser,
    required SupabaseClientWrapper supabaseWrapper,
  })  : _signInWithGoogle = signInWithGoogle,
        _signOut = signOut,
        _getCurrentUser = getCurrentUser,
        _supabase = supabaseWrapper,
        super(const AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<SignInWithGoogleRequested>(_onSignInWithGoogle);
    on<SignOutRequested>(_onSignOut);
    on<AuthSessionChanged>(_onAuthSessionChanged);
  }

  final SignInWithGoogleUseCase _signInWithGoogle;
  final SignOutUseCase _signOut;
  final GetCurrentUserUseCase _getCurrentUser;
  final SupabaseClientWrapper _supabase;

  StreamSubscription<supabase.AuthState>? _authSubscription;

  Future<void> _onAppStarted(
    AppStarted event,
    Emitter<AuthState> emit,
  ) async {
    if (!EnvConfig.isConfigured) {
      emit(
        const AuthError(
          message:
              'Supabase is not configured. Add SUPABASE_URL and SUPABASE_ANON_KEY to .env',
        ),
      );
      return;
    }

    emit(const AuthLoading());
    await _authSubscription?.cancel();
    _authSubscription = _supabase.authStateChanges.listen((authState) {
      switch (authState.event) {
        case supabase.AuthChangeEvent.signedIn:
        case supabase.AuthChangeEvent.tokenRefreshed:
        case supabase.AuthChangeEvent.initialSession:
          if (authState.session != null) {
            add(const AuthSessionChanged(isSignedIn: true));
          }
        case supabase.AuthChangeEvent.signedOut:
          add(const AuthSessionChanged(isSignedIn: false));
        default:
          break;
      }
    });

    await _resolveSession(emit);
  }

  Future<void> _onSignInWithGoogle(
    SignInWithGoogleRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _signInWithGoogle(const NoParams());
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) {
        // OAuth completes asynchronously; AuthSessionChanged will emit authenticated.
        if (_supabase.isAuthenticated) {
          add(const AuthSessionChanged(isSignedIn: true));
        }
      },
    );
  }

  Future<void> _onSignOut(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _signOut(const NoParams());
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) => emit(const AuthUnauthenticated()),
    );
  }

  Future<void> _onAuthSessionChanged(
    AuthSessionChanged event,
    Emitter<AuthState> emit,
  ) async {
    if (!event.isSignedIn) {
      emit(const AuthUnauthenticated());
      return;
    }
    await _resolveSession(emit);
  }

  Future<void> _resolveSession(Emitter<AuthState> emit) async {
    if (!_supabase.isAuthenticated) {
      emit(const AuthUnauthenticated());
      return;
    }

    final result = await _getCurrentUser(const NoParams());
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) {
        if (user != null) {
          emit(AuthAuthenticated(user: user));
        } else {
          emit(const AuthUnauthenticated());
        }
      },
    );
  }

  @override
  Future<void> close() {
    unawaited(_authSubscription?.cancel());
    return super.close();
  }
}
