import 'package:dor_chat_client/models/chatData.dart';
import 'package:dor_chat_client/models/infoConversation.dart';
import 'package:dor_chat_client/models/infoMessage.dart';
import 'package:dor_chat_client/models/infoUser.dart';
import 'package:dor_chat_client/screens/chatScreen.dart';
import 'package:flutter/material.dart';

class ConversationsPreviewWidget extends StatefulWidget {
  const ConversationsPreviewWidget({Key? key}) : super(key: key);

  @override
  _ConversationsPreviewWidgetState createState() => _ConversationsPreviewWidgetState();
}

class _ConversationsPreviewWidgetState extends State<ConversationsPreviewWidget> {
  List<InfoConversation> conversations = ChatData().conversations;

  void listenConversations(){setState(() {
    conversations = ChatData().conversations;
  });}

  @override
  void initState() {
    ChatData().addListener(listenConversations);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(decoration: BoxDecoration(color:Colors.white,borderRadius:BorderRadius.only(
        topLeft: Radius.circular(30.0),
        topRight: Radius.circular(30.0),

      ) ),
      child: ClipRRect(
          borderRadius:BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        child: ListView.builder(
          itemCount: conversations.length,
            itemBuilder: (context,index){
          InfoConversation conversation = conversations[index];
          InfoMessage lastMessage = conversation.messages[0];
    InfoUser? collocutor = ChatData().getUserById(ChatData().getCollocutorId(conversation));
    bool messageWasRead = ChatData().conversationRead(conversation);
          return GestureDetector(
            onTap: (){
              if(collocutor!=null){
              Navigator.pushNamed(
                context, ChatScreen.routeName, arguments: ChatScreenArguments(collocutor));}},
            child: Container(
              decoration: BoxDecoration(color:messageWasRead?Colors.white :Color(0xFFFFEFEE),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0))
              ),
              margin: EdgeInsets.only(top:5.0,bottom:5.0,right:20.0),
              padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(radius:35.0,backgroundImage: NetworkImage(
                          collocutor!=null?
                          collocutor.imageUrl:''),),
                      SizedBox(width: 10.0,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: Text(lastMessage.toUiMessage().text,style: TextStyle(
                              color: Colors.blueGrey,fontSize: 15.0,fontWeight: FontWeight.w600,
                              overflow: TextOverflow.ellipsis,
                            )),
                          ),
                          SizedBox(height: 5.0,),
                          Text(collocutor!=null?collocutor.name.split(' ')[0]:'',style: TextStyle(
                            color: Colors.grey,fontSize: 15.0,fontWeight: FontWeight.bold,
                          ),),
                        ],
                      ),
                    ],
                  ),
                  if (!messageWasRead) Container(
                      width: 40,
                      height: 20,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.0),color: Colors.red),
                      alignment: Alignment.center,
                      child:Text('NEW',style: TextStyle(color: Colors.white,fontSize: 12.0,fontWeight: FontWeight.bold),)),
                ],
              ),
            ),
          );
    }),
      ),
      ),
    );
  }

  @override
  void dispose() {
    ChatData().removeListener(listenConversations);
    super.dispose();
  }
}
