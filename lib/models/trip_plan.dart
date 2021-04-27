class TripPlan {
  int id;
  String description;
  int routeId;
  String startingDate;
  String endingDate;

  TripPlan(
      {this.id,
      this.description,
      this.routeId,
      this.startingDate,
      this.endingDate});

  TripPlan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    routeId = json['route_id'];
    startingDate = json['starting_date'];
    endingDate = json['ending_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['route_id'] = this.routeId.toString();
    data['starting_date'] = this.startingDate;
    data['ending_date'] = this.endingDate;
    return data;
  }
}
