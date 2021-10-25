import 'package:dor_chat_client/models/users_model.dart';
import 'package:dor_chat_client/widgets/custom_app_bar.dart';
import 'package:dor_chat_client/widgets/profileDisplay.dart';
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


  void listen(){setState(() {

  });}

  @override
  void initState() {
    Users().addListener(listen);
    Users().startConversation(widget.theUser.facebookId,"{type:'text',content:'Dummy message ${DateTime.now().toString()}'}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        hasTopPadding: true,
        hasBackButton: true,
        customTitle: ProfileDisplay(widget.theUser,minRadius: 10,maxRadius: 20,direction: Axis.horizontal,),
      ),
    );
  }

  @override
  void dispose() {
    Users().removeListener(listen);
    super.dispose();
  }
}
