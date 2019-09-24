class FuturePlan {
  var id;
  var title;
  var description;

  FuturePlan({this.id,this.title, this.description});

  factory FuturePlan.fromJson(Map<String, dynamic> json) {
    return FuturePlan(
      id: json['id'],
      title: json['title'],
      description: json['description'],
    );
  }
}