import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class UserProfileService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _currentUser;

  Future<void> getCurrentUser() async {
    _currentUser = _auth.currentUser;
  }

  Future<String?> getImageFromFirebase() async {
    try {
      if (_currentUser == null) return null;

      if (_currentUser!.photoURL != null) {
        return _currentUser!.photoURL;
      }

      String fileName = '${_currentUser!.uid}_profile_picture';
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('profile_pictures/$fileName');

      String downloadUrl = await storageReference.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("خطأ في جلب الصورة من Firebase: $e");
      return null;
    }
  }

  Future<void> pickAndUploadImage() async {
    if (_currentUser == null) {
      throw Exception('يجب تسجيل الدخول أولاً');
    }

    PermissionStatus status = await Permission.photos.request();

    if (status.isGranted) {
      final picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        await uploadImageToFirebase(pickedFile);
      }
    } else if (status.isDenied) {
      throw Exception('لم يتم منح الأذونات للوصول إلى الصور.');
    } else if (status.isPermanentlyDenied) {
      throw Exception('الأذونات تم رفضها بشكل دائم. يرجى تمكين الأذونات من الإعدادات.');
    }
  }

  Future<void> uploadImageToFirebase(XFile pickedFile) async {
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

      print("تم تحميل الصورة بنجاح! الرابط: $downloadUrl");
    } catch (e) {
      print("خطأ في رفع الصورة: $e");
      throw Exception('حدث خطأ أثناء رفع الصورة');
    }
  }

  User? get currentUser => _currentUser;
}
