import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greendit/core/enums/enums.dart';
import 'package:greendit/core/providers/storage_respository_provider.dart';
import 'package:greendit/core/utils.dart';
import 'package:greendit/features/auth/controller/auth_controller.dart';
import 'package:greendit/features/user_profile/repository/user_profile_repository.dart';
import 'package:greendit/models/post_model.dart';
import 'package:greendit/models/user_model.dart';
import 'package:routemaster/routemaster.dart';

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
  final userProfileRepository = ref.watch(userProfileRepositoryProvider);
  final storageRepositoty = ref.watch(storageRepositoryProvider);
  return UserProfileController(
    userProfileRepository: userProfileRepository,
    ref: ref,
    storageRepositoty: storageRepositoty,
  );
});

final getUserPostsProvider = StreamProvider.family((ref, String uid) {
  return ref.read(userProfileControllerProvider.notifier).getUserPosts(uid);
});

class UserProfileController extends StateNotifier<bool> {
  final UserProfileRepository _userProfileRepository;
  final Ref _ref;
  final StorageRepositoty _storageRepositoty;

  UserProfileController(
      {required UserProfileRepository userProfileRepository,
      required Ref ref,
      required StorageRepositoty storageRepositoty})
      : _userProfileRepository = userProfileRepository,
        _ref = ref,
        _storageRepositoty = storageRepositoty,
        super(false);

  void editUser({
    required File? profileFile,
    required File? bannerFile,
    required BuildContext context,
    required String name,
  }) async {
    state = true;
    UserModel user = _ref.read(userProvider)!;

    if (profileFile != null) {
      final res = await _storageRepositoty.storeFile(
        path: 'users/profile',
        Id: user.uid,
        file: profileFile,
      );
      res.fold(
        (l) => showSnackBar(context, l.message),
        (r) => user = user.copyWith(profilePic: r),
      );
    }

    if (bannerFile != null) {
      final res = await _storageRepositoty.storeFile(
        path: 'users/banner',
        Id: user.name,
        file: bannerFile,
      );
      res.fold(
        (l) => showSnackBar(context, l.message),
        (r) => user = user.copyWith(banner: r),
      );
    }
    user = user.copyWith(name: name);

    final res = await _userProfileRepository.editProfile(user);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        _ref.read(userProvider.notifier).update((state) => user);
        Routemaster.of(context).pop();
      },
    );
  }

  Stream<List<Post>> getUserPosts(String uid){
    return _userProfileRepository.getUserPosts(uid);
  }

  void updateUserKarma(UserKarma karma)async {
    UserModel user = _ref.read(userProvider)!;
    user = user.copyWith(karma: user.karma + karma.karma);
    final res = await _userProfileRepository.updateUserKarma(user);
    res.fold((l) => null, (r) => _ref.read(userProvider.notifier).update((state) => user));
  }
}
