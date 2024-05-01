import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hostel_management/api_services/api_calls.dart';
import 'package:hostel_management/common/spacing.dart';
import 'package:hostel_management/features/auth/services/auth_service.dart';
import 'package:hostel_management/features/auth/widgets/custom_button.dart';
import 'package:hostel_management/features/auth/widgets/custom_text_field.dart';
import 'package:hostel_management/theme/colors.dart';
import 'package:hostel_management/theme/text_theme.dart';

import 'dart:io' show Platform;
import 'dart:async';
import 'dart:math';
import 'package:facesdk_plugin/facesdk_plugin.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
// import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hostel_management/person.dart';
import 'package:hostel_management/personview.dart';
import 'package:hostel_management/facedetectionview.dart';

import 'package:hostel_management/dbhelper.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});
  var personList = <Person>[];

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  static final GlobalKey<FormState> _formKeyRegister = GlobalKey<FormState>();
  final DatabaseHelper _dbhelper = DatabaseHelper();

  String _warningState = "";
  bool _visibleWarning = false;
  final _facesdkPlugin = FacesdkPlugin();
  bool flag = false;

  TextEditingController rollNo = TextEditingController();
  TextEditingController userName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  ApiCall apiCall = ApiCall();
  final AuthService authService = AuthService();
  String? validationMessage;

  String? selectedBlock;
  String? selectedRoom;

  List<String> blockOptions = ['A', 'B'];
  List<String> roomOptionsA = ['101', '102', '103'];
  List<String> roomOptionsB = ['201', '202', '203'];
  List<String> faceData = [];

  @override
  void dispose() {
    email.dispose();
    firstName.dispose();
    lastName.dispose();
    phoneNumber.dispose();
    password.dispose();
    super.dispose();
  }

  void signUpUser() {
    authService.signUp(
      rollNo: rollNo.text,
      firstName: firstName.text,
      lastName: lastName.text,
      email: email.text,
      password: password.text,
      context: context,
      phoneNumber: phoneNumber.text,
      block: selectedBlock.toString(),
      roomNo: selectedRoom.toString(),
      faceData1: faceData[0],
      faceData2: faceData[1],
      faceData3: faceData[2],
    );
  }

  @override
  void initState() {
    super.initState();

    init();
  }

  Future<void> init() async {
    int facepluginState = -1;
    String warningState = "";
    bool visibleWarning = false;

    try {
      if (Platform.isAndroid) {
        await _facesdkPlugin
            .setActivation(
                "CFO+UUpNLaDMlmdjoDlhBMbgCwT27CzQJ4xHpqe9rDOErwoEUeCGPRTfQkZEAFAFdO0+rTNRIwnQwpqqGxBbfnLkfyFeViVS5bpWZFk15QXP3ZtTEuU1rK5zsFwcZrqRUxsG9dXImc+Vw5Ddc9zBp9GEUuDycHLqC9KgQGVb0TS2u9Kz67HQOSDw9hskjBpjRbqiG+F/h5DBLPzjgFh1Y6vzgg6I59FzTOcdrdEbX7kI15Nwgf1hvHGtSgON/a0Fmw+XNdnxH2pVY96mcTemHYZAtxh8lA/t1DtTyZXpHjW8N6nq4UN2YDlKLXSrDzLpLHJmBsdpH71AXb7dfAq94Q==")
            .then((value) => facepluginState = value ?? -1);
      } else {
        await _facesdkPlugin
            .setActivation(
                "nWsdDhTp12Ay5yAm4cHGqx2rfEv0U+Wyq/tDPopH2yz6RqyKmRU+eovPeDcAp3T3IJJYm2LbPSEz"
                "+e+YlQ4hz+1n8BNlh2gHo+UTVll40OEWkZ0VyxkhszsKN+3UIdNXGaQ6QL0lQunTwfamWuDNx7Ss"
                "efK/3IojqJAF0Bv7spdll3sfhE1IO/m7OyDcrbl5hkT9pFhFA/iCGARcCuCLk4A6r3mLkK57be4r"
                "T52DKtyutnu0PDTzPeaOVZRJdF0eifYXNvhE41CLGiAWwfjqOQOHfKdunXMDqF17s+LFLWwkeNAD"
                "PKMT+F/kRCjnTcC8WPX3bgNzyUBGsFw9fcneKA==")
            .then((value) => facepluginState = value ?? -1);
      }

      if (facepluginState == 0) {
        await _facesdkPlugin
            .init()
            .then((value) => facepluginState = value ?? -1);
      }
    } catch (e) {}

    List<Person> personList = await _dbhelper.loadAllPersons();
    // await SettingsPageState.initSettings();

    final prefs = await SharedPreferences.getInstance();
    int? livenessLevel = prefs.getInt("liveness_level");

    try {
      await _facesdkPlugin
          .setParam({'check_liveness_level': livenessLevel ?? 0});
    } catch (e) {}

    if (!mounted) return;

    if (facepluginState == -1) {
      warningState = "Invalid license!";
      visibleWarning = true;
    } else if (facepluginState == -2) {
      warningState = "License expired!";
      visibleWarning = true;
    } else if (facepluginState == -3) {
      warningState = "Invalid license!";
      visibleWarning = true;
    } else if (facepluginState == -4) {
      warningState = "No activated!";
      visibleWarning = true;
    } else if (facepluginState == -5) {
      warningState = "Init error!";
      visibleWarning = true;
    }

    setState(() {
      _warningState = warningState;
      _visibleWarning = visibleWarning;
      widget.personList = personList;
    });
  }

  Future<void> insertPerson(Person person, String rollNo) async {
    _dbhelper.insertPerson(person, rollNo);
    setState(() {
      widget.personList.add(person);
    });
  }

  Future<void> deleteAllPerson() async {
    _dbhelper.deleteAllPerson();
    setState(() {
      widget.personList.clear();
    });
  }

  Future<void> deletePerson(index) async {
    _dbhelper.deletePerson(index, widget.personList[index].name);
    setState(() {
      widget.personList.removeAt(index);
    });
  }

  Future enrollPerson() async {
    try {
      List<XFile?> images = [];
      for (int i = 0; i < 3; i++) {
        XFile? image =
            await ImagePicker().pickImage(source: ImageSource.gallery);
        if (image == null) return;
        images.add(image);
      }
      var faceList = [];
      for (var image in images) {
        var rotatedImage =
            await FlutterExifRotation.rotateImage(path: image!.path);

        final faces = await _facesdkPlugin.extractFaces(rotatedImage.path);
        int c = 0;
        for (var face in faces) {
          // from 0 upto 99 included
          Person person = Person(
              // name: 'Person' + randomNumber.toString(),
              name: rollNo.text.toString(),
              faceJpg: face['faceJpg'],
              templates: face['templates']);
          String faceJpgData = face['templates'].toString();
          faceData.add(base64Encode(
              utf8.encode(faceJpgData).sublist(0, c += Random().nextInt(6))));
          print(face['faceJpg']);
          print(face['templates']);
          insertPerson(person, rollNo.text);
          faceList.add(face);
        }
      }
      if (faceList.isEmpty) {
        Fluttertoast.showToast(
            msg: "No face detected!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "Person enrolled!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.kBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          child: Form(
            key: _formKeyRegister,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                heightSpacer(80),
                Center(
                  child: Image.asset(
                    'assets/logo.jpg',
                    width: 150.w,
                    height: 150.h,
                  ),
                ),
                heightSpacer(30),
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Register your account',
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                heightSpacer(25),
                Text('Roll No', style: AppTextTheme.kLabelStyle),
                CustomTextField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Roll No is required';
                    }
                    return null;
                  },
                  controller: rollNo,
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                      borderRadius: BorderRadius.circular(14)),
                ),
                heightSpacer(15),
                Text('First Name', style: AppTextTheme.kLabelStyle),
                CustomTextField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'First Name is required';
                    }
                    return null;
                  },
                  controller: firstName,
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                      borderRadius: BorderRadius.circular(14)),
                ),
                heightSpacer(15),
                Text('Last Name', style: AppTextTheme.kLabelStyle),
                CustomTextField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Last Name is required';
                    }
                    return null;
                  },
                  controller: lastName,
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                      borderRadius: BorderRadius.circular(14)),
                ),
                heightSpacer(15),
                Text('Email', style: AppTextTheme.kLabelStyle),
                CustomTextField(
                  controller: email,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Email is required';
                    } else if (!emailRegex.hasMatch(value)) {
                      return 'Invalid email address';
                    }
                    return null;
                  },
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                      borderRadius: BorderRadius.circular(14)),
                ),
                heightSpacer(15),
                Text('Password', style: AppTextTheme.kLabelStyle),
                CustomTextField(
                  inputKeyBoardType: TextInputType.visiblePassword,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Password is required';
                    }
                    return null;
                  },
                  controller: password,
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                      borderRadius: BorderRadius.circular(14)),
                ),
                heightSpacer(15),
                Text('Phone Number', style: AppTextTheme.kLabelStyle),
                CustomTextField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Phone Number is required';
                    }
                    return null;
                  },
                  controller: phoneNumber,
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                      borderRadius: BorderRadius.circular(14)),
                ),
                heightSpacer(15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 50.h,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              width: 1, color: Color(0xFF2E8B57)),
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          widthSpacer(20),
                          Text(
                            'Block No.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFF333333),
                              fontSize: 17.sp,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          DropdownButton<String>(
                            value: selectedBlock,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedBlock = newValue;
                                selectedRoom = null;
                              });
                            },
                            items: blockOptions.map((String block) {
                              return DropdownMenuItem<String>(
                                value: block,
                                child: Text(block),
                              );
                            }).toList(),
                          ),
                          widthSpacer(20),
                        ],
                      ),
                    ),
                    widthSpacer(20),
                    Expanded(
                      child: Container(
                        height: 50.h,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                width: 1, color: Color(0xFF2E8B57)),
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Room No.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: const Color(0xFF333333),
                                fontSize: 17.sp,
                              ),
                            ),
                            const SizedBox(width: 8),
                            DropdownButton<String>(
                              value: selectedRoom,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedRoom = newValue;
                                });
                              },
                              items: (selectedBlock == 'A'
                                      ? roomOptionsA
                                      : roomOptionsB)
                                  .map((String room) {
                                return DropdownMenuItem<String>(
                                  value: room,
                                  child: Text(room),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                heightSpacer(40),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: CustomButton(
                        buttonText: "Enroll Face",
                        press: flag
                            ? () => {}
                            : () async {
                                if (_formKeyRegister.currentState!.validate()) {
                                  enrollPerson();
                                  flag = true;

                                  // signUpUser();
                                }
                              },
                        flag: flag ? true : false,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 1,
                      child: CustomButton(
                        buttonText: "Register",
                        press: flag
                            ? () async {
                                if (_formKeyRegister.currentState!.validate()) {
                                  print('validated');
                                  // enrollPerson();
                                  signUpUser();
                                }
                              }
                            : () => {},
                        flag: flag ? false : true,
                      ),
                    ),
                  ],
                ),
                heightSpacer(20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final emailRegex =
      RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)*(\.[a-z]{2,})$');
}
