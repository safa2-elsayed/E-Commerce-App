import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthFailure extends AuthState {
  final String error;
  const AuthFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class AuthRememberMeChanged extends AuthState {
  final bool rememberMe;
  const AuthRememberMeChanged(this.rememberMe);

  @override
  List<Object?> get props => [rememberMe];
}
