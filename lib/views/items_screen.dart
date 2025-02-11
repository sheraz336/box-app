import 'package:box_delivery_app/widgets/speed_dial.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/item_controller.dart';
import '../models/item_model.dart';
import '../widgets/nav_bar_widget.dart';
import 'item_management_view.dart';

class ItemsView extends StatelessWidget {
  const ItemsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ItemsController(),
      child: Consumer<ItemsController>(
        builder: (context, controller, child) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xffe25e00),
              title: const Row(
                children: [
                  Icon(
                    Icons.arrow_back_ios_new_outlined,
                    color: Color(0xffFFFFFF),size: 16,
                  ),SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Items',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                        color: Color(0xffFFFFFF)),
                  )
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined,
                      color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
            body: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.items.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ItemHorizontalCard(item: controller.items[index]),
                );
              },
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
