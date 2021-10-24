import 'package:dor_chat_client/models/settings_model.dart';
import 'package:dor_chat_client/models/users_model.dart';
import 'package:dor_chat_client/screens/chatScreen.dart';
import 'package:dor_chat_client/widgets/custom_app_bar.dart';
import 'package:dor_chat_client/widgets/global_widgets.dart';
import 'package:dor_chat_client/widgets/profileDisplay.dart';
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
    Users().addListener(listen);
    Users().updateUsers();
    return;
  }

  @override
  void initState() {
    getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        hasBackButton: false,
          hasTopPadding:true,
        customTitle:ProfileImageAvatar.network(url:SettingsData().facebookProfileImageUrl),

      ),
      body: Column(
        children: [
          Container(height: 20,),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
              Users().users.map((e) => ProfileDisplay(e,onTap: (){
                //Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(e)));
                Navigator.pushNamed(context,ChatScreen.routeName,arguments: ChatScreenArguments(e));
              },)).toList()
            ,),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    Users().removeListener(listen);
    super.dispose();
  }
}
