class Doctor {
  var id;
  var firstName;
  var lastName;
  var token;

  Doctor({
    this.id,
    this.firstName,
    this.lastName
  });

  void setUser(String token, Map user) {
    this.token = token;
    this.id = user['id'];
    this.firstName = user['first_name'];
    this.lastName = user['last_name'];
  }

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
    );
  }

  String getFullName() => (this.firstName + ', ' + this.lastName);
}
