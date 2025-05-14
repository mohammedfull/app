// screens/patient_home_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class PatientHomeScreen extends StatefulWidget {
  @override
  _PatientHomeScreenState createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  final AuthService _authService = AuthService();
  String? _username;
  String? _patientId;
  String _healthStatus = "مستقر";
  Color _statusColor = Colors.green;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      // الحصول على معلومات المستخدم الحالي
      User? currentUser = _authService.currentUser;
      if (currentUser != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            _username = userDoc['username'];
            _patientId = userDoc.id.substring(0, 8).toUpperCase();
            
            // محاكاة حالة صحية مختلفة للعرض
            final random = DateTime.now().second % 3;
            if (random == 0) {
              _healthStatus = "جيد";
              _statusColor = Colors.green;
            } else if (random == 1) {
              _healthStatus = "متوسط";
              _statusColor = Colors.amber;
            } else {
              _healthStatus = "يحتاج متابعة";
              _statusColor = Colors.red;
            }
            
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error loading user data: $e');
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text("بطاقة المريض"),
          leading: IconButton(
            icon: Icon(Icons.logout),
            onPressed: _signOut,
            tooltip: "تسجيل الخروج",
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                // التنقل إلى شاشة الإشعارات
              },
              tooltip: "الإشعارات",
            ),
          ],
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _loadUserData,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPatientHeader(),
                      SizedBox(height: 20),
                      _buildLastVisitCard(),
                      SizedBox(height: 16),
                      _buildLastPrescriptionCard(),
                      SizedBox(height: 16),
                      _buildLastTestCard(),
                      SizedBox(height: 16),
                      _buildNotificationsCard(),
                    ],
                  ),
                ),
              ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _buildPatientHeader() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Text(
                    _username != null && _username!.isNotEmpty
                        ? _username![0].toUpperCase()
                        : "؟",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "مرحبًا، ${_username ?? 'مريض'}",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "رقم البطاقة: ${_patientId ?? '00000000'}",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "الحالة الصحية العامة:",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: _statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      _healthStatus,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _statusColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLastVisitCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_today, color: Theme.of(context).primaryColor),
                SizedBox(width: 8),
                Text(
                  "آخر زيارة طبية",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Divider(),
            _buildInfoRow(Icons.local_hospital, "المستشفى", "مستشفى الملك فهد التخصصي"),
            _buildInfoRow(Icons.person, "الطبيب المعالج", "د. محمد العمري"),
            _buildInfoRow(Icons.date_range, "التاريخ", "10 مايو 2025"),
            _buildInfoRow(Icons.description, "التشخيص", "التهاب القصبات الهوائية"),
          ],
        ),
      ),
    );
  }

  Widget _buildLastPrescriptionCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.medication, color: Theme.of(context).primaryColor),
                SizedBox(width: 8),
                Text(
                  "آخر وصفة طبية",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Divider(),
            _buildInfoRow(Icons.medical_services, "الدواء", "Amoxicillin"),
            _buildInfoRow(Icons.hourglass_bottom, "الجرعة", "500mg مرتين يوميًا"),
            _buildInfoRow(Icons.date_range, "التاريخ", "10 مايو 2025"),
            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  "الحالة: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text("تم صرف الدواء ✔️"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLastTestCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.science, color: Theme.of(context).primaryColor),
                SizedBox(width: 8),
                Text(
                  "آخر فحص طبي",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Divider(),
            _buildInfoRow(Icons.healing, "نوع الفحص", "تحليل دم شامل"),
            _buildInfoRow(Icons.date_range, "التاريخ", "8 مايو 2025"),
            Row(
              children: [
                Icon(Icons.done_all, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  "الحالة: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text("النتيجة متوفرة 📥"),
              ],
            ),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(Icons.visibility),
                label: Text("عرض النتيجة"),
                onPressed: () {
                  // عرض نتائج الفحص
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.notifications_active, color: Theme.of(context).primaryColor),
                    SizedBox(width: 8),
                    Text(
                      "الإشعارات الجديدة",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "3",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Divider(),
            _buildNotificationItem(
              "تمت إضافة تقرير جديد إلى ملفك",
              "منذ 3 ساعات",
            ),
            Divider(height: 1),
            _buildNotificationItem(
              "موعد مراجعتك القادم يوم الإثنين 20/5/2025",
              "منذ يوم",
            ),
            Divider(height: 1),
            _buildNotificationItem(
              "نتائج فحصك جاهزة الآن",
              "منذ يومين",
            ),
            SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () {
                  // الانتقال إلى كل الإشعارات
                },
                child: Text("عرض كل الإشعارات"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          SizedBox(width: 8),
          Text(
            "$label: ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.grey[800]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(String text, String time) {
    return InkWell(
      onTap: () {
        // الانتقال إلى تفاصيل الإشعار
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(Icons.circle, size: 12, color: Theme.of(context).colorScheme.secondary),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 4),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomAppBar(
      elevation: 8,
      child: Container(
        height: 70,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavBarItem(Icons.folder_shared, "الملف الطبي"),
            _buildNavBarItem(Icons.receipt, "الوصفات الطبية"),
            _buildNavBarItem(Icons.science, "الفحوصات"),
            _buildNavBarItem(Icons.event, "مواعيدي"),
            _buildNavBarItem(Icons.settings, "الإعدادات"),
          ],
        ),
      ),
    );
  }

  Widget _buildNavBarItem(IconData icon, String label) {
    return InkWell(
      onTap: () {
        // التنقل إلى الشاشة المطلوبة
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Theme.of(context).primaryColor),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}