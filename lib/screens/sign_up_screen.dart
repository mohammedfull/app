// screens/sign_up_screen.dart
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../utils/validators.dart';
import '../widgets/custom_text_field.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      String? error = await AuthService().signUpWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        username: _usernameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
      );

      setState(() => _isLoading = false);

      if (error == null) {
        // تأكد من عرض رسالة النجاح
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("تم التسجيل بنجاح ✅"),
            backgroundColor: Theme.of(context).colorScheme.secondary,
            duration: Duration(seconds: 2),
          ),
        );
        
        // تأخير قصير لظهور رسالة النجاح قبل الانتقال
        Future.delayed(Duration(seconds: 1), () {
          // استخدام pushNamedAndRemoveUntil لحذف الشاشات السابقة من المكدس
          Navigator.pushNamedAndRemoveUntil(
            context, 
            '/login', 
            (Route<dynamic> route) => false
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("خطأ: $error ❌"),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 40),
                  Text(
                    "إنشاء حساب جديد",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "قم بملء البيانات التالية لإنشاء حسابك",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        ),
                  ),
                  SizedBox(height: 40),
                  CustomTextField(
                    controller: _usernameController,
                    labelText: "اسم المستخدم",
                    validator: Validators.validateUsername,
                    prefixIcon: Icons.person,
                  ),
                  CustomTextField(
                    controller: _emailController,
                    labelText: "البريد الإلكتروني",
                    validator: Validators.validateEmail,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email,
                  ),
                  CustomTextField(
                    controller: _phoneController,
                    labelText: "رقم الهاتف",
                    validator: Validators.validatePhone,
                    keyboardType: TextInputType.phone,
                    prefixIcon: Icons.phone,
                  ),
                  CustomTextField(
                    controller: _passwordController,
                    labelText: "كلمة المرور",
                    validator: Validators.validatePassword,
                    obscureText: _obscurePassword,
                    prefixIcon: Icons.lock,
                    suffixIcon: _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    onSuffixIconPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  SizedBox(height: 30),
                  _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: _signUp,
                          child: Text(
                            "إنشاء حساب",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("لديك حساب بالفعل؟"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        child: Text(
                          "تسجيل الدخول",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import '../services/auth_service.dart';

// class SignUpScreen extends StatefulWidget {
//   @override
//   _SignUpScreenState createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();

//   bool _isLoading = false;

//   void _signUp() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() => _isLoading = true);

//       String? error = await AuthService().signUpWithEmail(
//         email: _emailController.text.trim(),
//         password: _passwordController.text.trim(),
//         username: _usernameController.text.trim(),
//         phoneNumber: _phoneController.text.trim(),
//       );

//       setState(() => _isLoading = false);

//       if (error == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("تم التسجيل بنجاح ✅")),
//         );
//         Navigator.pop(context); // الرجوع إلى الصفحة السابقة
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("خطأ: $error ❌")),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("تسجيل حساب جديد")),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: _usernameController,
//                 decoration: InputDecoration(labelText: "اسم المستخدم"),
//                 validator: (value) => value!.isEmpty ? "أدخل اسم المستخدم" : null,
//               ),
//               TextFormField(
//                 controller: _emailController,
//                 decoration: InputDecoration(labelText: "البريد الإلكتروني"),
//                 validator: (value) => value!.contains("@") ? null : "أدخل بريدًا صحيحًا",
//               ),
//               TextFormField(
//                 controller: _phoneController,
//                 decoration: InputDecoration(labelText: "رقم الهاتف"),
//                 keyboardType: TextInputType.phone,
//                 validator: (value) => value!.length < 10 ? "رقم الهاتف غير صالح" : null,
//               ),
//               TextFormField(
//                 controller: _passwordController,
//                 decoration: InputDecoration(labelText: "كلمة المرور"),
//                 obscureText: true,
//                 validator: (value) => value!.length < 6 ? "كلمة المرور ضعيفة" : null,
//               ),
//               SizedBox(height: 20),
//               _isLoading
//                   ? CircularProgressIndicator()
//                   : ElevatedButton(
//                 onPressed: _signUp,
//                 child: Text("إنشاء حساب"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
