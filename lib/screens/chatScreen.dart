import 'package:dor_chat_client/models/users_model.dart';
import 'package:dor_chat_client/widgets/custom_app_bar.dart';
import 'package:dor_chat_client/widgets/profileDisplay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;


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

  types.User dummyUser = types.User(id:'Dummyid',imageUrl: 'https://picsum.photos/id/237/200/300');
  types.User dummyUser2 = types.User(id:'Dummyid2',imageUrl: 'https://picsum.photos/id/238/200/300');
  List<types.Message> _mockMessages = <types.Message>[];
  List<types.User> _mockUsersInChat=[];

  void updateChatData(){
    _mockUsersInChat = Users().users.map((user) => types.User(id:user.facebookId,firstName: user.name,imageUrl: user.imageUrl)).toList();
    if(_mockUsersInChat.length>2){
      _mockMessages =[
        types.TextMessage(author: _mockUsersInChat[0],id:'Dummy Message Id',text:'Hi I am user 1',createdAt: 1635265755000,status:types.Status.seen),
    types.TextMessage(author: _mockUsersInChat[1],id:'Dummy Message Id',text:'Hi I am user 2 Again!!',createdAt: 1635265755000,status:types.Status.delivered),
    types.TextMessage(author: _mockUsersInChat[1],id:'Dummy Message Id',text:'Hi I am user 2',createdAt: 1635265755000-(3600000~/2),status:types.Status.seen),
        types.TextMessage(author: _mockUsersInChat[2],id:'Dummy Message Id',text:'Hi I am user 3',createdAt: 1635265755000-3600000,status:types.Status.seen),
      ];}
  }



  void listen(){setState(() {
    updateChatData();
  });}



  @override
  void initState() {
    updateChatData();
    Users().addListener(listen);
    //Users().startConversation(widget.theUser.facebookId,"{type:'text',content:'Dummy message ${DateTime.now().toString()}'}");
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
        user: _mockUsersInChat.length ==0? dummyUser2:_mockUsersInChat[1],
          showUserAvatars:true,
        onSendPressed: (text){},
        messages: _mockMessages,

      ),
    );
  }

  @override
  void dispose() {
    Users().removeListener(listen);
    super.dispose();
  }
}
