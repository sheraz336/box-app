import 'dart:math';

import 'package:box_delivery_app/models/item_model.dart';
import 'package:box_delivery_app/repos/box_repository.dart';
import 'package:box_delivery_app/repos/item_repository.dart';
import 'package:box_delivery_app/repos/location_repository.dart';
import 'package:box_delivery_app/widgets/speed_dial.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import '../controllers/home_controller.dart';
import '../widgets/stats_bar_widget.dart';
import '../widgets/gadget_box.dart';
import '../widgets/horizontal_card.dart';
import '../widgets/james_cooper_box.dart';
import '../widgets/nav_bar_widget.dart';

part 'home_screen.g.dart';

@HiveType(typeId: 10)
class Test extends HiveObject {
  @HiveField(0)
  int id = 0;
  @HiveField(1)
  String? a;
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(FirebaseAuth.instance.currentUser?.email ??
        " no user " + " logged innn");

    final locations = context.watch<LocationRepository>().list;
    final boxes = context.watch<BoxRepository>().getBoxesWithNoLocation();
    final items = context.watch<ItemRepository>().getItemsWithNoLocationOrBox();

    return  Consumer<HomeController>(builder: (c,homeController,w){
      return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Color(0xffe25e00),
          title: const Text(
            'Finditorium',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            // TextButton(
            //     onPressed: () async {
            //       await LocationRepository.instance.putLocation(LocationModel(
            //           id: "location-"+Random.secure().nextInt(10000).toString(),
            //           name: "name",
            //           address: "address",
            //           type: "type",
            //           description: "description",
            //           imagePath: "assets/onboarding2.png"));
            //       print("Location added");
            //     },
            //     child: Text(
            //       "oooo",
            //       style: TextStyle(color: Colors.white),
            //     ))
            // Padding(
            //   padding: const EdgeInsets.only(right: 16.0), // Add some spacing
            //   child: SvgPicture.asset(
            //     'assets/notifications.png',
            //     width: 28,
            //     height: 28,
            //     fit: BoxFit.contain,
            //   ),
            // ),
          ],
        ),
        body: Column(
          children: [
            const StatsBar(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  //locations
                  if(locations.isEmpty)
                    Row(
                      children: [
                       Expanded(child: Text("You have 0 locations",textAlign: TextAlign.center,),)
                      ],
                    ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ...locations.map((item) => Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            StyledBoxCard(
                              box: item,
                              onEdit: homeController.editBox,
                              onDelete: homeController.deleteBox,
                            ),
                            const SizedBox(width: 12),
                          ],
                        ))
                        // StyledBoxCard(
                        //   box: homeController.boxes[1],
                        //   onEdit: homeController.editBox,
                        //   onDelete: homeController.deleteBox,
                        // ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),

                  //divider
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

                  //boxes
                  if(boxes.isEmpty)
                    Row(
                      children: [
                        Expanded(child: Text("You have 0 boxes with no location",textAlign: TextAlign.center,),)
                      ],
                    ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ...boxes.map((item) => Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            BoxCard(
                              box: item,
                              onEdit: homeController.editBox,
                              onDelete: homeController.deleteBox,
                            ),
                            const SizedBox(width: 12),
                          ],
                        ))
                        // StyledBoxCard(
                        //   box: homeController.boxes[1],
                        //   onEdit: homeController.editBox,
                        //   onDelete: homeController.deleteBox,
                        // ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),

                  //Divider
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

                  //items
                  if(items.isEmpty)
                    Row(
                      children: [
                        Expanded(child: Text("You have 0 items with no box or location",textAlign: TextAlign.center,),)
                      ],
                    ),
                  SingleChildScrollView(
                    // scrollDirection: Axis.horizontal,
                    child: Column(
                      children: [
                        ...items
                            .map((item) => Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.center,
                          children: [
                            ItemHorizontalCard(
                              title: item.name,
                              imagePath: "assets/onboarding2.png",
                              purchaseDate: DateTime(2019, 4, 1),
                              hasTimer: true,
                            ),
                            const SizedBox(width: 12),
                          ],
                        ))
                        // StyledBoxCard(
                        //   box: homeController.boxes[1],
                        //   onEdit: homeController.editBox,
                        //   onDelete: homeController.deleteBox,
                        // ),
                      ],
                    ),
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
    });
  }
}
