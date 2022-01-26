import 'package:final_project/theme/theme_manager.dart';
import 'package:flutter/material.dart';

newAlertDialog(BuildContext context, String head, String body,
    [Icon icon = const Icon(
      Icons.warning_amber_outlined,
      size: 32,
      color: Colors.white,
    ),
    Color iconColor = rPrimaryRedColor]) {
  // set up the AlertDialog
  Dialog alert = Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
    child: Stack(
      overflow: Overflow.visible,
      alignment: Alignment.topCenter,
      children: [
        Container(
          height: 230,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
            child: Column(
              children: [
                Text(
                  head,
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(fontSize: 16),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  body,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: 20),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: rPrimaryRedColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text(
                    'Okay',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
        Positioned(
          top: -60,
          child: CircleAvatar(
            backgroundColor: iconColor,
            radius: 60,
            child: icon,
          ),
        ),
      ],
    ),
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
