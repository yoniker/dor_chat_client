import 'package:auth_buttons/auth_buttons.dart';
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
  bool _errorTryingToLogin=false;
  String? _errorMessage;


  void signInListener(){
    if (SettingsData().registered==true){ //TODO login/registeration status
      Navigator.pushReplacementNamed(
          context, MainScreen.routeName);
    }
  }



  Future<void> facebookSignIn()async{
    final LoginResult loginResult = await FacebookAuth.instance.login(); // by default we request the email and the public profile
    switch (loginResult.status) {
      case LoginStatus.success:
        final AccessToken accessToken = loginResult.accessToken!;
        final userData = await FacebookAuth.instance.getUserData(
          fields: "name,email,picture.width(200)",
        );
        SettingsData().name = userData['name'];
        SettingsData().facebookId = userData['id'];
        SettingsData().facebookProfileImageUrl =
        userData['picture']['data']['url'];
        break;

      case LoginStatus.cancelled:
        setState(() {
          _errorTryingToLogin = true;
          _errorMessage = 'User cancelled Login';
        });
        break;
      case LoginStatus.operationInProgress:
      case LoginStatus.failed:
        setState(() {
          _errorTryingToLogin = true;
          _errorMessage = loginResult.message ?? 'Error trying to login';
        });
        break;
    }
  }



  @override
  void initState() {
    SettingsData().addListener(signInListener);
    moveOnIfRegistered();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FacebookAuthButton(onPressed: (){
                facebookSignIn();
                String value = textEditingController.value.text;
                print(SettingsData().fcmToken);
                print(value);
                if(value.length>0){
                  SettingsData().facebookId = value;
                  SettingsData().facebookProfileImageUrl = 'https://picsum.photos/id/$value/200/300';
                  SettingsData().name = 'User$value';

                }
          }, ),

                _errorTryingToLogin
                    ? TextButton(
                    child: Text('❗'),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                              title: Text("Error"),
                              content: Text(_errorMessage ??
                                  "Error when trying to login"),
                            );
                          },
                          barrierDismissible: true);
                    })
                    : Container()
              ],
            ),
            Text(
              "Don't worry, we only ask for your public profile.",
              style: TextStyle(
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            Text('We never post to Facebook.',
                style: TextStyle(
                  color: Colors.grey,
                )),
            GestureDetector(
              child: Container(
                child: Text('What does public profile mean?',
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline)),
              ),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: Text("Public Profile Info"),
                        content: Text(
                            "Public Profile includes just your name and profile picture. This information is literally available to anyone in the world."),
                      );
                    },
                    barrierDismissible: true);
              },
            )
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



