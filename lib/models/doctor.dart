class Doctor {
  var firstName;
  var lastName;
  var token;

  void setUser(String token, Map user) {
    this.token = token;
    this.firstName = user['first_name'];
    this.lastName = user['last_name'];
  }

  String getFullName() => (this.firstName + ', ' + this.lastName);
}
