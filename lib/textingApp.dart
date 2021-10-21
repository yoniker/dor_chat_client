import 'dart:async';

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

  Stream<dynamic> createStream(){
    late StreamController<dynamic> controller;
    StreamSubscription? subscription;
    void setFirebaseEvents() {
      if (subscription == null) {
        subscription =
            FirebaseMessaging.onMessage.listen((RemoteMessage message) {
              print('Got a message whilst in the foreground!');
              print('Message data: ${message.data['dor_text']}');

              if (message.notification != null) {
                print('Message also contained a notification: ${message
                    .notification}');
              }
              controller.add(message);
            });
      }
    }
    void unsetFirebaseEvents(){
      if(subscription!=null){
        subscription!.cancel();
        subscription = null;
      }
    }

      controller = StreamController<dynamic>(
          onListen: setFirebaseEvents,
          onPause: unsetFirebaseEvents,
          onResume: setFirebaseEvents,
          onCancel: unsetFirebaseEvents);

      return controller.stream;



  }


  Future<void> sendFCMTokenToServer()async{ //TODO For now print it; In the future I will actually send it to my server..
    String? token = await messaging.getToken();
    print('The token is $token');
  }
  Stream<dynamic>? messagesStream;
  @override
  void initState() {
    sendFCMTokenToServer();
    messagesStream = createStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: //ListView(children: _textMessages.map((text)=>Text(text)).toList(),),
      Center(
        child: StreamBuilder(initialData: 'asd',stream: messagesStream,builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.hasData)  {
            print('dor');
            return Text(snapshot.data);}
          return Text('No data');
        },),
      )
    );
  }
}
