import 'package:flutter/material.dart';
import 'package:greendit/features/Community/screens/add_mods_screen.dart';
import 'package:greendit/features/Community/screens/community_screen.dart';
import 'package:greendit/features/Community/screens/create_community_screen.dart';
import 'package:greendit/features/Community/screens/edit_community_screen.dart';
import 'package:greendit/features/Community/screens/mod_tools_screen.dart';
import 'package:greendit/features/auth/screen/login_screen.dart';
import 'package:greendit/features/home/screen/home_screen.dart';
import 'package:greendit/features/objectDetected/screens/detector_widget.dart';
import 'package:greendit/features/objectDetected/screens/object_detected_view.dart';
import 'package:greendit/features/objectDetected/screens/object_view.dart';
import 'package:greendit/features/post/screens/add_post_type_screen.dart';
import 'package:greendit/features/post/screens/comments_screen.dart';
import 'package:greendit/features/user_profile/screens/edit_profile_screen.dart';
import 'package:greendit/features/user_profile/screens/user_profile_screen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: LoginScreen()),
});

final loggedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: HomeScreen()),
  '/create-community': (_) =>
      const MaterialPage(child: CreateCommunityScreen()),
  '/g/:name': (route) => MaterialPage(
        child: CommunityScreen(
          name: route.pathParameters['name']!,
        ),
      ),
  '/mod-tools/:name': (routeData) => MaterialPage(
        child: ModToolsScreen(
          name: routeData.pathParameters['name']!,
        ),
      ),
  '/edit-community/:name': (routeData) => MaterialPage(
        child: EditCommunityScreen(
          name: routeData.pathParameters['name']!,
        ),
      ),
  '/add-mods/:name': (routeData) => MaterialPage(
        child: AddModsScreeen(
          name: routeData.pathParameters['name']!,
        ),
      ),
  '/u/:uid': (routeData) => MaterialPage(
        child: UserProfileScreen(
          uid: routeData.pathParameters['uid']!,
        ),
      ),
  '/edit-profile/:uid': (routeData) => MaterialPage(
        child: EditProfileScreen(
          uid: routeData.pathParameters['uid']!,
        ),
      ),
  '/add-post/:type': (routeData) => MaterialPage(
    child: AddPostTypeScreen(
      type: routeData.pathParameters['type']!,
    ),
  ),
  '/post/:postId/comments':(route) => MaterialPage(
    child: CommentsScreen(
      postId: route.pathParameters['postId']!,
    ),
  ),
  '/object/': (routeData) => const MaterialPage(
        child: ObjectView(),
      ),
  '/add-object/': (routeData) => const MaterialPage(
    child: ObjectDetectedView(),
  ),
});
