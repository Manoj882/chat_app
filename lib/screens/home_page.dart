import 'dart:async';

import 'package:chat_app/constants/firestore_constant.dart';
import 'package:chat_app/models/chat_user_model.dart';
import 'package:chat_app/provider/auth_provider.dart';
import 'package:chat_app/provider/home_provider.dart';
import 'package:chat_app/screens/login_page.dart';
import 'package:chat_app/utils/dialog_screen.dart';
import 'package:chat_app/utils/keyboard_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchTextEditingController = TextEditingController();
  final scrollController = ScrollController();
  StreamController<bool> buttonClearController = StreamController<bool>();

  late AuthProvider authProvider;
  late HomeProvider homeProvider;
  late String currrentUserId;

  int _limit = 20;
  final int _limitIncrement = 20;
  String _textSearch = '';
  bool isLoading = false;

  Future<void> googleSignOut() async {
    authProvider.googleSignOut();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }

  Future<bool> onBackPress() {
    DialogScreens().openDialog(context);
    return Future.value(false);
  }

  void scrollListner(){
    if(scrollController.offset >= scrollController.position.maxScrollExtent && !scrollController.position.outOfRange){
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    buttonClearController.close();
  }

  @override
  void initState() {
    super.initState();
    authProvider = context.read<AuthProvider>();
    homeProvider = context.read<HomeProvider>();
    if (authProvider.getFirebaseUserId()?.isNotEmpty == true) {
      currrentUserId = authProvider.getFirebaseUserId()!;
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginPage()),
        (route) => false,
      );
    }
    scrollController.addListener(scrollListner);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Chat App',
        ),
        actions: [
          IconButton(
            onPressed: () {
              googleSignOut();
            },
            icon: Icon(
              Icons.logout_outlined,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.person_outlined,
            ),
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: onBackPress,
        child: Stack(
          children: [
            Column(
              children: [
                buildSearchBar(),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: homeProvider.getFirestoreData(
                        FirestoreConstant.pathUserCollection,
                        _limit,
                        _textSearch),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        if ((snapshot.data?.docs.length ?? 0) > 0) {
                          return ListView.separated(
                            shrinkWrap: true,
                            controller: scrollController,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index){
                              return buildItem(context, snapshot.data!.docs[index]);
                            },
                            separatorBuilder: (context, index){
                              return const Divider();
                            },
                            
                          );
                        } else {
                          return const Center(
                            child: Text('No user found...'),
                          );
                        }
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSearchBar() {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      height: 50,
      child: Row(
        children: [
          Icon(
            Icons.person_search_outlined,
            color: Colors.white,
            size: 24,
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: TextFormField(
              textInputAction: TextInputAction.search,
              controller: searchTextEditingController,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  buttonClearController.add(true);
                  setState(() {
                    _textSearch = value;
                  });
                } else {
                  buttonClearController.add(false);
                  setState(() {
                    _textSearch = '';
                  });
                }
              },
              decoration: InputDecoration.collapsed(
                hintText: 'Search here...',
                hintStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          StreamBuilder(
              stream: buttonClearController.stream,
              builder: (context, snapshot) {
                return snapshot.data == true
                    ? GestureDetector(
                        onTap: () {
                          searchTextEditingController.clear();
                          buttonClearController.add(false);
                          setState(() {
                            _textSearch = '';
                          });
                        },
                        child: Icon(
                          Icons.clear_rounded,
                          color: Colors.grey,
                          size: 20,
                        ),
                      )
                    : SizedBox.shrink();
              }),
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.deepPurpleAccent,
      ),
    );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot documentSnapshot){
    final firebaseAuth = FirebaseAuth.instance;
    if(documentSnapshot != null){
      ChatUser chatUser = ChatUser.fromDocument(documentSnapshot);
      if(chatUser.id == currrentUserId){
        return const SizedBox.shrink();
      } else {
        return TextButton(
          onPressed: (){
            // if(KeyboardUtils.isKeyboardShowing()){
            //   KeyboardUtils.closeKeyboard(context);
            // }
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => ChatPage(
            //               peerId: userChat.id,
            //               peerAvatar: userChat.photoUrl,
            //               peerNickname: userChat.displayName,
            //               userAvatar: firebaseAuth.currentUser!.photoURL!,
            //             )));
          
          }, 
          child: ListTile(
            leading: chatUser.photoUrl.isNotEmpty
            ? ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.network(
                chatUser.photoUrl,
                fit: BoxFit.cover,
                width: 50,
                height: 50,
                loadingBuilder: (BuildContext ctx, Widget child, ImageChunkEvent? loadingProgress){
                  if(loadingProgress == null){
                    return child;
                  } else{
                    return SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(
                        color: Colors.grey,
                        value: loadingProgress.expectedTotalBytes != null 
                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! 
                        : null,
                      ),
                    );
                  }
                },
                errorBuilder: (context, object, stackTree){
                  return const Icon(Icons.account_circle_outlined, size: 50,);
                },

              ),
            )
            : const Icon(
              Icons.account_circle_outlined,
              size: 50,
            ),
            title: Text(
              chatUser.displayName,
              style: TextStyle(color: Colors.black),
            ),
            

          ),
          );
      }
    } else{
      return const SizedBox.shrink(); 
    }
  }
}
