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
