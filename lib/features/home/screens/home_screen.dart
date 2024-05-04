import 'dart:convert';
// import 'dart:js';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hostel_management/api_services/api_provider.dart';
import 'package:hostel_management/api_services/api_utils.dart';
import 'package:hostel_management/common/constants.dart';
import 'package:hostel_management/common/spacing.dart';
import 'package:hostel_management/features/admin/screens/create_staff.dart';
import 'package:hostel_management/features/admin/screens/issue_details_screen.dart';
import 'package:hostel_management/features/admin/screens/room_change_requests_screen.dart';
import 'package:hostel_management/features/admin/screens/staff_display_screen.dart';
import 'package:hostel_management/features/auth/services/auth_service.dart';
import 'package:hostel_management/features/student/screens/hostel_fees.dart';
import 'package:hostel_management/features/student/screens/profile_screen.dart';
import 'package:hostel_management/features/student/screens/raise_issue_screen.dart';
import 'package:hostel_management/features/student/screens/room_availability.dart';
import 'package:hostel_management/models/student_info_model.dart';
import 'package:hostel_management/models/user.dart';
import 'package:hostel_management/providers/user_provider.dart';
import 'package:hostel_management/register_face.dart';
import 'package:hostel_management/theme/colors.dart';
import 'package:hostel_management/theme/text_theme.dart';
import 'package:hostel_management/widgets/category_card.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:hostel_management/features/preferences/menu_preference.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? studentInfoModel;
  AuthService authService = AuthService();
  late bool isWithinTimeFrame;

  void fetchUserData(context) async {
    print("fetched data context: $context");
    try {
      await authService.getUserData(context);
      final userProvider =
          Provider.of<UserProvider>(context, listen: false).user;
      print(userProvider.phoneNumber);
      setState(() {
        studentInfoModel = userProvider;
      });
      print(studentInfoModel?.phoneNumber);
      ApiUrls.rollNo = studentInfoModel!.rollNo;
      ApiUrls.email = studentInfoModel!.email;
      ApiUrls.phoneNumber = studentInfoModel!.phoneNumber;
      ApiUrls.roomNumber = studentInfoModel!.roomNo;
      ApiUrls.blockNumber = studentInfoModel!.block;
      ApiUrls.firstName = studentInfoModel!.firstName;
      ApiUrls.lastName = studentInfoModel!.lastName;
      print("first name ${ApiUrls.firstName}");
    } catch (e) {
      print('Error: $e');
    }
  }

  void checkTimeFrame(context) async {
    bool flag = await authService.checkTimeFrame(context);
    setState(() {
      isWithinTimeFrame = flag;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUserData(context);
    checkTimeFrame(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          "Dashboard",
          style: AppTextTheme.kLabelStyle.copyWith(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        backgroundColor: AppColors.kGreenColor,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15.w),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => ProfileScreen(
                      roomNumber: studentInfoModel!.roomNo,
                      blockNumber: studentInfoModel!.block,
                      username: studentInfoModel!.rollNo,
                      emailId: studentInfoModel!.email,
                      phoneNumber: studentInfoModel!.phoneNumber,
                      firstName: studentInfoModel!.firstName,
                      lastName: studentInfoModel!.lastName,
                    ),
                  ),
                );
              },
              child: SvgPicture.asset(
                AppConstants.profile,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 15.w,
            vertical: 10.h,
          ),
          child: Column(
            children: [
              heightSpacer(20),
              ApiUrls.email == ''
                  ? const SizedBox()
                  : Container(
                      height: 140.h,
                      width: double.maxFinite,
                      decoration: const ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              width: 2, color: Color.fromARGB(255, 0, 123, 59)),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(2),
                          ),
                        ),
                        shadows: [
                          BoxShadow(
                            color: Color(0x332E8B57),
                            blurRadius: 8,
                            offset: Offset(2, 4),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(top: 20.h),
                        child: Row(
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 180.w,
                                  child: Text(
                                    '${ApiUrls.firstName} ${ApiUrls.lastName}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF333333),
                                      fontSize: 24.sp,
                                    ),
                                  ),
                                ),
                                heightSpacer(15),
                                Text(
                                  "Room No. : ${ApiUrls.roomNumber}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: const Color(0xFF333333),
                                    fontSize: 15.sp,
                                  ),
                                ),
                                Text(
                                  'Block No. :  ${ApiUrls.blockNumber}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: const Color(0xFF333333),
                                    fontSize: 15.sp,
                                  ),
                                )
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) =>
                                        const RaiseIssueScreen(),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  SvgPicture.asset(AppConstants.createIssue),
                                  Text(
                                    'Create issues',
                                    style: TextStyle(
                                      color: const Color(0xFF153434),
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              heightSpacer(30),
              Container(
                width: double.maxFinite,
                color: const Color(0x262E8B57),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    heightSpacer(20),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        'Categories',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF333333),
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    heightSpacer(15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CategoryCard(
                          category: 'Room\nAvailability',
                          image: AppConstants.roomAvailability,
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) =>
                                    const RoomAvailabilityScreen(),
                              ),
                            );
                          },
                        ),
                        CategoryCard(
                          category: 'All\nIssues',
                          image: AppConstants.allIssues,
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => const IssueScreen(),
                              ),
                            );
                          },
                        ),
                        CategoryCard(
                          category: 'Staff\nMembers',
                          image: AppConstants.staffMember,
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => const StaffInfoScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    heightSpacer(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CategoryCard(
                          category: 'Mark\nAttendence',
                          image: AppConstants.faceImage,
                          onTap: () {
                            checkTimeFrame(context);
                            isWithinTimeFrame
                                ? Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => MyHomePage(
                                        title: "Face Authorization",
                                      ),
                                    ),
                                  )
                                : Fluttertoast.showToast(
                                    msg:
                                        "Attendance can only be marked between 9.00 PM to 9.30 PM IST",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                          },
                        ),
                        CategoryCard(
                          category: 'Menu\nPreference',
                          image: AppConstants.menuFood,
                          onTap: () {
                            checkTimeFrame(context);
                            isWithinTimeFrame
                                ? Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) =>
                                          const MessMenuPage(),
                                    ),
                                  )
                                : Fluttertoast.showToast(
                                    msg:
                                        "Food preference can only be selected between 9.00 PM to 9.30 PM IST",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                          },
                        ),
                      ],
                    ),
                    heightSpacer(20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChartData {
  final String label;
  final double value;
  final Color color;

  ChartData({required this.label, required this.value, required this.color});
}
