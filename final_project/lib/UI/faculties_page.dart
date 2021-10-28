import 'package:flutter/material.dart';

class FacultiesPage extends StatefulWidget {
  const FacultiesPage({Key? key}) : super(key: key);

  @override
  _FacultiesPageState createState() => _FacultiesPageState();
}

class _FacultiesPageState extends State<FacultiesPage> {
  String dropdownvalue = 'choice 1';
  List deps = [
    'Computer Engineering',
    'Civil Engineering',
    'Electrical Engineering'
  ];
  List deps2 = ['Architecture'];
  List deps3 = ['Business Administration', 'Economy'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Faculties'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: const [
                CustomDropdown(text: 'Faculty of Engineering'),
                SizedBox(height: 30),
                CustomDropdown(text: 'Faculty of Architecture'),
                // SizedBox(height: 30),
                // CustomDropdown(text: 'Faculty of Managerial Sciences'),
                // SizedBox(height: 30),
                // CustomDropdown(text: 'test4'),
                // SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomDropdown extends StatefulWidget {
  final String text;

  const CustomDropdown({Key? key, required this.text}) : super(key: key);

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  bool isDropdownOpened = false;
  IconData iconDrop = Icons.arrow_drop_down;
  List<String> dropdowns = ['Tesdast1', 'Te2', 'Testsadaasd3'];

  List<DropDownItem> dropdownItems = [];

  @override
  void initState() {
    super.initState();
    initlizeList();
  }

  void initlizeList() {
    if (dropdowns.length == 1) {
      dropdownItems.add(DropDownItem.only(
          text: dropdowns[0], iconData: Icons.ac_unit_outlined));
      return;
    }
    for (int i = 0; i < dropdowns.length; i++) {
      if (i == 0) {
        dropdownItems.add(DropDownItem.first(
            text: dropdowns[i], iconData: Icons.ac_unit_outlined));
      } else if (i == dropdowns.length - 1) {
        dropdownItems.add(DropDownItem.last(
            text: dropdowns[i], iconData: Icons.ac_unit_outlined));
      } else {
        dropdownItems.add(
            DropDownItem(text: dropdowns[i], iconData: Icons.ac_unit_outlined));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isDropdownOpened) {
            iconDrop = Icons.arrow_drop_down;
          } else {
            iconDrop = Icons.arrow_drop_up;
          }
          isDropdownOpened = !isDropdownOpened;
        });
      },
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.red.shade600,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: Text(
                    widget.text.toUpperCase(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                //Spacer(),
                Icon(
                  iconDrop,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          isDropdownOpened
              ? DropDown(dropdownItems: dropdownItems)
              : SizedBox(),
        ],
      ),
    );
  }
}

class DropDown extends StatelessWidget {
  List<DropDownItem> dropdownItems = [];

  DropDown({Key? key, required this.dropdownItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(
          height: 15,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            children: <Widget>[...dropdownItems.map((e) => e)],
          ),
        ),
      ],
    );
  }
}

class DropDownItem extends StatelessWidget {
  final String text;
  final IconData iconData;
  final bool isSelected;
  final bool isFirstItem;
  final bool isLastItem;
  final bool isOnlyItem;

  const DropDownItem(
      {Key? key,
      required this.text,
      required this.iconData,
      this.isSelected = false,
      this.isFirstItem = false,
      this.isLastItem = false,
      this.isOnlyItem = false})
      : super(key: key);

  factory DropDownItem.first(
      {required String text, required IconData iconData}) {
    return DropDownItem(
      text: text,
      iconData: iconData,
      isFirstItem: true,
    );
  }

  factory DropDownItem.last(
      {required String text, required IconData iconData}) {
    return DropDownItem(
      text: text,
      iconData: iconData,
      isLastItem: true,
    );
  }

  factory DropDownItem.only(
      {required String text, required IconData iconData}) {
    return DropDownItem(
      text: text,
      iconData: iconData,
      isOnlyItem: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        elevation: 0,
        primary: Colors.red[400],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: isFirstItem || isOnlyItem ? Radius.circular(4) : Radius.zero,
            bottom: isLastItem || isOnlyItem ? Radius.circular(4) : Radius.zero,
          ),
        ),
      ),
      onPressed: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            text.toUpperCase(),
            style: const TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600),
          ),
          //Spacer(),
          Icon(
            iconData,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
