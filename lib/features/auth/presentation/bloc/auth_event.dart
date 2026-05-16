import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Dispatched once on cold start to restore session and subscribe to auth changes.
class AppStarted extends AuthEvent {
  const AppStarted();
}

class SignInWithGoogleRequested extends AuthEvent {
  const SignInWithGoogleRequested();
}

class SignOutRequested extends AuthEvent {
  const SignOutRequested();
}

/// Internal: Supabase session became available (OAuth redirect / token refresh).
class AuthSessionChanged extends AuthEvent {
  const AuthSessionChanged({required this.isSignedIn});

  final bool isSignedIn;

  @override
  List<Object?> get props => [isSignedIn];
}
