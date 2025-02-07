class UserModel {
  String name;
  String email;
  String password;
  String confirmPassword;
  String phoneNumber;

  UserModel({
    this.name = '',
    this.email = '',
    this.password = '',
    this.phoneNumber = '',
    this.confirmPassword=''
  });
}