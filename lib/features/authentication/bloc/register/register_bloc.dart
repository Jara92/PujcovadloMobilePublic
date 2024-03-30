import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:pujcovadlo_client/features/authentication/models/register/email.dart';
import 'package:pujcovadlo_client/features/authentication/models/register/first_name.dart';
import 'package:pujcovadlo_client/features/authentication/models/register/last_name.dart';
import 'package:pujcovadlo_client/features/authentication/models/register/password.dart';
import 'package:pujcovadlo_client/features/authentication/models/register/password_confirmation.dart';
import 'package:pujcovadlo_client/features/authentication/models/register/phone.dart';
import 'package:pujcovadlo_client/features/authentication/models/register/username.dart';
import 'package:pujcovadlo_client/features/authentication/requests/register_request.dart';
import 'package:pujcovadlo_client/features/authentication/services/authentication_service.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthenticationService _authenticationRepository =
      GetIt.instance.get<AuthenticationService>();

  RegisterBloc() : super(RegisterState.initial()) {
    on<RegisterFirstNameChanged>(_onFirstNameChanged);
    on<RegisterLastNameChanged>(_onLastNameChanged);
    on<RegisterUsernameChanged>(_onUsernameChanged);
    on<RegisterEmailChanged>(_onEmailChanged);
    on<RegisterPhoneChanged>(_onPhoneChanged);
    on<RegisterPasswordChanged>(_onPasswordChanged);
    on<RegisterPasswordConfirmationChanged>(_onPasswordConfirmationChanged);
    on<RegisterSubmitted>(_onSubmitted);
  }

  void _onFirstNameChanged(
    RegisterFirstNameChanged event,
    Emitter<RegisterState> emit,
  ) {
    final firstName = FirstName.dirty(event.firstName);
    emit(
      state.copyWith(
        firstName: firstName,
      ),
    );
  }

  void _onLastNameChanged(
    RegisterLastNameChanged event,
    Emitter<RegisterState> emit,
  ) {
    final lastName = LastName.dirty(event.lastName);
    emit(
      state.copyWith(
        lastName: lastName,
      ),
    );
  }

  void _onUsernameChanged(
    RegisterUsernameChanged event,
    Emitter<RegisterState> emit,
  ) {
    final username = RegisterUsername.dirty(event.username);
    emit(
      state.copyWith(
        username: username,
      ),
    );
  }

  void _onEmailChanged(
    RegisterEmailChanged event,
    Emitter<RegisterState> emit,
  ) {
    final email = RegisterEmail.dirty(event.email);
    emit(
      state.copyWith(
        email: email,
      ),
    );
  }

  void _onPhoneChanged(
    RegisterPhoneChanged event,
    Emitter<RegisterState> emit,
  ) {
    final phone = RegisterPhone.dirty(event.phone);
    emit(
      state.copyWith(
        phone: phone,
      ),
    );
  }

  void _onPasswordChanged(
    RegisterPasswordChanged event,
    Emitter<RegisterState> emit,
  ) {
    final password = RegisterPassword.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
      ),
    );
  }

  void _onPasswordConfirmationChanged(
    RegisterPasswordConfirmationChanged event,
    Emitter<RegisterState> emit,
  ) {
    final password = RegisterPasswordConfirmation.dirty(
        original: state.password, value: event.password);
    emit(
      state.copyWith(
        passwordConfirmation: password,
      ),
    );
  }

  Future<void> _onSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

      try {
        await _authenticationRepository.register(
          RegisterRequest(
            firstName: state.firstName.value,
            lastName: state.lastName.value,
            username: state.username.value,
            email: state.email.value,
            phone: state.phone.value,
            password: state.password.value,
            passwordConfirmation: state.passwordConfirmation.value,
          ),
        );

        emit(state.copyWith(status: FormzSubmissionStatus.success));
      } catch (e) {
        emit(state.copyWith(
            status: FormzSubmissionStatus.failure, error: () => e));
      }
    }
  }
}
