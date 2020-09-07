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
