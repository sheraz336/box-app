import 'package:box_delivery_app/models/item_model.dart';
import 'package:box_delivery_app/repos/location_repository.dart';
import 'package:box_delivery_app/views/edit/edit_location_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/custom_delete_dailogue.dart';
import '../../widgets/james_cooper_box.dart';

class LocationManagementScreen extends StatefulWidget {
  @override
  State<LocationManagementScreen> createState() =>
      _LocationManagementScreenState();
}

class _LocationManagementScreenState extends State<LocationManagementScreen> {
  void onLocationEdit(LocationModel item) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (c) => EditLocationScreen(location: item)));
  }

  void onLocationDelete(LocationModel item) {
    showDialog(
      context: context,
      builder: (context) => CustomDeleteDialog(
        onConfirm: () {
          Navigator.pop(context);
          LocationRepository.instance.deleteLocation(item.id);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locations = context.watch<LocationRepository>().list;
    final pairs = locations.length / 2 +
        ((locations.length > 0 && locations.length % 2 != 0) ? 1 : 0);
    print("pairs $pairs ${locations.length}");
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          for (var i = 0; i < pairs; i += 2)
            Row(
              children: [
                Expanded(
                    child: StyledBoxCard(
                      box: locations[i],
                      onEdit: () => onLocationEdit(locations[i]),
                      onDelete: () => onLocationDelete(locations[i]),
                    )),
                const SizedBox(
                  width: 12,
                ),
                (i + 1 >= locations.length)
                    ? Expanded(
                    child: Container(
                      height: 263,
                    ))
                    : Expanded(
                    child: StyledBoxCard(
                      box: locations[i + 1],
                      onEdit: () => onLocationEdit(locations[i + 1]),
                      onDelete: () => onLocationDelete(locations[i + 1]),
                    )),
              ],
            ),
        ],
      ),
    );
  }
}
