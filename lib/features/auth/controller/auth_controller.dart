import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greendit/core/utils.dart';
import 'package:greendit/features/auth/repository/auth_repository.dart';
import 'package:greendit/models/user_model.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    authRepostity: ref.watch(authRepositoryProvider),
    ref: ref,
  ),
);

final authStateChangeProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChange;
});

final getUserDataProvider = StreamProvider.family((ref, String uid){
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUsserData(uid);
});

class AuthController extends StateNotifier<bool> {
  final AuthRepostity _authRepostity;
  final Ref _ref;

  AuthController({required AuthRepostity authRepostity, required Ref ref})
      : _authRepostity = authRepostity,
        _ref = ref,
        super(false); //loading

  Stream<User?> get authStateChange => _authRepostity.authStateChange;

  void signInWithGoogle(BuildContext context) async {
    state = true;
    final user = await _authRepostity.signInWithGoogle();
    state = false;
    user.fold(
      (l) => showSnackBar(context, l.message),
      (userModel) =>
          _ref.read(userProvider.notifier).update((state) => userModel),
    );
  }

  Stream<UserModel> getUsserData(String uid){
    return _authRepostity.getUsserData(uid);
  }

  void loggout() async{
    _authRepostity.logOut();
  }
}
