import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// The home screen
class HomeScreen extends StatelessWidget {
  /// Constructs a [HomeScreen]
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => context.go('/login'),
              child: const Text('Go to the Details screen'),
            ),
            ElevatedButton(
              onPressed: () => context.go('/farm'),
              child: const Text('Go to the Farm screen'),
            ),
            ElevatedButton(
              child: Text(' اضافة مزرعة '),
              onPressed: () {
                context.go('/addNewFarm');
              },
            ),
          ],
        ),
      ),
    );
  }
}
