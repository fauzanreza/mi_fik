import 'dart:convert';

Future<String> getFind(check) async {
  if (check == null || check.trim() == "") {
    return " ";
  } else {
    return check;
  }
}

String removeHtmlTags(String htmlString) {
  RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
  return htmlString.replaceAll(exp, '');
}

getContentLocObj(detail, loc) {
  if (detail != null && loc != null) {
    var tag = [
      {'type': 'name', 'detail': detail},
      {'type': 'coordinate', 'detail': loc}
    ];
    return json.encode(tag);
  } else {
    return null;
  }
}
