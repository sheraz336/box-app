import 'package:box_delivery_app/main.dart';
import 'package:box_delivery_app/models/invite_model.dart';
import 'package:box_delivery_app/repos/invite_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

class NotificationsView extends StatefulWidget {
  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  String loadingId = "";
  bool isLoading = false;

  void onAccept(InviteModel invite) async {
    if (isLoading) return;
    isLoading = true;
    loadingId = invite.id;
    setState(() {});
    await InviteRepository.instance
        .updateInvite(invite.id, invite..status = InviteStatus.ACCEPTED);
    isLoading = false;
    setState(() {});
  }

  void onReject(InviteModel invite) async {
    if (isLoading) return;
    isLoading = true;
    loadingId = invite.id;
    setState(() {});
    await InviteRepository.instance
        .updateInvite(invite.id, invite..status = InviteStatus.REJECTED);
    isLoading = false;
    setState(() {});
  }

  void onCancel(InviteModel invite) async {
    if (isLoading) return;
    isLoading = true;
    loadingId = invite.id;
    setState(() {});
    await InviteRepository.instance
        .deleteInvite(invite.id, invite);
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final invites = context
        .watch<InviteRepository>()
        .invites;
    return Scaffold(
      appBar: AppBar(
        title: Text("Invites"),
      ),
      body: (invites.isEmpty) ?Center(child: Text("You currently do not have any invites")  ,) :SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
        child: Column(
          children: [
            ...invites.map((item) => _buildInviteItem(item)),

          ],
        ),
      ),
    );
  }

  Widget _buildInviteItem(InviteModel invite) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    String msg = "";
    final isMyInvite = uid == invite.fromId;
    if (isMyInvite) {
      msg = "${invite.toName} invited to your location";
    } else {
      msg = "You are invited to ${invite.fromName}'s Location";
    }
    return Material(
      elevation: 2,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  invite.locationName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                Text(msg)
              ],
            ),
            isLoading && loadingId == invite.id
                ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: Colors.orange,
              ),
            )
                : (isMyInvite ||
                (isMyInvite && invite.status != InviteStatus.ACCEPTED) ||
                (!isMyInvite && invite.status != InviteStatus.PENDING))
                ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(invite.status.name, style: TextStyle(
                  color: Colors.orange,
                ),),
                if(isMyInvite && invite.status == InviteStatus.PENDING)
                  TextButton(
                      onPressed: () => onCancel(invite),
                      child: Text("Cancel")),
              ],
            )
                : Row(
              children: [
                TextButton(
                    onPressed: () => onCancel(invite),
                    child: Text("Reject")),
                TextButton(
                    onPressed: () => onAccept(invite),
                    child: Text("Accept")),
              ],
            )
          ],
        ),
      ),
    );
  }
}
