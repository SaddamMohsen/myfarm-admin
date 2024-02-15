import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myfarmadmin/features/auth/application/supabase_auth_provider.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
    // await for for the widget to mount
    await Future.delayed(Duration.zero);
    dynamic session =
        await ref.watch(authControllerProvider.notifier).currentSession();
    if (session) {
      print('in splash');
      print(session);
      context.go('/');
    } else
      context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: CircularProgressIndicator(
      backgroundColor: Theme.of(context).primaryColor,
    ))
        // child: Center(child: Text('مرحبا بكم تطبيق مزرعتي للمدير')),
        );
  }
}
