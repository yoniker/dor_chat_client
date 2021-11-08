import 'package:dor_chat_client/models/chatData.dart';
import 'package:dor_chat_client/models/infoConversation.dart';
import 'package:dor_chat_client/models/infoMessage.dart';
import 'package:dor_chat_client/models/infoUser.dart';
import 'package:dor_chat_client/widgets/ConversationPreview.dart';
import 'package:dor_chat_client/widgets/profileDisplay.dart';
import 'package:flutter/material.dart';

class ConversationsWidget extends StatefulWidget {
  const ConversationsWidget({Key? key}) : super(key: key);

  @override
  _ConversationsWidgetState createState() => _ConversationsWidgetState();
}

class _ConversationsWidgetState extends State<ConversationsWidget> {
  @override
  Widget build(BuildContext context) {
    List<InfoConversation> conversations = ChatData().conversations;
    return Expanded(
      flex: 1,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: conversations.length,
        shrinkWrap: true,
        padding: EdgeInsets.only(top: 16),
        itemBuilder: (context, index){
          InfoConversation conversation = conversations[index];
          InfoMessage lastMessage = conversation.messages[0];
          InfoUser collocutor = ChatData().getUserById(ChatData().getCollocutorId(conversation))!;
          bool messageWasRead = ChatData().conversationRead(conversation);
          return
            GestureDetector(
                onTap: (){
                  print('tapped!!');
                  },
                child:
                ConversationPreview(
                  messageText: lastMessage.toUiMessage().text,
                  imageUrl: collocutor.imageUrl,
                  isMessageRead: messageWasRead,
                  name:collocutor.name.split(' ')[0],
                ));
        },
      ),
    );
  }
}
