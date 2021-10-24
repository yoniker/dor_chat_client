import 'package:dor_chat_client/models/settings_model.dart';
import 'package:dor_chat_client/screens/mainScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  TextEditingController textEditingController = TextEditingController(

  );

  @override
  void initState() {
    moveOnIfRegistered();
    SettingsData().addListener(() {
      if (SettingsData().registered==true){ //TODO login/registeration status
        Navigator.pushNamed(
            context, MainScreen.routeName);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100,
              child:TextField(
                controller: textEditingController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),

          TextButton(onPressed: (){
            String value = textEditingController.value.text;
            print(SettingsData().fcmToken);
            print(value);
            if(value.length>0){
              SettingsData().facebookId = value;
              SettingsData().facebookProfileImageUrl = 'https://picsum.photos/id/$value/200/300';
              SettingsData().name = 'User$value';

            }
          }, child: Text('SignIn'))
        ],),
      ),
    );
  }

  void moveOnIfRegistered() async {
    await SettingsData().readSettingsFromShared();
    if(SettingsData().registered){
      //Move on to next screen
      Navigator.pushNamed(
          context, MainScreen.routeName);

    }

  }
}
