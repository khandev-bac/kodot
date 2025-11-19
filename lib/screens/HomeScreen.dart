import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:kodot/contants/Colors.dart';
import 'package:kodot/screens/features/InboxScreen.dart';
import 'package:kodot/screens/features/MainScreen.dart';
import 'package:kodot/screens/features/PostScreen.dart';
import 'package:kodot/screens/features/ProfileScreen.dart';
import 'package:kodot/screens/features/SearchScreen.dart';

class Homescreen extends StatefulWidget {
  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  int selectedIndex = 0;
  final List<Widget> _screens = [
    Mainscreen(),
    Searchscreen(),
    Postscreen(),
    Inboxscreen(),
    ProfilSreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.customBlack,
      body: _screens[selectedIndex],
      bottomNavigationBar: BottomAppBar(
        color: AppColors.customBlack,
        elevation: 0,
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () => setState(() {
                  selectedIndex = 0;
                }),
                child: HugeIcon(
                  icon: HugeIcons.strokeRoundedHome07,
                  color: AppColors.customWhite,
                  strokeWidth: selectedIndex == 0 ? 2.0 : 1.0,
                  size: 30,
                ),
              ),
              GestureDetector(
                onTap: () => setState(() {
                  selectedIndex = 1;
                }),
                child: HugeIcon(
                  icon: HugeIcons.strokeRoundedSearch01,
                  color: AppColors.customWhite,
                  strokeWidth: selectedIndex == 1 ? 2.0 : 1.0,
                  size: 30,
                ),
              ),
              GestureDetector(
                onTap: () => setState(() {
                  selectedIndex = 2;
                }),
                child: HugeIcon(
                  icon: HugeIcons.strokeRoundedAddSquare,
                  color: AppColors.customWhite,
                  strokeWidth: selectedIndex == 2 ? 2.0 : 1.0,
                  size: 30,
                ),
              ),
              GestureDetector(
                onTap: () => setState(() {
                  selectedIndex = 3;
                }),
                child: HugeIcon(
                  icon: HugeIcons.strokeRoundedInboxDownload,
                  color: AppColors.customWhite,
                  strokeWidth: selectedIndex == 3 ? 2.0 : 1.0,
                  size: 30,
                ),
              ),
              GestureDetector(
                onTap: () => setState(() {
                  selectedIndex = 4;
                }),
                child: HugeIcon(
                  icon: HugeIcons.strokeRoundedUserCircle,
                  color: AppColors.customWhite,
                  strokeWidth: selectedIndex == 4 ? 2.0 : 1.0,
                  size: 30,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
