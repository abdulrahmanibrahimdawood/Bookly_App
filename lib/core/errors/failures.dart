import 'package:dio/dio.dart';

abstract class Failures {
  final String errorMessage;

  Failures({required this.errorMessage});
}

class ServerFailures extends Failures {
  ServerFailures({required super.errorMessage});

  factory ServerFailures.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailures(
            errorMessage: 'Connection Timeout with API Server');
      case DioExceptionType.sendTimeout:
        return ServerFailures(errorMessage: 'Send Timeout with API Server');
      case DioExceptionType.receiveTimeout:
        return ServerFailures(errorMessage: 'Receive Timeout with API Server');

      case DioExceptionType.badResponse:
        return ServerFailures.fromResponse(
            dioError.response!.statusCode!, dioError.response!.data);

      case DioExceptionType.cancel:
        return ServerFailures(
            errorMessage: 'Request to API Server was canceled');
      case DioExceptionType.unknown:
        if (dioError.message!.contains('SocketException')) {
          return ServerFailures(errorMessage: 'No Internet Connection');
        }
        return ServerFailures(
            errorMessage: 'Unexpected Error, Please try again');
      default:
        return ServerFailures(
            errorMessage: 'Opps there was an error please try again later');
    }
  }
  factory ServerFailures.fromResponse(int statusCode, dynamic response) {
    if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
      return ServerFailures(errorMessage: response['error']['message']);
    } else if (statusCode == 404) {
      return ServerFailures(
          errorMessage: 'Your request not found please try again later!');
    } else if (statusCode == 500) {
      return ServerFailures(
          errorMessage: 'Internal server error please try again later');
    } else {
      return ServerFailures(
          errorMessage: 'Opps there was an error please try again later');
    }
  }
}
