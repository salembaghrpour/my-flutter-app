class UserModel {
  final int id;
  final String username;
  final String? profileId;
  final String token;

  UserModel({
    required this.id,
    required this.username,
    this.profileId,
    required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      profileId: json['profile_id'],
      token: json['token'], // فرض بر این است که API توکن را برمی‌گرداند
    );
  }
}
