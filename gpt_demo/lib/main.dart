import 'package:flutter/material.dart';
import 'package:gpt_demo/channel.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

//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
// We set our Stream API Key as a `--dart-define` value
const String streamApi = "eyn8uuaxfav3";

Future<void> main() async {
  final streamClient = StreamChatClient(
    streamApi,
    logLevel: Level.ALL,
  );

  // Set the user for the current running application.
  // To quickly generate a test token for users, check out our JWT generator (https://getstream.io/chat/docs/react/token_generator/)

  await streamClient.connectUser(
      User(
        id: 'tsogoo',
      ),
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidHNvZ29vIn0._olXVNablvaC-L-jjgBo3CPl6Qg003MwvszsyN-UHh0');

  // Configure the channel we would like to use for messages.
  // Note: You should create the users ahead of time in Stream's dashboard else you will encounter an error.
  final streamChannel = streamClient.channel(
    'messaging',
    id: 'gpt_demo',
    extraData: {
      "name": "Humans and AI",
      "members": ["Tsog", "chatbot"]
    },
  );

  // Listen for events on our newly created channel. New messages, status changes, etc.

  streamChannel.watch();

  runApp(
    GTPChat(
      chatClient: streamClient,
      chatChannel: streamChannel,
    ),
  );
}

class GTPChat extends StatefulWidget {
  const GTPChat({
    super.key,
    required this.chatClient,
    required this.chatChannel,
  });

  final StreamChatClient chatClient;
  final Channel chatChannel;

  @override
  State<GTPChat> createState() => _GTPChatState();
}

class _GTPChatState extends State<GTPChat> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GPT and Stream',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const App(),

      // Data is propagated down the widget tree via inherited widgets. Before
      // we can use Stream widgets in our code, we need to set the value of the client.
      builder: (context, child) => StreamChat(
        client: widget.chatClient,
        child: StreamChannel(
          channel: widget.chatChannel,
          child: child!,
        ),
      ),
    );
  }
}
