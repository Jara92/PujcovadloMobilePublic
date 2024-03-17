class Regex {
/*  static final textRegex =
      RegExp("[ěščřžýáíéóúůďťňĎŇŤŠČŘŽÝÁÍÉÚŮĚÓa-zA-Z]");*/
  /*static final textRegex = RegExp(r'[\p{L}a-zA-Z]+');*/
  //static final textRegex = RegExp(r'^[a-zA-Z0-9\s]+$');
  static final textRegex = RegExp(
      r'^[0-9a-zA-ZáčďéěíňóřšťúůýžÁČĎÉĚÍŇÓŘŠŤÚŮÝŽ .,!?:;/_+*-=#^<>—(){}\[\]]*$');
  static final multilineTextRegex = RegExp(
      r'^[0-9a-zA-ZáčďéěíňóřšťúůýžÁČĎÉĚÍŇÓŘŠŤÚŮÝŽ .,!?:;/_+*-=#^<>—()\\\n\\\r{}\[\]]*$');
//static final textRegex = RegExp('[.,/\-()[]{}?!:;_+=#@^<>"ěščřžýáíéóúůďťňĎŇŤŠČŘŽÝÁÍÉÚŮĚÓa-zA-Z]+\$');
}
