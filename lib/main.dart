import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';

void main() => runApp(MainApp());

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _HomeScreen();
}

class _HomeScreen extends State<MainApp> {


  StreamSubscription? _sub;
  String _status = 'Waiting for link...';

  @override
  void initState() {
    super.initState();
    initUniLinks();
  }

  Future<void> initUniLinks() async {
    // 1. Handle initial link if app was launched by a deep link
    final initialUri = await getInitialUri();
    if (initialUri != null) _handleIncomingLink(initialUri);

    // 2. Handle links while app is running
    _sub = uriLinkStream.listen((Uri? uri) {
      if (uri != null) _handleIncomingLink(uri);
    }, onError: (err) {
      setState(() => _status = 'Failed to receive link: $err');
    });
  }

  void _handleIncomingLink(Uri uri) {
    setState(() => _status = 'Received link: $uri');

    if (uri.host == 'details') {
      // Example link: myapp://details/42
      final id = uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : 'unknown';
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DetailsScreen(id: id)),
      );
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Yuri Website"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("i love women. see yuri on mainapp://details/42"),
            SizedBox(height: 20),
            Text(_status),
          ],
        ),
      ),
    );
  }
}

class DetailsScreen extends StatelessWidget {

  final String id;
  const DetailsScreen({required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Yuri Detail"),
      ),
      body: Center(
        child: Text("women id : $id"),
      ),
    );
  }
}
