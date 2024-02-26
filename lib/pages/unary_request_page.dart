import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grpc_test/models/user_model.dart';
import 'package:grpc/grpc.dart';
import 'package:grpc/grpc_web.dart';
import 'package:grpc_dart_me/generated/user/user.pbgrpc.dart';

class UnaryRequestPage extends StatefulWidget {
  const UnaryRequestPage({super.key});

  @override
  State<UnaryRequestPage> createState() => _UnaryRequestPageState();
}

class _UnaryRequestPageState extends State<UnaryRequestPage> {
  late final ClientChannel _channel;
  late final GrpcWebClientChannel _channelWeb;

  late final UserServiceClient _stubUser;
  List<UserModel> _userModelList = [];

  @override
  void initState() {
    super.initState();

    _channelWeb = GrpcWebClientChannel.xhr(
      Uri.parse('http://192.168.0.179:8080'),
    );

    _channel = ClientChannel(
      '192.168.0.179',
      port: 50051,
      options: ChannelOptions(
        credentials: const ChannelCredentials.insecure(),
        codecRegistry:
            CodecRegistry(codecs: const [GzipCodec(), IdentityCodec()]),
      ),
    );

    _stubUser = UserServiceClient(kIsWeb ? _channelWeb : _channel);
  }

  @override
  void dispose() {
    _channel.shutdown();
    _channelWeb.shutdown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unary Request'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _userModelList.length,
              itemBuilder: (context, index) {
                if (_userModelList.isEmpty) {
                  return const SizedBox.shrink();
                }

                final user = _userModelList[index];
                return ListTile(
                  title: Text(user.name),
                  subtitle: Text(
                    user.age.toString(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildButton(),
    );
  }

  Padding _buildButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: () async {
          final userResponse = await _stubUser.getUsers(UserRequest());
          setState(
            () {
              _userModelList = userResponse.users
                  .map(
                    (e) => UserModel(id: e.id, name: e.name, age: e.age),
                  )
                  .toList();
            },
          );
        },
        child: const Text('Busca Usuários'),
      ),
    );
  }
}
