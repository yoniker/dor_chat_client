import 'package:dor_chat_client/models/settings_model.dart';
import 'package:dor_chat_client/screens/mainScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);
  static const String routeName = '/signin_screen';

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  TextEditingController textEditingController = TextEditingController(

  );


  void signInListener(){
    if (SettingsData().registered==true){ //TODO login/registeration status
      Navigator.pushReplacementNamed(
          context, MainScreen.routeName);
    }
  }



  Future<void> facebookSignIn()async{
    final LoginResult result = await FacebookAuth.instance.login(); // by default we request the email and the public profile
// or FacebookAuth.i.login()
    if (result.status == LoginStatus.success) {
      // you are logged
      final AccessToken accessToken = result.accessToken!;
      final userData = await FacebookAuth.instance.getUserData(fields: "name,email,picture.width(200)",);
      SettingsData().facebookId = userData['id'];
      SettingsData().facebookProfileImageUrl = userData['picture']['data']['url'];
      SettingsData().name = userData['name'];
    } else {
      print(result.status);
      print(result.message);
    }

  }

  @override
  void initState() {
    SettingsData().addListener(signInListener );
    moveOnIfRegistered();
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
            facebookSignIn();
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
      Navigator.pushReplacementNamed(
          context, MainScreen.routeName);
    }

  }

  @override
  void dispose() {
    SettingsData().removeListener(signInListener);
    super.dispose();
  }
}
