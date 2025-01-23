import 'dart:io';
import 'package:day_task/core/styling/app_assets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AvatarWithAdd extends StatefulWidget {
  const AvatarWithAdd({super.key});

  @override
  State<AvatarWithAdd> createState() => _AvatarWithAddState();
}

class _AvatarWithAddState extends State<AvatarWithAdd> {
  File? _image;
  String? _downloadUrl;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    _currentUser = _auth.currentUser;
    if (_currentUser != null) {
      await _getImageFromFirebase();
    }
  }

  Future<void> _pickImage() async {
    if (_currentUser == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('يجب تسجيل الدخول أولاً')),
        );
      }
      return;
    }

    PermissionStatus status = await Permission.photos.request();

    if (status.isGranted) {
      final picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });

        await _uploadImageToFirebase(pickedFile);
      }
    } else if (status.isDenied) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('لم يتم منح الأذونات للوصول إلى الصور.')),
        );
      }
    } else if (status.isPermanentlyDenied) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('الأذونات تم رفضها بشكل دائم. يرجى تمكين الأذونات من الإعدادات.'),
          ),
        );
      }
      openAppSettings();
    }
  }

  Future<void> _uploadImageToFirebase(XFile pickedFile) async {
    try {
      if (_currentUser == null) return;

      String fileName = '${_currentUser!.uid}_profile_picture';
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('profile_pictures/$fileName');

      UploadTask uploadTask = storageReference.putFile(File(pickedFile.path));
      await uploadTask;

      String downloadUrl = await storageReference.getDownloadURL();
      
      await _currentUser!.updatePhotoURL(downloadUrl);
      
      if (mounted) {
        setState(() {
          _downloadUrl = downloadUrl;
        });
      }

      print("تم تحميل الصورة بنجاح! الرابط: $_downloadUrl");
    } catch (e) {
      print("خطأ في رفع الصورة: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('حدث خطأ أثناء رفع الصورة')),
        );
      }
    }
  }

  Future<void> _getImageFromFirebase() async {
    try {
      if (_currentUser == null) return;

      if (_currentUser!.photoURL != null) {
        if (mounted) {
          setState(() {
            _downloadUrl = _currentUser!.photoURL;
          });
          return;
        }
      }

      String fileName = '${_currentUser!.uid}_profile_picture';
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('profile_pictures/$fileName');
          
      String downloadUrl = await storageReference.getDownloadURL();
      if (mounted) {
        setState(() {
          _downloadUrl = downloadUrl;
        });
      }
    } catch (e) {
      print("خطأ في جلب الصورة من Firebase: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xffFED36A),
                width: 4,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF212832),
                  width: 4,
                ),
              ),
              child: SizedBox(
                width: 127.w,
                height: 127.h,
                child: ClipOval(
                  child: InkWell(
                    onTap: _pickImage,
                    child: _currentUser == null
                        ? Image.asset(
                            AppAssets.profileImage,
                            fit: BoxFit.cover,
                          )
                        : _downloadUrl != null
                            ? Image.network(
                                _downloadUrl!,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes!
                                          : null,
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    AppAssets.profileImage,
                                    fit: BoxFit.cover,
                                  );
                                },
                              )
                            : Image.asset(
                                AppAssets.profileImage,
                                fit: BoxFit.cover,
                              ),
                  ),
                ),
              ),
            ),
          ),
          if (_currentUser != null)
            Positioned(
              bottom: 1,
              right: 1,
              child: SizedBox(
                width: 50.w,
                height: 50.h,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF212832),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: SizedBox(
                        width: 28.w,
                        height: 28.h,
                        child: SvgPicture.asset(
                          AppAssets.plusIcon,
                          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}