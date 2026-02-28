sealed class AppExceptions implements Exception {
  String message;
  int? statusCode;
  AppExceptions({required this.message, this.statusCode});

  @override
  String toString() => message;
}

class ServerException extends AppExceptions {
  ServerException({required super.message,  super.statusCode});
}

class NetworkException extends AppExceptions {
  NetworkException({required super.message,  super.statusCode});
}

class UnexpectedException extends AppExceptions {
  UnexpectedException({required super.message,  super.statusCode});
}