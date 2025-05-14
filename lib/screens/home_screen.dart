// screens/home_screen.dart
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'patient_home_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  bool _isLoading = true;
  UserType? _userType;

  @override
  void initState() {
    super.initState();
    _loadUserType();
  }

  Future<void> _loadUserType() async {
    try {
      UserType? userType = await _authService.getCurrentUserType();
      setState(() {
        _userType = userType;
        _isLoading = false;
      });
    } catch (e) {
      print("Error loading user type: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _signOut() async {
    await _authService.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // توجيه المستخدم حسب نوعه
    if (_userType == UserType.patient) {
      return PatientHomeScreen();
    }

    // الواجهة الافتراضية لباقي أنواع المستخدمين
    return _buildDefaultHomeScreen();
  }

  Widget _buildDefaultHomeScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Text("الصفحة الرئيسية"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _signOut,
            tooltip: "تسجيل الخروج",
          ),
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Theme.of(context).colorScheme.secondary,
                      size: 80,
                    ),
                    SizedBox(height: 20),
                    Text(
                      "مرحباً بك في التطبيق",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      _userType == UserType.doctor 
                        ? "مرحباً بك دكتور في الصفحة الرئيسية" 
                        : "مرحباً بك موظف في الصفحة الرئيسية",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildFeatureCard(context, "الملف الشخصي", Icons.person),
                    _buildFeatureCard(context, "الإعدادات", Icons.settings),
                    _buildFeatureCard(context, "الإشعارات", Icons.notifications),
                    _buildFeatureCard(context, "المساعدة", Icons.help),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, String title, IconData icon) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {
          // يمكن إضافة التنقل إلى الصفحات ذات الصلة لاحقًا
        },
        borderRadius: BorderRadius.circular(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}



// // screens/home_screen.dart
// import 'package:flutter/material.dart';
// import '../services/auth_service.dart';

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final AuthService _authService = AuthService();
  
//   void _signOut() async {
//     await _authService.signOut();
//     Navigator.pushReplacementNamed(context, '/login');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("الصفحة الرئيسية"),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: _signOut,
//             tooltip: "تسجيل الخروج",
//           ),
//         ],
//       ),
//       body: Container(
//         padding: EdgeInsets.all(24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             SizedBox(height: 20),
//             Container(
//               width: double.infinity,
//               padding: EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(15),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.1),
//                     spreadRadius: 1,
//                     blurRadius: 5,
//                     offset: Offset(0, 3),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 children: [
//                   Icon(
//                     Icons.check_circle,
//                     color: Theme.of(context).colorScheme.secondary,
//                     size: 80,
//                   ),
//                   SizedBox(height: 20),
//                   Text(
//                     "مرحباً بك في التطبيق",
//                     style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                           color: Theme.of(context).primaryColor,
//                           fontWeight: FontWeight.bold,
//                         ),
//                   ),
//                   SizedBox(height: 10),
//                   Text(
//                     "تم تسجيل دخولك بنجاح",
//                     style: Theme.of(context).textTheme.bodyLarge,
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 30),
//             Expanded(
//               child: GridView.count(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 16,
//                 mainAxisSpacing: 16,
//                 children: [
//                   _buildFeatureCard(context, "الملف الشخصي", Icons.person),
//                   _buildFeatureCard(context, "الإعدادات", Icons.settings),
//                   _buildFeatureCard(context, "الإشعارات", Icons.notifications),
//                   _buildFeatureCard(context, "المساعدة", Icons.help),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildFeatureCard(BuildContext context, String title, IconData icon) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: InkWell(
//         onTap: () {
//           // يمكن إضافة التنقل إلى الصفحات ذات الصلة لاحقًا
//         },
//         borderRadius: BorderRadius.circular(15),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               icon,
//               size: 40,
//               color: Theme.of(context).primaryColor,
//             ),
//             SizedBox(height: 12),
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }