import 'package:dor_chat_client/models/users_model.dart';
import 'package:flutter/material.dart';
import 'package:dor_chat_client/widgets/global_widgets.dart';


class ProfileDisplay extends StatelessWidget {
  const ProfileDisplay(this.userInfo,{this.onTap,Key? key}) : super(key: key);
  final InfoUser userInfo;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        onTap?.call();
      },
      child: Container(
        margin: EdgeInsets.all(5.0),
        child: Column(
          children:
            [ProfileImageAvatar.network(url:userInfo.imageUrl,radius: 60,),
            Text(userInfo.name)
            ]
        ),
      ),
    );
  }
}
