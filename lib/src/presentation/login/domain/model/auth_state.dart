

import 'package:meroupachar/src/presentation/login/domain/model/user.dart';

class AuthState {
  final String errorMessage;
  final bool isSuccess;
  final bool isLoad;
  final User user;

  AuthState(
      {required this.errorMessage,
        required this.isLoad,
        required this.isSuccess,
        required this.user});

  AuthState copyWith(
      {bool? isLoad, String? errorMessage, bool? isSuccess, User? user}) {
    return AuthState(
        errorMessage: errorMessage ?? this.errorMessage,
        isLoad: isLoad ?? this.isLoad,
        isSuccess: isSuccess ?? this.isSuccess,
        user: user ?? this.user);
  }

  factory AuthState.empty() {
    return AuthState(errorMessage: '', isLoad: false, isSuccess: false, user: User.empty());
  }

}