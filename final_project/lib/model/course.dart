import 'package:flutter/material.dart';

class Course {
  String code = "";
  String name = "";
  int credit = 0;
  int ects = 0;
  List<String> locations = [""];
  List<String> instructors = [""];
  List<String> labLocations = [""];
  String department = "";
  IconData iconName = Icons.clear;
  final Map _icons = {
    "Computer Engineering": Icons.computer,
    "Electrical & Electronics Engineering": Icons.electrical_services_sharp,
    "Architecture": Icons.architecture,
    "Industrial Engineering": Icons.settings_applications_sharp,
    "Mechanical Engineering": Icons.car_repair,
    "Civil Engineering": Icons.home,
    "Political Science & International Relations": Icons.flag,
    "Psychology": Icons.wheelchair_pickup,
    "Molecular Biology & Genetic": Icons.clear,
    "Bioengineering": Icons.accessibility_new,
    "Business Administration": Icons.business_center_sharp,
    "Economy": Icons.monetization_on,
  };
  Course(
      {required this.code,
      required this.name,
      required this.credit,
      required this.ects,
      required this.locations,
      required this.instructors,
      required this.labLocations,
      required this.department}) {
    _icons.forEach((key, value) {
      if (key == department) {
        iconName = value;
        return;
      }
    });
  }

  Course.withA();
  IconData getIcon(String depart) {
    IconData iconToReturn;
    try {
      iconToReturn = _icons[depart];
    } catch (ex) {
      iconToReturn = Icons.clear;
    }
    return iconToReturn;
  }
}
