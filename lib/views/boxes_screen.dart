// views/boxes_view.dart
import 'package:box_delivery_app/views/items_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/boxes_controller.dart';
import '../widgets/box_card.dart';

class BoxesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BoxesController(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Boxes"),
          backgroundColor: Color(0xffe25e00),
        ),
        body: Consumer<BoxesController>(
          builder: (context, controller, child) {
            return Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.all(8),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: controller.boxes.length,
                    itemBuilder: (context, index) {
                      final box = controller.boxes[index];
                      return BoxCard(
                        box: box,
                        onEdit: () => controller.editBox(index),
                        onDelete: () => controller.deleteBox(index),
                        onViewDetails: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => ItemsView()));

                        },
                      );
                    },
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Items with box", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      SizedBox(height: 10),
                      if (controller.items.isNotEmpty)
                        ListTile(
                          leading: Image.asset(controller.items[0].imageUrl, width: 50),
                          title: Text(controller.items[0].name),
                          subtitle: Text("ID: ${controller.items[0].id}\nPurchase Date: ${controller.items[0].purchaseDate}"),
                          trailing: Icon(Icons.delete, color: Colors.red),
                        ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xffe25e00),
          child: Icon(Icons.add, color: Colors.white),
          onPressed: () {},
        ),
      ),
    );
  }
}
