import 'dart:io';

import 'package:dor_chat_client/models/infoConversation.dart';
import 'package:dor_chat_client/models/infoMessage.dart';
import 'package:dor_chat_client/models/infoUser.dart';
import 'package:dor_chat_client/screens/chatScreen.dart';
import 'package:dor_chat_client/screens/mainScreen.dart';
import 'package:dor_chat_client/screens/signInScreen.dart';
import 'package:dor_chat_client/textingApp.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/settings_model.dart';


class MyHttpOverrides extends HttpOverrides {
  //TODO it's a temporary fix so we can use self signed certificates. DON'T USE IN PRODUCTION
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async{
  HttpOverrides.global = new MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(InfoUserAdapter()); //TODO should I initialize Hive within the singleton?
  Hive.registerAdapter(InfoMessageAdapter());
  Hive.registerAdapter(InfoConversationAdapter());

  runApp(MaterialApp(home: App(),onGenerateRoute: _onGenerateRoute,debugShowCheckedModeBanner: false,));
}



Route _onGenerateRoute(RouteSettings settings) {
  if (settings.name == MainScreen.routeName) {
    return MaterialPageRoute(
      settings: settings,
      builder: (context) {
        return MainScreen();
      },
    );
  }

  else if (settings.name == ChatScreen.routeName){
    final args = settings.arguments as ChatScreenArguments;
    return MaterialPageRoute(
      builder: (context) {
        return ChatScreen(args.theUser);
      },
    );
  }

  return MaterialPageRoute(
    settings: settings,
    builder: (context) {
      return SignInScreen();
    },
  );

}

/// We are using a StatefulWidget such that we only create the [Future] once,
/// no matter how many times our widget rebuild.
/// If we used a [StatelessWidget], in the event where [App] is rebuilt, that
/// would re-initialize FlutterFire and make our application re-enter loading state,
/// which is undesired.
class App extends StatefulWidget {
  // Create the initialization Future outside of `build`:
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  /// The future is part of the state of our widget. We should not call `initializeApp`
  /// directly inside [build].
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  Future<void> updateFcmToken()async{

    while(true) {
      try{
      String? token = await FirebaseMessaging.instance.getToken();
      print('Got the token $token');
      if (token != null) {
        await SettingsData().readSettingsFromShared();
        if (SettingsData().fcmToken != token) {
          print('updating fcm token..');
          SettingsData().fcmToken = token;
        }
        return;
      }
    }
    catch(val){
        print('caught $val');
    }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Text('Firebase initialization error');
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          updateFcmToken();
          return SignInScreen();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Text('Loading...');
      },
    );
  }
}