import 'package:box_delivery_app/widgets/speed_dial.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/home_controller.dart';
import '../widgets/stats_bar_widget.dart';
import '../widgets/gadget_box.dart';
import '../widgets/horizontal_card.dart';
import '../widgets/james_cooper_box.dart';
import '../widgets/nav_bar_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(FirebaseAuth.instance.currentUser?.email?? " no user " + " logged innn");
    return ChangeNotifierProvider(
      create: (_) => HomeController(),
      child: Consumer<HomeController>(
        builder: (context, homeController, child) {
          return Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: AppBar(
              backgroundColor: Color(0xffe25e00),
              title: const Text(
                'Finditorium',
                style: TextStyle(color: Colors.white),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined,
                      color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
            body: Column(
              children: [
                const StatsBar(),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: StyledBoxCard(
                              box: homeController.boxes[0],
                              onEdit: homeController.editBox,
                              onDelete: homeController.deleteBox,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: StyledBoxCard(
                              box: homeController.boxes[1],
                              onEdit: homeController.editBox,
                              onDelete: homeController.deleteBox,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 91,
                            height: 0,
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: Color(0xff000000),
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10), // Adjust spacing as needed
                          Text(
                            'Boxes with no location',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff000000),
                            ),
                          ),
                          SizedBox(width: 10), // Adjust spacing as needed
                          Container(
                            width: 88,
                            height: 0,
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: Color(0xff000000),
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: BoxCard(
                              box: homeController.boxes[2],
                              onEdit: homeController.editBox,
                              onDelete: homeController.deleteBox,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: BoxCard(
                              box: homeController.boxes[3],
                              onEdit: homeController.editBox,
                              onDelete: homeController.deleteBox,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 88,
                            height: 0,
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: Color(0xff000000),
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10), // Adjust spacing as needed
                          Text(
                            'Items with no location or box',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff000000),
                            ),
                          ),
                          SizedBox(width: 10), // Adjust spacing as needed
                          Container(
                            width: 45,
                            height: 0,
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: Color(0xff000000),
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ItemHorizontalCard(
                        title: "G.I. Joe Figure",
                        imagePath: "assets/onboarding2.png",
                        purchaseDate: DateTime(2019, 4, 1),
                        hasTimer: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            floatingActionButton: const SpeedDialFAB(),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            bottomNavigationBar: const CustomBottomNav(currentIndex: 0),
          );
        },
      ),
    );
  }
}
