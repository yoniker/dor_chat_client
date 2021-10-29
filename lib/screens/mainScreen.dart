import 'package:dor_chat_client/models/infoMessage.dart';
import 'package:dor_chat_client/models/infoUser.dart';
import 'package:dor_chat_client/models/settings_model.dart';
import 'package:dor_chat_client/models/chatData.dart';
import 'package:dor_chat_client/screens/chatScreen.dart';
import 'package:dor_chat_client/widgets/custom_app_bar.dart';
import 'package:dor_chat_client/widgets/global_widgets.dart';
import 'package:dor_chat_client/widgets/profileDisplay.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  static const String routeName = '/main_screen';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  void listen(){setState(() {

  });}

  void getUsers(){
    ChatData().addListener(listen);
    ChatData().getUsersFromServer();
    return;
  }


  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message){
    final InfoMessage messageReceived = InfoMessage.fromJson(message.data);
    ChatData().addMessageToDB(messageReceived);
    if(messageReceived.userId != SettingsData().facebookId) {
      InfoUser? sender = ChatData().getUserById(messageReceived.userId);
      if(sender!=null){
      Navigator.pushNamed(
          context, ChatScreen.routeName, arguments: ChatScreenArguments(sender));}
    }
  }




  @override
  void initState() {
    getUsers();
    setupInteractedMessage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        hasBackButton: false,
          hasTopPadding:true,
        customTitle:Row(
          children: [
            ProfileImageAvatar.network(url:SettingsData().facebookProfileImageUrl),
            Text(SettingsData().facebookId)
          ],
        ),

      ),
      body: Column(
        children: [
          Container(height: 20,),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
              ChatData().users.map((e) => ProfileDisplay(e,onTap: (){
                //Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(e)));
                Navigator.pushNamed(context,ChatScreen.routeName,arguments: ChatScreenArguments(e));
              },radius: 50,)).toList()
            ,),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    ChatData().removeListener(listen);
    super.dispose();
  }
}
