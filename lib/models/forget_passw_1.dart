class ForgetPassModel {
  String email = '';
  String otp = '';
  bool isLoading = false;

  void setEmail(String value) => email = value;
  void setOTP(String value) => otp = value;
  void setLoading(bool value) => isLoading = value;
}