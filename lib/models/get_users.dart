class GerUsers {
  final String? email;
  final String? firstName;
  final String? lastName;
  final int? user_id;

  GerUsers({this.email, this.firstName, this.lastName, this.user_id});

  factory GerUsers.fromJSon(Map<String, dynamic> json) {
    return GerUsers(
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      user_id: json['id'],
    );
  }
}
