class PlanModel
{
  String? placeId;
  String? id;
  String? status;
  String? date;
  String? time;

  PlanModel({this.placeId, this.status, this.date, this.time, this.id});

  PlanModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    placeId = json['placeId'];
    status = json['status'];
    date = json['date'];
    time = json['time'];


  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'placeId': placeId,
      'status': status,
      'date': date,
      'time': time,
    };
  }
}
