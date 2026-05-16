import 'package:equatable/equatable.dart';

/// Domain-level error representation. Presentation maps these to UI messages.
abstract class Failure extends Equatable {
  const Failure({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure({super.message = 'Server error occurred.'});
}

class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Cache error occurred.'});
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'No internet connection.'});
}

class AuthFailure extends Failure {
  const AuthFailure({super.message = 'Authentication failed.'});
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({super.message = 'Resource not found.'});
}

class ValidationFailure extends Failure {
  const ValidationFailure({required super.message});
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure({super.message = 'An unexpected error occurred.'});
}
