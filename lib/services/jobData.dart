class JobData {
  JobData({
    this.description,
    this.name,
    this.pictures,
    this.location,
    this.price,
  });

  final String description;
  final String name;
  final String pictures;
  final String location;
  final int price;

  Map<String, dynamic> getJobDataMap() {
    return {
      "description": description,
      "name": name,
      "pictures": pictures,
      "location": location,
      "price": price,
    };
  }
}

class ResData {
  ResData({this.description, this.name, this.location,this.service,this.picture, this.town,this.price});

  final String description;
  final String name;
  final String service;
  final String town;
  final String picture;
  final String price;
  final location;

  Map<String, dynamic> getResDataMap() {
    return {
      "description": description,
      "name": name,
      "service": service,
      "location": location,
      "picture":picture,
      "town": town,
      "price": price
    };
  }
}
