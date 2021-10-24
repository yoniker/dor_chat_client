import 'package:dor_chat_client/models/settings_model.dart';
import 'package:dor_chat_client/widgets/custom_app_bar.dart';
import 'package:dor_chat_client/widgets/global_widgets.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  static const String routeName = '/main_screen';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        hasBackButton: false,
          hasTopPadding:true,
        customTitle:ProfileImageAvatar.network(url:SettingsData().facebookProfileImageUrl),

      ),
      body: Text('Scaffold body!'),
    );
  }
}
