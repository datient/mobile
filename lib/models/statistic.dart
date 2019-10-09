class Statistic {
  var diagnosis;
  var total;
  var percentage;

  Statistic({this.diagnosis, this.total, this.percentage});

  factory Statistic.fromJson(Map<String, dynamic> json) {
    return Statistic(
      diagnosis: json['diagnosis'],
      total: json['total'],
      percentage: json['percentage'],
    );
  }
}