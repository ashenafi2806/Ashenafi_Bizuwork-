import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/login_usecase.dart';

sealed class AuthState {}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthSuccess extends AuthState {
  final UserEntity user;
  AuthSuccess(this.user);
}
class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
}

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;

  AuthCubit({required this.loginUseCase}) : super(AuthInitial());

  Future<void> signIn(String pin) async {
    if (pin.length != 4) {
      emit(AuthFailure('Enter your 4-digit M-PESA PIN'));
      return;
    }
    emit(AuthLoading());
    try {
      emit(AuthSuccess(await loginUseCase(pin)));
    } catch (error) {
      emit(AuthFailure(error.toString().replaceFirst('Exception: ', '')));
    }
  }
}