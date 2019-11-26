class Statistic {
  var diagnosis;
  var total;
  var percentage;
  var color;

  Statistic({this.diagnosis, this.total, this.percentage,this.color});

  factory Statistic.fromJson(Map<String, dynamic> json) {
    return Statistic(
      diagnosis: json['diagnosis'],
      total: json['total'],
      percentage: json['percentage'],
      color: json['color']
    );
  }
}