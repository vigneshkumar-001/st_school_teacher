import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? code;     // optional http status code
  final dynamic data;  // optional extra server data

  const Failure(this.message, {this.code, this.data});

  @override
  List<Object?> get props => [message, code, data];
}

class ServerFailure extends Failure {
  const ServerFailure(
      String message, {
        int? code,
        dynamic data,
      }) : super(message, code: code, data: data);
}

class NetworkFailure extends Failure {
  const NetworkFailure(
      String message, {
        int? code,
        dynamic data,
      }) : super(message, code: code, data: data);
}
