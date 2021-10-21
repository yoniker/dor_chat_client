import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class TextingApp extends StatelessWidget {
  // This widget is the root of your application.



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SimpleTexts(),
    );
  }
}

class SimpleTexts extends StatefulWidget {
  const SimpleTexts({Key? key}) : super(key: key);


  @override
  _SimpleTextsState createState() => _SimpleTextsState();
}

class _SimpleTextsState extends State<SimpleTexts> {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;


  void setFirebaseEvents(){

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }


  Future<void> sendFCMTokenToServer()async{ //TODO For now print it; In the future I will actually send it to my server..
    String? token = await messaging.getToken();
    print('The token is $token');
  }

  List<String> _textMessages = ['Some initial text'];

  @override
  void initState() {
    sendFCMTokenToServer();
    setFirebaseEvents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: _textMessages.map((text)=>Text(text)).toList(),),
    );
  }
}
