class Regex {
  static final simpleTextRegex =
      RegExp(r'^[0-9a-zA-Z áčďéěíňóřšťúůýžÁČĎÉĚÍŇÓŘŠŤÚŮÝŽ]*$');

  static final textRegex = RegExp(
      r'^[0-9a-zA-ZáčďéěíňóřšťúůýžÁČĎÉĚÍŇÓŘŠŤÚŮÝŽ .,!?:;/_+*-=#^<>—(){}\[\]]*$');

  static final multilineTextRegex = RegExp(
      r'^[0-9a-zA-ZáčďéěíňóřšťúůýžÁČĎÉĚÍŇÓŘŠŤÚŮÝŽ .,!?:;/_+*-=#^<>—()\\\n\\\r{}\[\]]*$');
}
