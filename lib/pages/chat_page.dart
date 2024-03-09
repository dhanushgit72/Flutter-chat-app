import 'package:chat_app/components/chat_bubble.dart';
import 'package:chat_app/components/my_textfield.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class ChatPage extends StatefulWidget {
  final String recieverEmail;
  final String recieverID;

   ChatPage({super.key,required this.recieverEmail,required this.recieverID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
   final TextEditingController _messageController=TextEditingController();

   final ChatService  _chatService=ChatService();
   final AuthService _authService=AuthService();

   FocusNode myFocusNode=FocusNode();
   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myFocusNode.addListener(() {
      if(myFocusNode.hasFocus){
        Future.delayed(Duration(milliseconds: 500),()=>scrollDown());
      }
    });
    Future.delayed(Duration(milliseconds: 500),()=>scrollDown());
  }
  @override
  void dispose() {
    // TODO: implement dispose
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  final ScrollController _scrollController=ScrollController();
   void scrollDown(){
     _scrollController.animateTo(_scrollController.position.maxScrollExtent,
         duration: Duration(seconds: 1),
         curve: Curves.fastOutSlowIn);
   }


   void sendMessages()async{
     if(_messageController.text.isNotEmpty){
       await _chatService.sendMessage(widget.recieverID, _messageController.text);
       _messageController.clear();
     }
     scrollDown();
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recieverEmail),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList(),),
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList(){
     String senderID=_authService.getCurrentUser()!.uid;
     return StreamBuilder(stream: _chatService.getMessages(widget.recieverID,senderID),
         builder: (context,snapshot){
       if(snapshot.hasError){
         return Text("Error");
       }
       if(snapshot.connectionState==ConnectionState.waiting){
         return Text("Loading...");
       }
       return ListView(
         controller: _scrollController,
         children: snapshot.data!.docs.map((doc)=>_buildMessageItem(doc)).toList(),
       );
         });

  }

Widget _buildMessageItem(DocumentSnapshot doc){
     Map<String,dynamic>data=doc.data() as Map<String,dynamic>;
     bool isCurrentUser=data['senderID']==_authService.getCurrentUser()!.uid;
     var alignment = isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;
     return Container(
       padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
       child: Row(
         mainAxisAlignment: isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           if (!isCurrentUser) ...[
             CircleAvatar(
               // Display avatar for other users
               child: Text(data['senderEmail'][0].toUpperCase()), // You can change this to display actual avatars
             ),
             SizedBox(width: 8.0), // Add spacing between avatar and message
           ],
           Expanded(
             child: Column(
               crossAxisAlignment: alignment,
               children: [
                 ChatBubble(message: data["message"], isCurrentUser: isCurrentUser),
                 SizedBox(height: 4.0), // Add spacing between messages
               ],
             ),
           ),
           if (isCurrentUser) ...[
             SizedBox(width: 8.0), // Add spacing between message and avatar
             CircleAvatar(
               // Display avatar for current user
               child: Text('You'),
             ),
           ],
         ],
       ),
     );
}
//      return Container(
//          alignment: alignment,
//          child: Column(
//            crossAxisAlignment: !isCurrentUser?CrossAxisAlignment.end:CrossAxisAlignment.start,
//            children: [
//              ChatBubble(message: data["message"], isCurrentUser: isCurrentUser),
//            ],
//          ));
// }

Widget _buildUserInput(){
     return Padding(
       padding: const EdgeInsets.only(bottom: 50.0),
       child: Row(
          children: [
            Expanded(
              child: MyTextField(
                controller: _messageController,
                hintText: "Type a Message", obscureText: false,
                focusNode: myFocusNode,
              ),
            ),
            Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                margin: EdgeInsets.only(right: 25.0),
                child: IconButton(onPressed: sendMessages, icon: Icon(Icons.arrow_upward,color: Colors.white,)))
          ],
       ),
     );
}
}