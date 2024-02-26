import 'package:flutter/material.dart';
import 'package:flutter_grpc_test/pages/client_stream_request_page.dart';
import 'package:flutter_grpc_test/pages/home_page.dart';
import 'package:flutter_grpc_test/pages/server_stream_request_page.dart';
import 'package:flutter_grpc_test/pages/unary_request_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/unary-request': (context) => const UnaryRequestPage(),
        '/stream-server-request': (context) => const ServerStreamRequestPage(),
        '/stream-client-request': (context) => const ClientStreamRequestPage(),
      },
    );
  }
}
