import 'package:flutter/material.dart';

import '../services/firestore.dart';
import '../model/faculty.dart';

class FacultiesPage extends StatefulWidget {
  const FacultiesPage({Key? key}) : super(key: key);

  @override
  _FacultiesPageState createState() => _FacultiesPageState();
}

class _FacultiesPageState extends State<FacultiesPage> {
  final Future faculties = FireStore().getFaculties();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: faculties,
      builder: (context, AsyncSnapshot snapShot) {
        if (snapShot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Faculties'),
            ),
            body: SingleChildScrollView(
              child: Center(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: snapShot.data.docs.length,
                    itemBuilder: (context, index) {
                      return CustomDropdown(
                        text: snapShot.data.docs[index].id,
                        dropdowns: snapShot.data.docs[index]["Departments"]
                            .map<String>((e) => e.toString())
                            .toList(),
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class CustomDropdown extends StatefulWidget {
  final List<String> dropdowns;
  final String text;

  const CustomDropdown({Key? key, required this.text, required this.dropdowns})
      : super(key: key);

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  bool isDropdownOpened = false;
  IconData iconDrop = Icons.arrow_drop_down;

  List<DropDownItem> dropdownItems = [];

  @override
  void initState() {
    super.initState();
    initlizeList();
  }

  void initlizeList() {
    if (widget.dropdowns.length == 1) {
      dropdownItems.add(DropDownItem.only(
          text: widget.dropdowns[0], iconData: Icons.school_sharp));
      return;
    }
    for (int i = 0; i < widget.dropdowns.length; i++) {
      if (i == 0) {
        dropdownItems.add(DropDownItem.first(
            text: widget.dropdowns[i], iconData: Icons.school_sharp));
      } else if (i == widget.dropdowns.length - 1) {
        dropdownItems.add(DropDownItem.last(
            text: widget.dropdowns[i], iconData: Icons.school_sharp));
      } else {
        dropdownItems.add(DropDownItem(
            text: widget.dropdowns[i], iconData: Icons.school_sharp));
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
              : const SizedBox(),
        ],
      ),
    );
  }
}

class DropDown extends StatelessWidget {
  final List<DropDownItem> dropdownItems;

  const DropDown({Key? key, required this.dropdownItems}) : super(key: key);

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
            top: isFirstItem || isOnlyItem
                ? const Radius.circular(4)
                : Radius.zero,
            bottom: isLastItem || isOnlyItem
                ? const Radius.circular(4)
                : Radius.zero,
          ),
        ),
      ),
      onPressed: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Text(
              text.toUpperCase(),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600),
            ),
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
