import 'package:box_delivery_app/repos/box_repository.dart';
import 'package:box_delivery_app/repos/item_repository.dart';
import 'package:box_delivery_app/widgets/horizontal_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../repos/location_repository.dart';
import '../../widgets/custom_delete_dailogue.dart';
import '../../widgets/management_category_tabs.dart';
import '../../models/item_model.dart';
import '../../widgets/nav_bar_widget.dart';
import '../edit/edit_items_view.dart';

class ItemManagementScreen extends StatefulWidget {
  @override
  _ItemManagementScreenState createState() => _ItemManagementScreenState();
}

class _ItemManagementScreenState extends State<ItemManagementScreen> {
  BoxModel? selectedBox;

  void onEdit(ItemModel item){
    Navigator.of(context).push(MaterialPageRoute(builder: (c)=>EditItemScreen(item: item)));
  }

  void onDelete(ItemModel item){
    ItemRepository.instance.deleteItem(item.id);
  }

  @override
  Widget build(BuildContext context) {
    final boxRepo = context.read<BoxRepository>();
    final itemsRepo = context.read<ItemRepository>();

    final boxes = boxRepo.list;
    final items = selectedBox != null
        ? itemsRepo.getBoxItems(selectedBox!.id)
        : itemsRepo.list;
    items.forEach((item){
      print("${item.boxId},,");
    });

    print("items ${items.length} ${items.firstOrNull?.imagePath}");
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<BoxModel>(
                isExpanded: true,
                value: selectedBox,
                hint: Text("Boxes"),
                items: [
                  ...boxes.map((item) => DropdownMenuItem(
                      value: item, child: Text(item.name)))
                ],
                onChanged: (value) {
                  setState(() {
                    selectedBox = value;
                  });
                },
              ),
            ),
          ),
        ),
        SizedBox(height: 1),
        if(items.isNotEmpty)
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ItemHorizontalCard(
                    title: item.name,
                    imagePath: item.imagePath,
                    purchaseDate: item.purchaseDate.isEmpty
                        ? null
                        : DateFormat(DateFormat.YEAR_MONTH_DAY)
                        .parse(item.purchaseDate),
                    onDelete:(){
                      showDialog(
                        context: context,
                        builder: (context) => CustomDeleteDialog(
                          onConfirm: () {
                            onDelete(item);
                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                    onEdit: ()=>onEdit(item),
                  ),
                );
              },
            ),
          ),

        if(items.isEmpty) Expanded(child: Center(child: Text("You have 0 items saved"),))
      ],
    );
  }
}

// class ItemHorizontalCard extends StatelessWidget {
//   final ItemModel item;
//
//   const ItemHorizontalCard({Key? key, required this.item}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: (){
//         Navigator.pushNamed(context, "/edit_items");
//       },
//       child: Container(
//         width: 372.09,
//         height: 87,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(color: const Color(0xFFCFD5DB), width: 1),
//         ),
//         child: Row(
//           children: [
//             Container(
//               width: 117.93,
//               height: 77,
//               margin: const EdgeInsets.symmetric(horizontal: 9),
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.black, width: 1),
//               ),
//               child: Image.asset(
//                 item.imagePath,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.only(top: 5, left: 15),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       item.name,
//                       style: const TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w500,
//                         color: Color(0xff353535),
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Row(
//                       children: [
//                         const Text(
//                           "Item ID: ",
//                           style: TextStyle(
//                             fontSize: 10,
//                             fontWeight: FontWeight.w400,
//                             color: Color(0xff4D4D4D),
//                           ),
//                         ),
//                         Text(
//                           item.id,
//                           style: const TextStyle(
//                             fontSize: 10,
//                             fontWeight: FontWeight.w400,
//                             color: Color(0xffABABAB),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       'Purchase Date: ${item.purchaseDate}',
//                       style: const TextStyle(
//                         fontSize: 10,
//                         fontWeight: FontWeight.w400,
//                         color: Color(0xff4D4D4D),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Column(
//               children: [
//                 Container(
//                   width: 34.57,
//                   height: 85,
//                   decoration: const BoxDecoration(
//                     color: Color(0xffD9D9D9),
//                     borderRadius: BorderRadius.only(
//                       topRight: Radius.circular(8),
//                       bottomRight: Radius.circular(8),
//                     ),
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Image.asset('assets/pen_edit.png',
//                           width: 18.07, height: 13.69),
//                       Container(
//                         width: 25.47,
//                         height: 1.2,
//                         color: Colors.black,
//                       ),
//                       Image.asset('assets/delete_box.png',
//                           width: 18.07, height: 13.69),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
