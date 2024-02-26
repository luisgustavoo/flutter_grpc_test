import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'package:grpc_dart_me/generated/user/user.pbgrpc.dart';

class ClientStreamRequestPage extends StatefulWidget {
  const ClientStreamRequestPage({super.key});

  @override
  State<ClientStreamRequestPage> createState() =>
      _ClientStreamRequestPageState();
}

class _ClientStreamRequestPageState extends State<ClientStreamRequestPage> {
  late final ClientChannel _channel;

  late final UserServiceClient _stubUser;

  List<User> _userModelList = [];

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
      body: ListView.builder(
        itemCount: _userModelList.length,
        itemBuilder: (context, index) {
          final user = _userModelList[index];
          return ListTile(
            title: Text(user.name),
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
          final usersResponse =
              await _stubUser.sendUsersClientStream(_sendUsersServer());
          setState(() {
            _userModelList = usersResponse.users;
          });
        },
        child: const Text('Busca Usuários (Stream Client)'),
      ),
    );
  }

  Stream<User> _sendUsersServer() async* {
    // final userList = <User>[];
    for (var i = 0; i < 2; i++) {
      yield User(id: i, name: 'Name $i', age: i);
      await Future<void>.delayed(
        const Duration(
          milliseconds: 500,
        ),
      );
    }
  }
}
