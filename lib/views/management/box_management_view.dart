import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/item_model.dart';
import '../../repos/location_repository.dart';
import '../../repos/box_repository.dart';
import '../../widgets/box_card.dart';
import '../../widgets/custom_delete_dailogue.dart';
import '../../widgets/scan_qr.dart';
import '../edit/edit_boxes_view.dart';
import '../../widgets/native_ad_widget.dart'; // Import Native Ad Widget

class BoxManagementScreen extends StatefulWidget {
  @override
  _BoxManagementScreenState createState() => _BoxManagementScreenState();
}

class _BoxManagementScreenState extends State<BoxManagementScreen> {
  LocationModel? selectedLocation;

  void onEdit(BoxModel item) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (c) => EditBoxesScreen(box: item)));
  }

  void onDelete(BoxModel item) {
    BoxRepository.instance.deleteBox(item.id);
  }

  @override
  Widget build(BuildContext context) {
    final locationRepo = context.read<LocationRepository>();
    final boxRepo = context.read<BoxRepository>();
    final locations = locationRepo.list;
    final boxes = selectedLocation != null
        ? boxRepo.getBoxes(selectedLocation!.locationId)
        : boxRepo.list;

    List<dynamic> combinedList = [];
    for (int i = 0; i < boxes.length; i++) {
      combinedList.add(boxes[i]);
      if ((i + 1) % 4 == 0) combinedList.add('ad'); // Insert an ad every 4 items
    }

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
              child: DropdownButton<LocationModel>(
                isExpanded: true,
                value: selectedLocation,
                hint: Text("Location"),
                items: [
                  ...locations.map((item) =>
                      DropdownMenuItem(value: item, child: Text(item.name)))
                ],
                onChanged: (value) {
                  setState(() {
                    selectedLocation = value;
                  });
                },
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (boxes.isEmpty) {
                  return Center(child: Text("You have 0 boxes saved"));
                }
                return GridView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: combinedList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: constraints.maxWidth > 600 ? 3 : 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 30,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (context, index) {
                    final item = combinedList[index];

                    if (item == 'ad') {
                      return NativeAdWidget(); // Show Native Ad
                    }

                    final box = item as BoxModel;
                    return BoxCard(
                      box: box,
                      onEdit: () => onEdit(box),
                      onDelete: () {
                        showDialog(
                          context: context,
                          builder: (context) => CustomDeleteDialog(
                            onConfirm: () {
                              onDelete(box);
                              Navigator.pop(context);
                            },
                          ),
                        );
                      },
                      onView: () {
                        BoxDetailsDialog.showDetailsDialog(context, box);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
