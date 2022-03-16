class ClassProfile {
  // ignore: non_constant_identifier_names
  String? username;
  // ignore: non_constant_identifier_names
  String? password;
  String? name;
  String? birthday;

  ClassProfile(
      // ignore: non_constant_identifier_names
      {
    required this.username,
    // ignore: non_constant_identifier_names
    required this.password,
    // ignore: non_constant_identifier_names
    required this.name,
    required this.birthday,
  });
  factory ClassProfile.fromJson(Map<String, dynamic> json) {
    return ClassProfile(
        username: json['username'],
        password: json['password'],
        name: json['nama'],
        birthday: json['tanggal_lahir']);
  }

  static void fromJSON(i) {}
}

List<ClassProfile> Profiles = [];
