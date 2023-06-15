class Regex {
  Regex._();

  static const String mobileNumberpatttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  static const String emailAddressPatttern =
      r'(^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$)';
  static const fullnamePattern = r'([A-Za-z])';
  static const String passwordPattern = r'(.{6,}$)';
  static const String otpPattern = r'(^([0-9]{4})$)';
  static const String pincodePattern = r'(^[1-9][0-9]{5}$)';
}
