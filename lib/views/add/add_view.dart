import 'package:box_delivery_app/views/add/add_boxes_view.dart';
import 'package:box_delivery_app/widgets/category_tabs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../repos/box_repository.dart';
import '../../repos/item_repository.dart';
import '../../repos/location_repository.dart';
import 'add_item_view.dart';
import 'add_location_view.dart';

class AddView extends StatefulWidget {
  final int pageIndex;

  const AddView({super.key, required this.pageIndex});

  @override
  State<AddView> createState() => _AddViewState();
}

class _AddViewState extends State<AddView> {
  late final PageController pageController;
  final tabNames = ["Location", "Boxes", "Items"];
  int currentPageIdx = 0;

  @override
  void initState() {
    super.initState();
    pageController = new PageController(initialPage: widget.pageIndex);
    currentPageIdx = widget.pageIndex;
  }

  @override
  Widget build(BuildContext context) {
    // final locations = context.watch<LocationRepository>().list;
    // final boxes = context.watch<BoxRepository>().getBoxesWithNoLocation();
    // final items = context.watch<ItemRepository>().getItemsWithNoLocationOrBox();
    return Scaffold(
      appBar: AppBar(
        title:  Text(
          "Add ${tabNames[currentPageIdx]}",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xff06a3e0),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16,),
          CategoryTabs(
              selectedTab: tabNames[currentPageIdx],
              onTabSelected: (tab) {
                pageController.animateToPage(
                    tabNames.indexWhere((item) => item == tab),
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOut);
                ;
              }),
          const SizedBox(height: 16,),
          Expanded(child:    PageView(
            controller: pageController,
            onPageChanged: (idx) {
              setState(() {
                currentPageIdx = idx;
              });
            },
            children: [
              AddLocationView(),
              AddBoxView(),
              AddItemsView(),
            ],
          )),
        ],
      ),
    );
  }
}