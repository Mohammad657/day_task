import 'package:day_task/core/routing/app_routes.dart';
import 'package:day_task/core/styling/app_assets.dart';
import 'package:day_task/core/styling/app_colors.dart';
import 'package:day_task/core/widgets/primary_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class PrivateChatScreen extends StatefulWidget {
  final String chatId;
  final String recipientId;
  final String recipientName;

  const PrivateChatScreen({
    Key? key,
    required this.chatId,
    required this.recipientId,
    required this.recipientName,
  }) : super(key: key);

  @override
  PrivateChatScreenState createState() => PrivateChatScreenState();
}

class PrivateChatScreenState extends State<PrivateChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final CollectionReference _messagesCollection =
      FirebaseFirestore.instance.collection('messages');
  final User? currentUser = FirebaseAuth.instance.currentUser;

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      _messagesCollection.add({
        'chatId': widget.chatId,
        'text': _controller.text,
        'createdAt': Timestamp.now(),
        'senderId': currentUser?.uid,
        'recipientId': widget.recipientId,
      });
      _controller.clear();

      
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => GoRouter.of(context).pushNamed(AppRoutes.createChatPage),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: SvgPicture.asset(AppAssets.arrowBackIcon),
          ),
        ),
        title: Text(
          widget.recipientName,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _messagesCollection
                  .where('chatId', isEqualTo: widget.chatId)
                  .orderBy('createdAt', descending: false) 
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No messages found.'),
                  );
                }

                var messages = snapshot.data!.docs;

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message = messages[index];
                    bool isMe = message['senderId'] == currentUser?.uid;

                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        padding:  EdgeInsets.only(                          top: 12,
                          bottom: 12,
                          left: isMe ? 100 : 10,
                          right: isMe ? 10 : 100,),
                        margin: EdgeInsets.only(
                          top: 8,
                          bottom: 8,
                          left: isMe ? 100 : 10,
                          right: isMe ? 10 : 100,
                        ),
                        decoration: BoxDecoration(
                          color: isMe
                              ? AppColors.primaryColor
                              : const Color(0xff263238),

                        ),
                        child: Text(
                          message['text'],
                          style:  TextStyle(color: isMe?Colors.black : Colors.white  , fontSize: 16),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12 , vertical: 40),
            child: PrimaryTextFieldWidget(
              controller: _controller,
              hintText: 'Type a message',
              suffixIcon: IconButton(
                onPressed: _sendMessage,
                icon: SvgPicture.asset(AppAssets.sendMessageIcon),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
