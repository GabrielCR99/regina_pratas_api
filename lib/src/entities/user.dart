class User {
  final int? id;
  final String? name;
  final String? email;
  final String? password;
  final String? phone;
  final String? document;
  final String? about;
  final String? registerType;
  final String? userRole;
  final String? androidToken;
  final String? iosToken;
  final String? refreshToken;
  final String? imageAvatar;
  final String? socialKey;

  const User({
    this.id,
    this.name,
    this.email,
    this.password,
    this.phone,
    this.document,
    this.about,
    this.registerType,
    this.userRole,
    this.androidToken,
    this.iosToken,
    this.refreshToken,
    this.imageAvatar,
    this.socialKey,
  });

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? password,
    String? phone,
    String? about,
    String? registerType,
    String? userRole,
    String? androidToken,
    String? iosToken,
    String? refreshToken,
    String? imageAvatar,
    String? socialKey,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      about: about ?? this.about,
      registerType: registerType ?? this.registerType,
      userRole: userRole ?? this.userRole,
      androidToken: androidToken ?? this.androidToken,
      iosToken: iosToken ?? this.iosToken,
      refreshToken: refreshToken ?? this.refreshToken,
      imageAvatar: imageAvatar ?? this.imageAvatar,
      socialKey: socialKey ?? this.socialKey,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is User &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.password == password &&
        other.phone == phone &&
        other.document == document &&
        other.about == about &&
        other.registerType == registerType &&
        other.userRole == userRole &&
        other.androidToken == androidToken &&
        other.iosToken == iosToken &&
        other.refreshToken == refreshToken &&
        other.imageAvatar == imageAvatar &&
        other.socialKey == socialKey;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        password.hashCode ^
        phone.hashCode ^
        document.hashCode ^
        about.hashCode ^
        registerType.hashCode ^
        userRole.hashCode ^
        androidToken.hashCode ^
        iosToken.hashCode ^
        refreshToken.hashCode ^
        imageAvatar.hashCode ^
        socialKey.hashCode;
  }
}
