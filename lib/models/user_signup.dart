class UserSignUp {
  final String? first_name;
  final String? last_name;
  final String? email;
  final String? password;

  const UserSignUp({
    this.first_name,
    this.last_name,
    this.email,
    this.password,
  });

  factory UserSignUp.fromJSon(Map<String, dynamic> json) {
    return UserSignUp(
      first_name: json['first_name'],
      last_name: json['last_name'],
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': first_name,
      'last_name': last_name,
      'email': email,
      'password': password
    };
  }
}
