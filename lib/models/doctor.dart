class Doctor {
  var id;
  var email;
  var hierarchy;
  var firstName;
  var lastName;
  var token;

  Doctor({
    this.id,
    this.email,
    this.hierarchy,
    this.firstName,
    this.lastName,
    this.token,
  });

  void setUser(String token, Map user) {
    this.token = token;
    this.id = user['id'];
    this.firstName = user['first_name'];
    this.lastName = user['last_name'];
  }

  factory Doctor.fromJson(Map<String, dynamic> json, String token) {
    return Doctor(
      id: json['id'],
      email: json['email'],
      hierarchy: json['hierarchy'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      token: token,
    );
  }

  @override
  String toString() {
    return '{id: $id, email: $email, hierarchy: $hierarchy, first_name: $firstName, last_name: $lastName, token: $token}';
  }

  String getFullName() => (this.firstName + ', ' + this.lastName);
}
