import 'dart:io';
import 'package:chat_app/constants/color_constants.dart';
import 'package:chat_app/constants/firestore_constant.dart';
import 'package:chat_app/constants/text_field_constants.dart';
import 'package:chat_app/models/chat_user_model.dart';
import 'package:chat_app/provider/profile_provider.dart';
import 'package:chat_app/widgets/loading_view.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController? displayNameController;
  TextEditingController? aboutMeController;
  late TextEditingController  phoneController;

  late String currentUserId;
  String dialCodeDigits = '+00';
  String id = '';
  String displayName = '';
  String aboutMe = '';
  String phoneNumber = '';
  String photoUrl = '';
  

  final focusNodeNickName = FocusNode();

  late ProfileProvider profileProvider;

  File? avatarImageFile;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    profileProvider = context.read<ProfileProvider>();
    readLocal();
  }

  void readLocal() {
    setState(() {
      id = profileProvider.getPrefs(FirestoreConstant.id) ?? '';
      displayName =
          profileProvider.getPrefs(FirestoreConstant.displayName) ?? '';
      photoUrl = profileProvider.getPrefs(FirestoreConstant.photoUrl) ?? '';
      phoneNumber =
          profileProvider.getPrefs(FirestoreConstant.phoneNumber) ?? '';
      aboutMe = profileProvider.getPrefs(FirestoreConstant.aboutMe) ?? '';
    });
    displayNameController = TextEditingController(text: displayName);
    aboutMeController = TextEditingController(text: aboutMe);
    phoneController = TextEditingController(text: phoneNumber);
    
  }

  Future getImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker
        .pickImage(source: ImageSource.gallery)
        .catchError((onError) {
      Fluttertoast.showToast(msg: onError.toString());
    });
    File? image;
    if (pickedFile != null) {
      image = File(pickedFile.path);
    }
    if (image != null) {
      setState(() {
        avatarImageFile = image;
        isLoading = true;
      });
      uploadFile();
    }
  }

  Future uploadFile() async {
    String fileName = id;
    UploadTask uploadTask = profileProvider.uploadImageFile(
      avatarImageFile!,
      fileName,
    );
    try {
      TaskSnapshot snapshot = await uploadTask;
      photoUrl = await snapshot.ref.getDownloadURL();
      ChatUser updateInfo = ChatUser(
        id: id,
        photoUrl: photoUrl,
        displayName: displayName,
        phoneNumber: phoneNumber,
        aboutMe: aboutMe,
      );
      profileProvider
          .updateFirestoreData(
        FirestoreConstant.pathUserCollection,
        id,
        updateInfo.toJson(),
      )
          .then((value) async {
        await profileProvider.setPrefs(
          FirestoreConstant.photoUrl,
          photoUrl,
        );
        setState(() {
          isLoading = false;
        });
      });
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  void updateFirestoreData() {
    focusNodeNickName.unfocus();
    setState(() {
      isLoading = true;
      if (dialCodeDigits != '+00' && phoneController.text != '') {
        phoneNumber = dialCodeDigits + phoneController.text.toString();
      }
    });
    ChatUser updateInfo = ChatUser(
      id: id,
      photoUrl: photoUrl,
      displayName: displayName,
      phoneNumber: phoneNumber,
      aboutMe: aboutMe,
    );
    profileProvider
        .updateFirestoreData(
      FirestoreConstant.pathUserCollection,
      id,
      updateInfo.toJson(),
    )
        .then((value) async {
      await profileProvider.setPrefs(
        FirestoreConstant.displayName,
        displayName,
      );
      await profileProvider.setPrefs(
        FirestoreConstant.phoneNumber,
        phoneNumber,
      );
      await profileProvider.setPrefs(
        FirestoreConstant.photoUrl,
        photoUrl,
      );
      
      await profileProvider.setPrefs(
        FirestoreConstant.aboutMe,
        aboutMe,
      );
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: 'Update Success!!!');
    }).catchError((onError) {
      Fluttertoast.showToast(msg: onError.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: getImage,
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    alignment: Alignment.center,
                    child: avatarImageFile == null
                        ? photoUrl.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: Image.network(
                                  photoUrl,
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.account_circle_outlined,
                                      size: 90,
                                      color: AppColors.greyColor,
                                    );
                                  },
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    }
                                    return SizedBox(
                                      width: 10,
                                      height: 90,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.grey,
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : const Icon(
                                Icons.account_circle_outlined,
                                size: 90,
                                color: AppColors.greyColor,
                              )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: Image.file(
                              avatarImageFile!,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Name',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.spaceCadet,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                TextField(
                  decoration: kTextInputDecoration.copyWith(
                    hintText: 'Write Your Name',
                  ),
                  controller: displayNameController,
                  onChanged: (value) {
                    displayName = value;
                  },
                  focusNode: focusNodeNickName,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'About Me...',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.spaceCadet,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                TextField(
                  controller: aboutMeController,
                  decoration: kTextInputDecoration.copyWith(
                    hintText: 'Write about yourself...',
                  ),
                  onChanged: (value) {
                    aboutMe = value;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Select Country Code',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.spaceCadet,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: CountryCodePicker(
                    onChanged: (country) {
                      setState(() {
                        dialCodeDigits = country.dialCode!;
                      });
                    },
                    initialSelection: '+977',
                    showCountryOnly: false,
                    showOnlyCountryWhenClosed: false,
                    favorite: const ['+1', 'US', 'Nepal', '+977'],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Phone Number',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.spaceCadet,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  maxLength: 14,
                  decoration: kTextInputDecoration.copyWith(
                    hintText: 'Phone Number',
                    prefix: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        dialCodeDigits,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  controller: phoneController,
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: updateFirestoreData,
                    child: const Text(
                      'Update Info',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            child: isLoading ? const LoadingView() : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

