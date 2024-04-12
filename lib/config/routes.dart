import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:myfarmadmin/features/auth/presentation/screen/login-page.dart';
import 'package:myfarmadmin/features/common/presentation/screen/splash_page.dart';
import 'package:myfarmadmin/features/farms/presentation/screen/farm_page.dart';
import 'package:myfarmadmin/features/farms/presentation/widget/create_farm_form.dart';
import 'package:myfarmadmin/features/home/presentation/screen/home-page.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'login',
          builder: (BuildContext context, GoRouterState state) {
            return const LoginPage();
          },
        ),
        GoRoute(
          path: 'splash',
          builder: (BuildContext context, GoRouterState state) {
            return const SplashPage();
          },
        ),
        GoRoute(
          path: 'farm',
          builder: (BuildContext context, GoRouterState state) {
            return const FarmPage();
          },
        ),
        GoRoute(
          path: 'addNewFarm',
          builder: (BuildContext context, GoRouterState state) {
            return const CreatFarm();
          },
        ),
      ],
    ),
  ],
);
