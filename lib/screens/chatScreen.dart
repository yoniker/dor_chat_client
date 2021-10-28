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
     String userId1 = SettingsData().facebookId;
     String userId2 = theUser.facebookId;
     if (userId1.compareTo(userId2)>0){
       var temp = userId1; //Swap...
       userId1 = userId2;
       userId2=temp;
     }
     conversationId =  'conversation_${userId1}_with_$userId2';
     print('Conversation is $conversationId');
  }
  static const String routeName = '/chat_screen';
   String conversationId ;



  final InfoUser theUser;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  types.User dummyUser = types.User(id:'Dummyid',imageUrl: 'https://picsum.photos/id/237/200/300');
  types.User dummyUser2 = types.User(id:'Dummyid2',imageUrl: 'https://picsum.photos/id/238/200/300');
  List<types.Message> _messages = <types.Message>[];
  List<types.User> _mockUsersInChat=[];


  void updateChatData() {
    List<InfoMessage> currentChatMessages = ChatData().messagesInConversation(
        widget.conversationId);
    _messages = currentChatMessages.map((message) => message.toUiMessage()).toList();

  }

  void listen(){setState(() {
    print('updating chat info...');
    updateChatData();
  });}



  @override
  void initState() {
    //updateChatData();
    //ChatData().addListener(listen);
    print('going to listen to conversation ${widget.conversationId}');
    ChatData().listenConversation(widget.conversationId,listen);
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
