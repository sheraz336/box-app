class UserModel {
  String? name;
  String email;
  String phoneNumber;
  String password;
  String? profileImage;

  UserModel({
    this.name,
    required this.email,
    required this.phoneNumber,
    required this.password,
    this.profileImage,
  });

  UserModel copyWith({
    String? name,
    String? email,
    String? phoneNumber,
    String? password,
    String? profileImage,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}
