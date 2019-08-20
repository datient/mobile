class FuturePlan {
  var title;
  var description;

  FuturePlan({this.title, this.description});

  factory FuturePlan.fromJson(Map<String, dynamic> json) {
    return FuturePlan(
      title: json['title'],
      description: json['description'],
    );
  }
}