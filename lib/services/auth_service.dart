// services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // الحصول على المستخدم الحالي
  User? get currentUser => _auth.currentUser;

  // تسجيل مستخدم جديد
  Future<String?> signUpWithEmail({
    required String email,
    required String password,
    required String username,
    required String phoneNumber,
  }) async {
    try {
      // إنشاء الحساب باستخدام البريد الإلكتروني وكلمة المرور
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // الحصول على معرف المستخدم (UID)
      String uid = userCredential.user!.uid;

      // حفظ بيانات المستخدم في Firestore
      await _firestore.collection("users").doc(uid).set({
        "username": username,
        "email": email,
        "phone": phoneNumber,
        "uid": uid,
        "createdAt": DateTime.now(),
      });

      return null; // تم التسجيل بنجاح
    } on FirebaseAuthException catch (e) {
      return e.message; // إرجاع رسالة الخطأ
    }
  }

  // تسجيل الدخول
  Future<String?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; // تم تسجيل الدخول بنجاح
    } on FirebaseAuthException catch (e) {
      return e.message; // إرجاع رسالة الخطأ
    }
  }

  // تسجيل الخروج
  Future<void> signOut() async {
    await _auth.signOut();
  }
}


// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // تسجيل مستخدم جديد
//   Future<String?> signUpWithEmail({
//     required String email,
//     required String password,
//     required String username,
//     required String phoneNumber,
//   }) async {
//     try {
//       // إنشاء الحساب باستخدام البريد الإلكتروني وكلمة المرور
//       UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       // الحصول على معرف المستخدم (UID)
//       String uid = userCredential.user!.uid;

//       // حفظ بيانات المستخدم في Firestore
//       await _firestore.collection("users").doc(uid).set({
//         "username": username,
//         "email": email,
//         "phone": phoneNumber,
//         "uid": uid,
//         "createdAt": DateTime.now(),
//       });

//       return null; // تم التسجيل بنجاح
//     } on FirebaseAuthException catch (e) {
//       return e.message; // إرجاع رسالة الخطأ
//     }
//   }
// }
