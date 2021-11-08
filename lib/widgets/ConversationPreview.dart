import 'package:flutter/material.dart';

class ConversationPreview extends StatefulWidget{
  final String name;
  final String messageText;
  final String imageUrl;
  final bool isMessageRead;
  ConversationPreview({required this.name,required this.messageText,required this.imageUrl,required this.isMessageRead});
  @override
  _ConversationPreviewState createState() => _ConversationPreviewState();
}

class _ConversationPreviewState extends State<ConversationPreview> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: AssetImage(widget.imageUrl),
                  maxRadius: 30,
                ),
                SizedBox(width: 16,),
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(widget.name, style: TextStyle(fontSize: 16),),
                        SizedBox(height: 6,),
                        Text(widget.messageText,style: TextStyle(fontSize: 13,color: Colors.grey.shade600, fontWeight: widget.isMessageRead?FontWeight.bold:FontWeight.normal),),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}