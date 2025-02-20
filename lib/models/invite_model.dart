enum InviteStatus { PENDING, ACCEPTED, REJECTED }

class InviteModel {
  final String id;
  final String locationId;
  final String fromId;
  final String toId;
  final String locationName;
  final String fromName, toName;
   InviteStatus status;

  InviteModel(
      {
        required this.id,
        required this.status,
      required this.locationName,
      required this.locationId,
      required this.fromId,
      required this.toId,
      required this.fromName,
      required this.toName});

  Map<String, Object?> toMap() {
    return {
      "id":id,
      "status": status.name,
      "locationId": locationId,
      "fromId": fromId,
      "toId": toId,
      "locationName": locationName,
      "fromName": fromName,
      "toName": toName
    };
  }

  static InviteModel fromMap(Map map) {
    return InviteModel(
      id:map["id"],
        status: InviteStatus.values.firstWhere((item) => item.name == map["status"]),
        locationId: map["locationId"],
        fromId: map["fromId"],
        toId: map["toId"],
        locationName: map["locationName"],
        fromName: map["fromName"],
        toName: map["toName"]);
  }
}
