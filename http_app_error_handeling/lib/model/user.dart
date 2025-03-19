class User {
  //name,email,thumbnail
  final String name;
  final String email;
  final String thumbnail;

  User({required this.name, required this.email, required this.thumbnail});
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        name:
            "${json['results'][0]['name']['first']} ${json['results'][0]['name']['last']}",
        email: json['results'][0]['email'],
        thumbnail: json['results'][0]['picture']['thumbnail']);
  }
}
