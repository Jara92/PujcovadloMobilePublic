import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:pujcovadlo_client/features/authentication/responses/user_response.dart';
import 'package:pujcovadlo_client/features/authentication/services/authentication_service.dart';
import 'package:pujcovadlo_client/features/profiles/services/profile_service.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationService _authenticationService =
      GetIt.instance.get<AuthenticationService>();
  final ProfileService _profileService = GetIt.instance.get<ProfileService>();

  late StreamSubscription<AuthenticationStateEnum>
      _authenticationStatusSubscription;

  AuthenticationBloc() : super(const AuthenticationInitial()) {
    on<AuthenticationLogoutRequested>(_onAuthenticationLogoutRequested);
    on<_AuthenticationStatusChanged>(_onAuthenticationStatusChanged);

    _authenticationStatusSubscription = _authenticationService.status.listen(
      (status) => add(_AuthenticationStatusChanged(status)),
    );
  }

  @override
  Future<void> close() {
    _authenticationStatusSubscription.cancel();
    return super.close();
  }

  Future<void> _onAuthenticationStatusChanged(
    _AuthenticationStatusChanged event,
    Emitter<AuthenticationState> emit,
  ) async {
    switch (event.status) {
      case AuthenticationStateEnum.unauthenticated:
        return emit(const Unauthenticated());
      case AuthenticationStateEnum.authenticated:
        final user = await _tryGetUser();
        return emit(
          user != null
              ? Authenticated(currentUser: user)
              : const Unauthenticated(),
        );
      case AuthenticationStateEnum.unknown:
        return emit(const Unknown());
    }
  }

  Future<UserResponse?> _tryGetUser() async {
    try {
      // get current user id
      final userId = _authenticationService.currentUserId;
      if (userId == null) {
        return null;
      }

      // get current user
      final user = await _profileService.getUserById(userId);

      return user;
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> _onAuthenticationLogoutRequested(
    AuthenticationLogoutRequested event,
    Emitter<AuthenticationState> emit,
  ) {
    return _authenticationService.logout();
  }
}
