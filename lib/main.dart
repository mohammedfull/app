
// main.dart
import 'package:flutter/material.dart';
import 'screens/sign_up_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'utils/theme.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'بطاقة المريض',
      theme: AppTheme.lightTheme,
      locale: Locale('ar', 'SA'),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('ar', 'SA'), // العربية
      ],
      initialRoute: '/login',
      routes: {
        '/signup': (context) => SignUpScreen(),
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
      },
      // إضافة onGenerateRoute للتعامل مع الانتقالات
      onGenerateRoute: (settings) {
        // التأكد من معالجة جميع المسارات
        if (settings.name == '/login') {
          return MaterialPageRoute(builder: (context) => LoginScreen());
        } else if (settings.name == '/home') {
          return MaterialPageRoute(builder: (context) => HomeScreen());
        } else if (settings.name == '/signup') {
          return MaterialPageRoute(builder: (context) => SignUpScreen());
        }
        // مسار افتراضي في حالة عدم وجود مسارات مطابقة
        return MaterialPageRoute(builder: (context) => LoginScreen());
      },
    );
  }
}



// // main.dart
// import 'package:flutter/material.dart';
// import 'screens/sign_up_screen.dart';
// import 'screens/login_screen.dart';
// import 'screens/home_screen.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'utils/theme.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: AppTheme.lightTheme,
//       initialRoute: '/signup',
//       routes: {
//         '/signup': (context) => SignUpScreen(),
//         '/login': (context) => LoginScreen(),
//         '/home': (context) => HomeScreen(),
//       },
//     );
//   }
// }

// // import 'package:flutter/material.dart';
// // import 'screens/sign_up_screen.dart';
// // import 'package:firebase_core/firebase_core.dart';

// // void main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   await Firebase.initializeApp();
// //   runApp(MyApp());
// // }

// // class MyApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       home: SignUpScreen(),
// //     );
// //   }
// // }
