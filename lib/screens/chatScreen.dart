import 'package:dor_chat_client/models/infoMessage.dart';
import 'package:dor_chat_client/models/infoUser.dart';
import 'package:dor_chat_client/models/chatData.dart';
import 'package:dor_chat_client/models/settings_model.dart';
import 'package:dor_chat_client/widgets/custom_app_bar.dart';
import 'package:dor_chat_client/widgets/profileDisplay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'dart:convert';


class ChatScreenArguments {
  final InfoUser theUser;

  ChatScreenArguments(this.theUser);
}

class ChatScreen extends StatefulWidget {
   ChatScreen(this.theUser,{Key? key}) : conversationId='',super(key: key){

     conversationId =  ChatData().calculateConversationId(theUser.facebookId);
  }
  static const String routeName = '/chat_screen';
   String conversationId ;



  final InfoUser theUser;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<types.Message> _messages = <types.Message>[];


  void updateChatData() {
    List<InfoMessage> currentChatMessages = ChatData().messagesInConversation(
        widget.conversationId);
    for(var x in currentChatMessages){
      print(x.addedDate);
    }
    _messages = currentChatMessages.map((message) => message.toUiMessage()).toList();
    print('Dor');

  }

  void listen()async{
    await ChatData().markConversationAsRead(widget.conversationId);
    setState(() {
    print('updating chat info...');
    updateChatData();

  });}



  @override
  void initState() {
    print('going to listen to conversation ${widget.conversationId}');
    ChatData().markConversationAsRead(widget.conversationId).then((_)
    => ChatData().listenConversation(widget.conversationId,listen));


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    updateChatData(); //TODO remove this after playing with UI
    return Scaffold(
      appBar: CustomAppBar(
        hasTopPadding: true,
        hasBackButton: true,
        customTitle: ProfileDisplay(widget.theUser,minRadius: 10,maxRadius: 20,direction: Axis.horizontal,),
      ),
      body: Chat(
        user: types.User(id: SettingsData().facebookId),
          showUserAvatars:true,
        onSendPressed: (text){
          ChatData().sendMessage(widget.theUser.facebookId,
              jsonEncode({"type":"text","content":"${text.text}"}));
        },
        messages: _messages,


      ),
    );
  }

  @override
  void dispose() {
    ChatData().removeListenerConversation(widget.conversationId,listen);
    print('called remove listener ${widget.conversationId}');

    super.dispose();
  }
}
