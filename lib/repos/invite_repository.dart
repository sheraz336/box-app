import 'dart:async';

import 'package:box_delivery_app/models/invite_model.dart';
import 'package:box_delivery_app/models/item_model.dart';
import 'package:box_delivery_app/repos/profile_repository.dart';
import 'package:box_delivery_app/repos/subscription_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class InviteRepository extends ChangeNotifier {
  static final InviteRepository instance = InviteRepository();
  List<InviteModel> _invites = [];
  List<InviteModel> _otherInvites = [];

  List<InviteModel> get invites =>
      _invites.toList()..addAll(_otherInvites.toList());

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _myInvitesSub,
      _otherInvitesSub;

  void initListeners() {
    SubscriptionRepository.instance.addListener(() {
      if (!SubscriptionRepository.instance.currentSubscription.isPremium)
        return;
      listenForInvites();
    });
  }

  void fireNotify() {
    notifyListeners();
  }

  void listenForInvites() {
    if (FirebaseAuth.instance.currentUser == null ||
        !SubscriptionRepository.instance.currentSubscription.isPremium) return;
    final uid = FirebaseAuth.instance.currentUser!.uid;
    //listen for invites user created
    _myInvitesSub = FirebaseFirestore.instance
        .collection("invites")
        .where("fromId", isEqualTo: uid)
        .snapshots(includeMetadataChanges: true)
        .listen((snapshots) {
      print("My Invites snapshots received ${snapshots.docs.length}");
      if (snapshots.metadata.isFromCache || snapshots.metadata.hasPendingWrites)
        return;
      _invites = snapshots.docs
          .map((item) => InviteModel.fromMap(item.data()))
          .toList();
      fireNotify();
    });

    //listen for invites user is invited to
    _otherInvitesSub = FirebaseFirestore.instance
        .collection("invites")
        .where("toId", isEqualTo: uid)
        .snapshots(includeMetadataChanges: true)
        .listen((snapshots) {
      print("Other Invites snapshots received ${snapshots.docs.length}");
      if (snapshots.metadata.isFromCache || snapshots.metadata.hasPendingWrites)
        return;
      _otherInvites = snapshots.docs
          .map((item) => InviteModel.fromMap(item.data()))
          .toList();
      fireNotify();
    });
  }

  Future<void> createInvite(
      LocationModel location, String toName, String toId) async {
    if (!SubscriptionRepository.instance.currentSubscription.isPremium) return;
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final fromName = ProfileRepository.instance.profile!.name;
    final id = "${location.locationId}:$toId";

    await FirebaseFirestore.instance
        .collection("invites")
        .doc(id)
        .set(InviteModel(
                id: id,
                status: InviteStatus.PENDING,
                locationName: location.name,
                locationId: location.locationId,
                fromId: uid,
                toId: toId,
                fromName: fromName,
                toName: toName)
            .toMap());
  }

  Future<void> updateInvite(String id, InviteModel invite) async {
    if (!SubscriptionRepository.instance.currentSubscription.isPremium) return;
    await FirebaseFirestore.instance
        .collection("invites")
        .doc(id)
        .update({"status": invite.status.name});
  }

  Future<void> deleteInvite(String id, InviteModel invite) async {
    if (!SubscriptionRepository.instance.currentSubscription.isPremium) return;
    await FirebaseFirestore.instance
        .collection("invites")
        .doc(id)
        .delete();
  }

  List<InviteModel> getAcceptedInvites() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return invites
        .where((item) =>
            item.status == InviteStatus.ACCEPTED && item.fromId != uid)
        .toList();
  }

  Future<void> clear() async {
    await _myInvitesSub?.cancel();
    await _otherInvitesSub?.cancel();
    _myInvitesSub = null;
    _otherInvitesSub = null;
  }
}
