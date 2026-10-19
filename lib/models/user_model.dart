class UserModel {
  final String profileId;
  final String username;
  final String token;

  UserModel({
    required this.profileId,
    required this.username,
    required this.token,
  });

  static String _asString(dynamic value) {
    if (value == null) {
      return '';
    }

    final text = value.toString().trim();
    if (text.isEmpty || text == 'null' || text == 'undefined') {
      return '';
    }

    return text;
  }

  static String _extractToken(Map<String, dynamic> json) {
    final maps = <Map<String, dynamic>>[json];
    final nested = json['data'];
    if (nested is Map<String, dynamic>) {
      maps.add(nested);
    }

    const keys = <String>[
      'access_token',
      'token',
      'jwt',
      'accessToken',
    ];

    for (final map in maps) {
      for (final key in keys) {
        var value = _asString(map[key]);
        if (value.isEmpty) {
          continue;
        }

        if (value.toLowerCase().startsWith('bearer ')) {
          value = value.substring(7).trim();
        }

        if (value.split('.').length == 3) {
          return value;
        }
      }
    }

    return '';
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      profileId: _asString(json['profile_id'] ?? json['profileId']),
      username: _asString(json['username']),
      token: _extractToken(json),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'profile_id': profileId,
      'username': username,
      'token': token,
    };
  }
}
