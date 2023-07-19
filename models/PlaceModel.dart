class PlaceModel {
  String? name;
  String? location;
  String? id;
  String? description;
  String? category;
  String? image;
  double? rateValue;
  double? rate;
  int? raters;
  String? mapLink;
  String? nearbyLink;

  PlaceModel(
      {this.id,
      this.category,
      this.name,
      this.location,
      this.mapLink,
      this.nearbyLink,
      this.image,
      this.description,
      this.rateValue,
      this.raters,
      this.rate,
      });

  PlaceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    mapLink = json['mapLink'];
    nearbyLink = json['nearbyLink'];
    image = json['image'];
    description = json['description'];
    category = json['category'];
    rateValue = double.parse(json['rateValue'].toString());
    rate = double.parse(json['rate'].toString());
    raters = int.parse(json['raters'].toString());
    location = json['location'];
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'mapLink': mapLink,
      'nearbyLink': nearbyLink,
      'image': image,
      'category': category,
      'id': id,
      'description': description,
      'rateValue': rateValue.toString(),
      'raters': raters.toString(),
      'rate': rate.toString(),
      'location': location
    };
  }
}
