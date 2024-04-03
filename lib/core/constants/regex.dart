class Regex {
  static final tagRegex = RegExp(r'^[a-zA-Z áčďéěíňóřšťúůýžÁČĎÉĚÍŇÓŘŠŤÚŮÝŽ]*$');

  static final alphabetRegex =
      RegExp(r'^[a-zA-ZáčďéěíňóřšťúůýžÁČĎÉĚÍŇÓŘŠŤÚŮÝŽ]*$');

  static final usernameRegex = RegExp(r'^[0-9a-zA-Z_.-]*$');

  static final simpleTextRegex =
      RegExp(r'^[0-9a-zA-Z áčďéěíňóřšťúůýžÁČĎÉĚÍŇÓŘŠŤÚŮÝŽ]*$');

  static final textRegex = RegExp(
      r'^[0-9a-zA-ZáčďéěíňóřšťúůýžÁČĎÉĚÍŇÓŘŠŤÚŮÝŽ .,!?:;/_+*-=#^<>—(){}\[\]]*$');

  static final multilineTextRegex = RegExp(
      r'^[0-9a-zA-ZáčďéěíňóřšťúůýžÁČĎÉĚÍŇÓŘŠŤÚŮÝŽ .,…!?:;/_+*-=#^<>—()\\\n\\\r{}\[\]]*$');

  static final emailRegex = RegExp(
      r"^[a-zA-ZZáčďéěíňóřšťúůýžÁČĎÉĚÍŇÓŘŠŤÚŮÝŽ0-9._%+-]+@[a-zA-ZZáčďéěíňóřšťúůýžÁČĎÉĚÍŇÓŘŠŤÚŮÝŽ0-9.-]+\.[a-zA-Z]{2,}$");

  /// Phone number may start with a plus sign and 3 digits and must end with 9 digits
  static final RegExp phoneNumberRegex = RegExp(r'(^([+][0-9]{3})?[0-9]{9}$)');

  /// Characters which are considered special characters in passwords
  static const allowedPasswordSpecialCharacters = r'+-/!@#$%^&*(),.-?!":{}|<>_';

  /// Regular expression for password special character
  static final RegExp passwordSpecialCharRegex =
      RegExp(r'[' + allowedPasswordSpecialCharacters + r']');

  /// Regular expression for password
  static final RegExp passwordRegex = RegExp(
      r'^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[' +
          allowedPasswordSpecialCharacters +
          r']).{8,}$');
}
