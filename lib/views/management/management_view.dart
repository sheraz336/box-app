import 'package:box_delivery_app/views/add/add_boxes_view.dart';
import 'package:box_delivery_app/widgets/category_tabs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../repos/box_repository.dart';
import '../../repos/item_repository.dart';
import '../../repos/location_repository.dart';
import '../../widgets/management_category_tabs.dart';
import 'box_management_view.dart';
import 'item_management_view.dart';
import 'location_management_view.dart';

class ManagementView extends StatefulWidget {
  final int pageIndex;

  const ManagementView({super.key, required this.pageIndex});

  @override
  State<ManagementView> createState() => _AddViewState();
}

class _AddViewState extends State<ManagementView> {
  late final PageController pageController;
  final tabNames = ["Location Management", "Boxes Management", "Items Management"];
  int currentPageIdx = 0;

  @override
  void initState() {
    super.initState();
    pageController = new PageController(initialPage: widget.pageIndex);
    currentPageIdx = widget.pageIndex;
  }

  @override
  Widget build(BuildContext context) {
    final _ = context.watch<LocationRepository>().list;
    final __ = context.watch<BoxRepository>().getBoxesWithNoLocation();
    final ___ = context.watch<ItemRepository>().getItemsWithNoLocationOrBox();
    return Scaffold(
      appBar: AppBar(
        title:  Text(
          tabNames[currentPageIdx],
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xffe25e00),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16,),
          ManagementCategoryTabs(
            onTabSelected: (tab) {
              pageController.animateToPage(
                  tabNames.indexWhere((item) => item == tab),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOut);
            },
            selectedTab: tabNames[currentPageIdx],
          ),
          const SizedBox(height: 16,),
          Expanded(child:    PageView(
            controller: pageController,
            onPageChanged: (idx) {
              setState(() {
                currentPageIdx = idx;
              });
            },
            children: [
              LocationManagementScreen(),
              BoxManagementScreen(),
              ItemManagementScreen(),
            ],
          )),
        ],
      ),
    );
  }
}
