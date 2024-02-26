import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'package:grpc_dart_me/generated/user/user.pbgrpc.dart';

class ServerStreamRequestPage extends StatefulWidget {
  const ServerStreamRequestPage({super.key});

  @override
  State<ServerStreamRequestPage> createState() =>
      _ServerStreamRequestPageState();
}

class _ServerStreamRequestPageState extends State<ServerStreamRequestPage> {
  late final ClientChannel _channel;

  late final UserServiceClient _stubUser;

  ResponseStream<UserResponse>? _stream;

  @override
  void initState() {
    super.initState();

    _channel = ClientChannel(
      '192.168.0.179',
      port: 50051,
      options: ChannelOptions(
        credentials: const ChannelCredentials.insecure(),
        codecRegistry:
            CodecRegistry(codecs: const [GzipCodec(), IdentityCodec()]),
      ),
    );

    _stubUser = UserServiceClient(_channel);
  }

  @override
  void dispose() {
    _channel.shutdown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: StreamBuilder(
        stream: _stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox.shrink();
          }
          return ListView.builder(
            itemCount: snapshot.data?.users.length ?? 0,
            itemBuilder: (context, index) {
              final user = snapshot.data?.users[index];
              return ListTile(
                title: Text(user?.name ?? ''),
              );
            },
          );
        },
      ),
      bottomNavigationBar: _buildButton(),
    );
  }

  Padding _buildButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: () async {
          setState(() {
            _stream = _stubUser.getUsersServerStream(UserRequest());
          });
        },
        child: const Text('Busca Usuários (Stream Server)'),
      ),
    );
  }
}
