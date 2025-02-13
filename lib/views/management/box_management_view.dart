import 'package:box_delivery_app/models/item_model.dart';
import 'package:box_delivery_app/repos/box_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../repos/location_repository.dart';
import '../../widgets/box_card.dart';
import '../../widgets/custom_delete_dailogue.dart';
import '../../widgets/scan_qr.dart';
import '../edit/edit_boxes_view.dart';

class BoxManagementScreen extends StatefulWidget {
  @override
  _BoxManagementScreenState createState() => _BoxManagementScreenState();
}

class _BoxManagementScreenState extends State<BoxManagementScreen> {
  LocationModel? selectedLocation;
  void onEdit(BoxModel item){
    Navigator.of(context).push(MaterialPageRoute(builder: (c)=>EditBoxesScreen( box: item,)));
  }

  void onDelete(BoxModel item){
    BoxRepository.instance.deleteBox(item.id);
  }
  @override
  Widget build(BuildContext context) {
    final locationRepo = context.read<LocationRepository>();
    final boxRepo = context.read<BoxRepository>();
    final locations = locationRepo.list;
    final boxes = selectedLocation !=null? boxRepo.getBoxes(selectedLocation!.locationId):boxRepo.list;
  print("aaaaa");
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
                    selectedLocation=value;
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
                if(boxes.isEmpty)return Center(child: Text("You have 0 boxes saved"),);
                return GridView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: boxes.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: constraints.maxWidth > 600 ? 3 : 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 30,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (context, index) {
                    final box = boxes[index];
                    return BoxCard(
                      box: box,
                      onEdit: ()=>onEdit(box),
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
                      onViewDetails: () {
                        BoxDetailsDialog.showDetailsDialog(
                            context,box);
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
