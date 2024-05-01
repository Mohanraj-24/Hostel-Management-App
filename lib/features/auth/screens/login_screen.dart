import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hostel_management/api_services/api_calls.dart';
import 'package:hostel_management/common/spacing.dart';
import 'package:hostel_management/features/auth/screens/register_screen.dart';
import 'package:hostel_management/features/auth/services/auth_service.dart';
import 'package:hostel_management/features/auth/widgets/custom_button.dart';
import 'package:hostel_management/features/auth/widgets/custom_text_field.dart';
import 'package:hostel_management/theme/colors.dart';
import 'package:hostel_management/theme/text_theme.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Center(child: LoginBody()),
    );
  }
}

class LoginBody extends StatefulWidget {
  const LoginBody({
    super.key,
  });

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  static final _formKeyLogin = GlobalKey<FormState>();
  TextEditingController rollNo = TextEditingController();
  TextEditingController password = TextEditingController();
  final AuthService authService = AuthService();
  ApiCall apiCall = ApiCall();
  bool _obscureText = true;
  @override
  void dispose() {
    rollNo.dispose();
    password.dispose();
    super.dispose();
  }

  void signInUser() {
    authService.signInUser(
      rollNo: rollNo.text,
      password: password.text,
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
        child: Form(
          key: _formKeyLogin,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/logo.jpg',
                  height: 250.h,
                ),
              ),
              heightSpacer(30.h),
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'Login to your account',
                  style: TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              heightSpacer(25.h),
              Text('Roll Number', style: AppTextTheme.kLabelStyle),
              CustomTextField(
                controller: rollNo,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Roll Number is required';
                  }
                  // else if (!emailRegex.hasMatch(value)) {
                  //   return 'Invalid email address';
                  // }
                  return null;
                },
                enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                    borderRadius: BorderRadius.circular(14)),
                inputHint: "Enter your roll number",
              ),
              heightSpacer(30),
              Text('Password', style: AppTextTheme.kLabelStyle),
              CustomTextField(
                obscureText: _obscureText,
                controller: password,
                suffixIcon: IconButton(
                  icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Password is required';
                  }
                  return null;
                },
                enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                    borderRadius: BorderRadius.circular(14)),
                inputHint: "Password",
              ),
              heightSpacer(30),
              CustomButton(
                buttonText: "Login",
                press: () async {
                  if (_formKeyLogin.currentState!.validate()) {
                    // await apiCall.handleLogin(
                    //     context, email.text, password.text);
                    // print('validated');
                    signInUser();
                  }
                },
                flag: false,
              ),
              heightSpacer(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don’t have an account?",
                    style: AppTextTheme.kLabelStyle.copyWith(
                      color: AppColors.kGreyDk,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterScreen(),
                        ),
                      );
                    },
                    child: Text(
                      " Register",
                      style: AppTextTheme.kLabelStyle.copyWith(
                        color: AppColors.kGreenColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Future<void> saveTokenToSharedPreferences(String token) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('token', token);
  // }

  // final emailRegex =
  //     RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)*(\.[a-z]{2,})$');
}
