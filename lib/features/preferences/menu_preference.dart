import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hostel_management/theme/colors.dart';
import 'package:hostel_management/theme/text_theme.dart';
import 'package:hostel_management/features/auth/widgets/custom_button.dart';
import 'package:hostel_management/features/auth/services/auth_service.dart';

class MessMenuPage extends StatefulWidget {
  const MessMenuPage({super.key});

  @override
  State<MessMenuPage> createState() => _MessMenuState();
}

class _MessMenuState extends State<MessMenuPage> {
  AuthService authService = AuthService();
  late bool isWithinTimeFrame;

  @override
  void initState() {
    super.initState();
    checkTimeFrame(context);
  }

  void checkTimeFrame(context) async {
    bool flag = await authService.checkTimeFrame(context);
    setState(() {
      isWithinTimeFrame = flag;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          "Mess Menu",
          style: AppTextTheme.kLabelStyle.copyWith(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        backgroundColor: AppColors.kGreenColor,
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 15, bottom: 20, left: 10, right: 10),
        child: Stack(
          children: [
            ListView(
              children: [
                const MessMenuCard(
                  title: 'Breakfast',
                  content: breakfastMenu,
                  timestamp: "7:00 AM - 9:00 AM",
                ),
                const MessMenuCard(
                  title: 'Lunch    ',
                  content: lunchMenu,
                  timestamp: "12:00 PM - 1:30 PM",
                ),
                const MessMenuCard(
                    title: 'Snack     ',
                    content: snackMenu,
                    timestamp: "4:00 PM - 5:00 PM"),
                const MessMenuCard(
                    title: 'Dinner    ',
                    content: dinnerMenu,
                    timestamp: "7:00 PM - 8:30 PM"),
                const SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.only(top: 14, bottom: 14),
                              backgroundColor:
                                  // Theme.of(context).colorScheme.primaryContainer,
                                  const Color.fromARGB(255, 52, 159, 99),
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0)),
                              )),
                          onPressed: () {
                            if (isWithinTimeFrame) {
                              authService.addPreference(context, true);
                            }
                          },
                          child: Text(
                            'Opt In',
                            style: AppTextTheme.kLabelStyle.copyWith(
                                color: AppColors.kLight, fontSize: 16),
                          )),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.only(top: 14, bottom: 14),
                              backgroundColor:
                                  // Theme.of(context).colorScheme.primaryContainer,
                                  const Color.fromARGB(255, 159, 52, 52),
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0)),
                              )),
                          onPressed: () {
                            if (isWithinTimeFrame) {
                              authService.addPreference(context, false);
                            }
                          },
                          child: Text(
                            'Opt out',
                            style: AppTextTheme.kLabelStyle.copyWith(
                                color: AppColors.kLight, fontSize: 16),
                          )),
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
}

class MessMenuCard extends StatelessWidget {
  final String title;
  final String content;
  final String timestamp;

  const MessMenuCard(
      {super.key,
      required this.title,
      required this.content,
      required this.timestamp});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align content
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 130.0),
                    Text(
                      timestamp,
                      style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey,
                          overflow: TextOverflow.clip),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Text(content),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Replace these with the actual menu items from the image
const String breakfastMenu = '''
Sweet Pongal, Pongal, Medhu Vadai, Sambar,
Coconut Chutney, T/C/M- Tea, Coffee, Milk
''';

const String lunchMenu = '''
Rice, Vathal kulambu, Koottu, Rasam, Butter
milk, Pappad, Pickle
''';

const String snackMenu = 'Menu is not updated for this session';

const String dinnerMenu = '''
Pickle, Kal Dosai, tomato chutney, Curd Rice,
Badam Milk, Masala Sambar
''';
