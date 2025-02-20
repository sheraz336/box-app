import 'package:box_delivery_app/models/item_model.dart';
import 'package:box_delivery_app/repos/invite_repository.dart';
import 'package:box_delivery_app/repos/location_repository.dart';
import 'package:box_delivery_app/utils.dart';
import 'package:box_delivery_app/views/edit/edit_location_view.dart';
import 'package:box_delivery_app/widgets/share_location_dialoge.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../repos/subscription_repository.dart';
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
          try{
            if(SubscriptionRepository.instance.currentSubscription.isPremium && item.isShared()){
              throw Exception("Only owner can delete the location");
            }
            LocationRepository.instance.deleteLocation(item.locationId);
            Navigator.pop(context);
          }catch(e){
            print(e);
            showSnackbar(context, e.toString());
          }

        },
      ),
    );
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
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                children: [
                  Expanded(
                      child: StyledBoxCard(
                        box: locations[i],
                        onEdit: () => onLocationEdit(locations[i]),
                        onDelete: () => onLocationDelete(locations[i]),
                        onShare: () => onShare(locations[i]),
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
                        onShare: () => onShare(locations[i]),
                      )),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
