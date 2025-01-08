import 'package:flutter/material.dart';

getDynamicHeight(BuildContext context, double percentage) {
  double height = MediaQuery.of(context).size.height;
  return height * percentage;
}

getDynamicWidth(BuildContext context, double percentage) {
  double width = MediaQuery.of(context).size.width;
  return width * percentage;
}
