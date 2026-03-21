sealed class AppExceptions implements Exception {
  String message;
  int? statusCode;
  AppExceptions({required this.message, this.statusCode});

  @override
  String toString() => message;
}

class ServerException extends AppExceptions {
  ServerException({required super.message, super.statusCode});
}

class NetworkException extends AppExceptions {
  NetworkException({required super.message, super.statusCode});
}

class UnexpectedException extends AppExceptions {
  UnexpectedException({required super.message, super.statusCode});
}

class BadRequestException extends AppExceptions {
  BadRequestException({required super.message, super.statusCode});
}

class UnauthorizedException extends AppExceptions {
  UnauthorizedException({required super.message, super.statusCode});
}

class ForbiddenException extends AppExceptions {
  ForbiddenException({required super.message, super.statusCode});
}

class NotFoundException extends AppExceptions {
  NotFoundException({required super.message, super.statusCode});
}

class InternalServerException extends AppExceptions {
  InternalServerException({required super.message, super.statusCode});
}
