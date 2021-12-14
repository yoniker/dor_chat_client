import 'package:dor_chat_client/models/infoMessage.dart';
import 'package:dor_chat_client/models/infoUser.dart';
import 'package:dor_chat_client/models/settings_model.dart';
import 'package:dor_chat_client/models/chatData.dart';
import 'package:dor_chat_client/screens/chatScreen.dart';
import 'package:dor_chat_client/utils/mixins.dart';
import 'package:dor_chat_client/widgets/conversations_preview_widget.dart';
import 'package:dor_chat_client/widgets/contacts_widget.dart';
import 'package:dor_chat_client/widgets/custom_app_bar.dart';
import 'package:dor_chat_client/widgets/global_widgets.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  static const String routeName = '/main_screen';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with MountedStateMixin {
  void listen(){setStateIfMounted(() {});}

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
      if(sender!=null && mounted){
      navigator!.pushNamed(
           ChatScreen.routeName, arguments: sender);}
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
      backgroundColor: Theme.of(context).primaryColor,
      appBar: CustomAppBar(
        hasBackButton: false,
          hasTopPadding:true,
        customTitle:Row(
          children: [
            ProfileImageAvatar.network(url:SettingsData().facebookProfileImageUrl),
            Text(SettingsData().name)
          ],
        ),

      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(color:Theme.of(context).colorScheme.secondary,borderRadius:BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),

              ) ),

              child: Column(
                children: [
                  ContactsWidget(),
                  ConversationsPreviewWidget(),
                ],
              ),
            ),
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
