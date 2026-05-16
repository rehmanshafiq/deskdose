/// Data-layer exceptions thrown by remote/local sources.
class ServerException implements Exception {
  const ServerException({this.message = 'Server exception', this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => 'ServerException: $message (status: $statusCode)';
}

class CacheException implements Exception {
  const CacheException({this.message = 'Cache exception'});

  final String message;

  @override
  String toString() => 'CacheException: $message';
}

class NetworkException implements Exception {
  const NetworkException({this.message = 'Network exception'});

  final String message;

  @override
  String toString() => 'NetworkException: $message';
}

class AuthException implements Exception {
  const AuthException({this.message = 'Auth exception'});

  final String message;

  @override
  String toString() => 'AuthException: $message';
}

class NotFoundException implements Exception {
  const NotFoundException({this.message = 'Not found'});

  final String message;

  @override
  String toString() => 'NotFoundException: $message';
}
