import 'package:day_task/core/features/screen/chat_screen/private_chat/chat_screen.dart';
import 'package:day_task/core/routing/app_routes.dart';
import 'package:day_task/core/styling/app_assets.dart';
import 'package:day_task/core/styling/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:rxdart/rxdart.dart';

class CreateChatPage extends StatelessWidget {
  const CreateChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => GoRouter.of(context).pushNamed(AppRoutes.mainScreen),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: SvgPicture.asset(AppAssets.arrowBackIcon),
          ),
        ),
        title: const Text(
          "Messages",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: StreamBuilder<List<QuerySnapshot>>(
        stream: CombineLatestStream.list([
          FirebaseFirestore.instance
              .collection('messages')
              .where('recipientId', isEqualTo: currentUser?.uid)
              .snapshots(),
          FirebaseFirestore.instance
              .collection('messages')
              .where('senderId', isEqualTo: currentUser?.uid)
              .snapshots(),
        ]),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var messages = [
            ...snapshot.data![0].docs,
            ...snapshot.data![1].docs,
          ];

          var users = messages
              .map((message) {
                String senderId = message['senderId'];
                String recipientId = message['recipientId'];
                return senderId == currentUser?.uid ? recipientId : senderId;
              })
              .toSet()
              .toList();

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var userId = users[index];
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .get(),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData) {
                    return ListTile(
                        title: Text(
                      'Loading...',
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ));
                  }
                  var user = userSnapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      title: Text(
                        user['username'],
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      leading: SizedBox(
                        width: 47.w,
                        height: 47.h,
                        child: CircleAvatar(
                          backgroundImage: AssetImage(AppAssets.profileImage),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PrivateChatScreen(
                              chatId: _getChatId(currentUser!.uid, userId),
                              recipientId: userId,
                              recipientName: user['username'],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: Container(
        width: 175.w,
        height: 75.h,
        color: AppColors.primaryColor,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SelectUserPage(),
              ),
            );
          },
          child: const Center(
              child: Text(
            "Start chat",
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          )),
        ),
      ),
    );
  }

  String _getChatId(String userId1, String userId2) {
    return userId1.hashCode <= userId2.hashCode
        ? '$userId1-$userId2'
        : '$userId2-$userId1';
  }
}

class SelectUserPage extends StatelessWidget {
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
          'Select User to Chat',
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          var users = snapshot.data!.docs;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var user = users[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  title: Text(
                    user['username'],
                   style:
                              const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                    leading: SizedBox(
                          width: 47.w,
                          height: 47.h,
                          child: CircleAvatar(
                            backgroundImage: AssetImage(AppAssets.profileImage),
                          ),
                        ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PrivateChatScreen(
                          chatId: _getChatId(
                              FirebaseAuth.instance.currentUser!.uid, user.id),
                          recipientId: user.id,
                          recipientName: user['username'],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _getChatId(String userId1, String userId2) {
    return userId1.hashCode <= userId2.hashCode
        ? '$userId1-$userId2'
        : '$userId2-$userId1';
  }
}
