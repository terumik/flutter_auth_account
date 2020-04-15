import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter_auth_account/models/repository_responce.model.dart';
import 'package:flutter_auth_account/models/user.model.dart';
import 'package:flutter_auth_account/repositories/user_repository.dart';
import './bloc.dart';

class AvatarBloc extends Bloc<AvatarEvent, AvatarState> {
  final UserRepository _userRepository;
  AvatarBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  User _authenticatedUser;

  @override
  AvatarState get initialState => InitialAvatarState(token: '');

  @override
  Stream<AvatarState> mapEventToState(
    AvatarEvent event,
  ) async* {
    if (event is LoadAvatar) {
      yield* _mapLoadAvatarToState();
    }
    if (event is SubmitNewAvatar) {
      yield* _mapAvatarSubmittedToState(file: event.newAvatar);
    }
  }

  Stream<AvatarState> _mapLoadAvatarToState() async* {
    yield AvatarLoading();
    _authenticatedUser = await _userRepository.getAuthenticatedUser();
    yield AvatarLoaded(oldUsername: _authenticatedUser.username);
  }

  Stream<AvatarState> _mapAvatarSubmittedToState({File file}) async* {
    yield AvatarLoading();
    final ResInfo res = await _userRepository.uploadAvatar(file: file);
    if (res.hasError) {
      yield UpdateAvatarSuccess(resInfo: res, newAvatar: 'new Avatar'); 
      // todo: get responce for new avatar
    } else {
      _authenticatedUser = await _userRepository.getAuthenticatedUser();
      yield UpdateAvatarFailure(resInfo: res);
    }
  }
}
