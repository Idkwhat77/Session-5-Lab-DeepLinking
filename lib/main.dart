import 'dart:async';

import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    initAppLinks();
  }

  Future<void> initAppLinks() async {
    _appLinks = AppLinks();
    
    // Handle initial link if app was launched by a deep link
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        // Delay navigation to ensure the app is fully loaded
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _handleIncomingLink(initialUri);
        });
      }
    } catch (e) {
      print('Failed to get initial link: $e');
    }

    // Handle links while app is running
    _linkSubscription = _appLinks.uriLinkStream.listen(
      (Uri uri) => _handleIncomingLink(uri),
      onError: (err) {
        print('Failed to receive link: $err');
      },
    );
  }

  void _handleIncomingLink(Uri uri) {
    print('Received link: $uri');

    if (uri.host == 'details') {
      final id = uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : 'unknown';
      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (context) => DetailsScreen(id: id)),
      );
    } else if (uri.host == 'profile') {
      final username = uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : 'unknown';
      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (context) => ProfileScreen(username: username)),
      );
    }
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deep Link Demo',
      navigatorKey: navigatorKey,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Yuri Website"),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("i love women. see yuri on myapp://details/42"),
            SizedBox(height: 20),
            Text("Also try myapp://profile/alex"),
          ],
        ),
      ),
    );
  }
}

class DetailsScreen extends StatelessWidget {
  final String id;
  const DetailsScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Yuri Detail"),
      ),
      body: Center(
        child: Text("women id : $id"),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  final String username;
  const ProfileScreen({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Page"),
      ),
      body: Center(
        child: Text("Hello, $username!"),
      ),
    );
  }
}