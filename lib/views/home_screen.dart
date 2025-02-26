import 'dart:math';

import 'package:box_delivery_app/models/item_model.dart';
import 'package:box_delivery_app/repos/box_repository.dart';
import 'package:box_delivery_app/repos/item_repository.dart';
import 'package:box_delivery_app/repos/location_repository.dart';
import 'package:box_delivery_app/repos/subscription_repository.dart';
import 'package:box_delivery_app/utils.dart';
import 'package:box_delivery_app/views/edit/edit_location_view.dart';
import 'package:box_delivery_app/views/profile_image.dart';
import 'package:box_delivery_app/views/subscription_screen.dart';
import 'package:box_delivery_app/widgets/speed_dial.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import '../controllers/home_controller.dart';
import '../repos/invite_repository.dart';
import '../widgets/custom_delete_dailogue.dart';
import '../widgets/share_location_dialoge.dart';
import '../widgets/stats_bar_widget.dart';
import '../widgets/gadget_box.dart';
import '../widgets/horizontal_card.dart';
import '../widgets/james_cooper_box.dart';
import '../widgets/nav_bar_widget.dart';
import 'edit/edit_boxes_view.dart';
import 'edit/edit_items_view.dart';

part 'home_screen.g.dart';

@HiveType(typeId: 10)
class Test extends HiveObject {
  @HiveField(0)
  int id = 0;
  @HiveField(1)
  String? a;
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BannerAd? _bannerAd;
  bool _isBannerAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  void _loadBannerAd() {
    if(!SubscriptionRepository.instance.isFree())return;
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3512120495633654/7333096507', // Replace with your AdMob banner unit ID
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          print('Banner Ad failed to load: $error');
          ad.dispose();
        },
      ),
    );

    _bannerAd!.load();
  }

  void onShare(LocationModel item) {
    if(FirebaseAuth.instance.currentUser == null){
      showAlertDialog(context, "Error", "Only pro users can share location", true, (){});
      return;
    }
    final uid = FirebaseAuth.instance.currentUser!.uid;
    if(uid != item.ownerId){
      showAlertDialog(context, "Error", "Only owner can share location", true, (){});
      return;
    }
    showDialog(
      context: context,
      builder: (context) => ShareLocationDialog(onUserSelected: (String id,String name){
        InviteRepository.instance.createInvite(item, name, id);
      }),
    );
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(FirebaseAuth.instance.currentUser?.email ??
        " no user " + " logged innn");

    final locations = context.watch<LocationRepository>().list;
    final boxes = context.watch<BoxRepository>().getBoxesWithNoLocation();
    final items = context.watch<ItemRepository>().getItemsWithNoLocationOrBox();

    return Consumer<HomeController>(builder: (c, homeController, w) {
      return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Color(0xff06a3e0),
          title: const Text(
            'Finditorium',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SubscriptionScreen()),
                );
              },
              icon: Image.asset(
                'assets/crown.png',  // Ensure this asset is in the correct path
                width: 24,
                height: 24,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              },
              icon: Icon(Icons.person, color: Colors.white),
            ),
          ],
        ),
        body: Column(
          children: [
            if (_isBannerAdLoaded)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: _bannerAd!.size.width.toDouble(),
                  height: _bannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd!),
                ),
              ),
            const StatsBar(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  //locations
                  if (locations.isEmpty)
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "You have 0 locations",
                            textAlign: TextAlign.center,
                          ),
                        )
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
                                    onView: (){},
                                    onEdit: () => Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (c) => EditLocationScreen(
                                                  location: item,
                                                ))),
                                    onDelete: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) =>
                                            CustomDeleteDialog(
                                          onConfirm: () {
                                           try{
                                             homeController.deleteLocation(item);
                                           }catch(e){
                                             print(e);
                                             showSnackbar(context, e.toString());
                                           }
                                            Navigator.pop(context);
                                          },
                                        ),
                                      );
                                    },
                                onShare: (){
                                  onShare(item);
                                },
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
                  if (boxes.isEmpty)
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "You have 0 boxes with no location",
                            textAlign: TextAlign.center,
                          ),
                        )
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
                                    onEdit: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (c) =>
                                                EditBoxesScreen(box: item))),
                                    onDelete: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) =>
                                            CustomDeleteDialog(
                                          onConfirm: () {
                                            try{
                                              homeController.deleteBox(item);
                                            }catch(e){
                                              print(e);
                                              showSnackbar(context, e.toString());
                                            }
                                            Navigator.pop(context);
                                          },
                                        ),
                                      );
                                    }),
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
                  if (items.isEmpty)
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "You have 0 items with no box or location",
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                  SingleChildScrollView(
                    // scrollDirection: Axis.horizontal,
                    child: Column(
                      children: [
                        ...items.map((item) => Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: ItemHorizontalCard(
                                      title: item.name,
                                      imagePath: item.imagePath,
                                      purchaseDate: DateTime(2019, 4, 1),
                                      hasTimer: true,
                                      onEdit: () => Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (c) =>
                                                  EditItemScreen(item: item))),
                                      onDelete: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) =>
                                              CustomDeleteDialog(
                                            onConfirm: () {
                                              try{
                                                homeController.deleteItem(item);
                                              }catch(e){
                                                print(e);
                                                showSnackbar(context, e.toString());
                                              }
                                              Navigator.pop(context);
                                            },
                                          ),
                                        );
                                      }),
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
