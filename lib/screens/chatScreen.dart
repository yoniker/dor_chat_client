import 'package:dor_chat_client/models/users_model.dart';
import 'package:flutter/material.dart';


class ChatScreenArguments {
  final InfoUser theUser;

  ChatScreenArguments(this.theUser);
}

class ChatScreen extends StatefulWidget {
  const ChatScreen(this.theUser,{Key? key}) : super(key: key);
  static const String routeName = '/chat_screen';

  final InfoUser theUser;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child:Text(widget.theUser.name)
    );
  }
}
