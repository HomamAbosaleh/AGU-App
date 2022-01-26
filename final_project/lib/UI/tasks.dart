import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../model/task.dart';
import '../services/sqllite.dart';

class Tasks extends StatefulWidget {
  const Tasks({Key? key}) : super(key: key);

  @override
  State<Tasks> createState() => _TasksBState();
}

class _TasksBState extends State<Tasks> {
  final textController = TextEditingController();
  FocusNode text = FocusNode();
  final formKey = GlobalKey<FormState>();
  Task locakTask = Task(body: "no", reminderIsSet: false);

  void updateTask() async {
    await Sqlite().update(
      Task(
          id: locakTask.id,
          body: locakTask.body,
          reminderIsSet: locakTask.reminderIsSet),
    );
    setState(() {
      locakTask = Task(body: "no", reminderIsSet: false);
    });
  }

  void insertTask() async {
    await Sqlite().insert(
      Task(body: locakTask.body, reminderIsSet: locakTask.reminderIsSet),
    );
    setState(() {
      locakTask = Task(body: "no", reminderIsSet: false);
    });
  }

  void setUpTimeZone() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(
      tz.getLocation(
        await FlutterNativeTimezone.getLocalTimezone(),
      ),
    );
  }

  @override
  void initState() {
    setUpTimeZone();
    super.initState();
  }

  @override
  void dispose() {
    text.dispose();
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        centerTitle: true,
        title: Form(
          key: formKey,
          child: TextFormField(
            focusNode: text,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter a non-empty task';
              }
              return null;
            },
            onSaved: (newValue) {
              textController.text = newValue!;
            },
            controller: textController,
            decoration: InputDecoration(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              hintText: 'Enter your task here',
              hintStyle: Theme.of(context).textTheme.caption,
              prefixIcon: Icon(
                Icons.text_snippet_outlined,
                color: Colors.grey[500],
              ),
            ),
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
      ),
      body: FutureBuilder(
        future: Sqlite().getTasks(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: UniqueKey(),
                    confirmDismiss: (direction) {
                      return showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Text(
                            'Delete',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          content: const Text(
                            'are you sure?',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                              child: const Text('No'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                              child: const Text("Yes"),
                            )
                          ],
                        ),
                      );
                    },
                    onDismissed: (direction) {
                      Sqlite().delete(snapshot.data[index].id);
                      const snackBar = SnackBar(
                        content: Text('You just deleted the task'),
                        duration: Duration(milliseconds: 700),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    child: Card(
                      color: locakTask.id == snapshot.data[index].id
                          ? Colors.grey[600]
                          : Colors.black87,
                      child: ListTile(
                        onLongPress: () {
                          setState(() {
                            textController.text = snapshot.data[index].body;
                            locakTask = snapshot.data[index];
                          });
                        },
                        title: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            snapshot.data[index].body,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        subtitle: Text(
                          DateFormat.MMMMEEEEd()
                              .format(DateTime.now())
                              .toString(),
                          style: const TextStyle(color: Colors.grey),
                        ),
                        trailing: TextButton(
                          onPressed: () async {
                            if (!snapshot.data[index].reminderIsSet) {
                              TimeOfDay? selectedTime;
                              final initialDate = DateTime.now();
                              final newDate = await showDatePicker(
                                context: context,
                                initialDate: initialDate,
                                firstDate: DateTime.now(),
                                lastDate: DateTime(DateTime.now().year + 5),
                                currentDate: DateTime(DateTime.now().day + 2),
                              );
                              if (newDate != null) {
                                selectedTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                              }
                              if (selectedTime != null && newDate != null) {
                                DateTime finalDate = DateTime(
                                  newDate.year,
                                  newDate.month,
                                  newDate.day,
                                  selectedTime.hour,
                                  selectedTime.minute,
                                );
                                setState(() {
                                  snapshot.data[index].reminderIsSet = true;
                                });
                                locakTask = snapshot.data[index];
                                updateTask();
                                LocalNotification.futureNotify(
                                  title: "Reminder",
                                  body: locakTask.body,
                                  date: finalDate,
                                );
                              }
                            } else {
                              setState(() {
                                snapshot.data[index].reminderIsSet = false;
                              });
                              locakTask = snapshot.data[index];
                              updateTask();
                            }
                          },
                          child: Text(
                              snapshot.data[index].reminderIsSet == false
                                  ? 'Set reminder'
                                  : 'Cancel reminder'),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Text(
                  'Nothing added',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (locakTask.id != null) {
            if (formKey.currentState!.validate()) {
              setState(() {
                locakTask.body = textController.text;
              });
              updateTask();
            }
          } else if (formKey.currentState!.validate()) {
            setState(() {
              locakTask.body = textController.text;
            });
            insertTask();
          }
          textController.clear();
          text.unfocus();
        },
        child: const Icon(
          Icons.save,
          color: Colors.white,
        ),
      ),
    );
  }
}

class LocalNotification {
  static final _notification = FlutterLocalNotificationsPlugin();

  static Future _notificationDetails() async => const NotificationDetails(
        android: AndroidNotificationDetails('channel id', 'channel name',
            channelDescription: 'channel description',
            importance: Importance.max,
            playSound: true,
            color: Colors.red),
        iOS: IOSNotificationDetails(),
      );

  static InitializationSettings initializeSettings() =>
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: IOSInitializationSettings(),
      );
  static void init() => _notification.initialize(initializeSettings());

  static Future notify(
      {required id, required String title, required String body}) async {
    _notification.show(
      id,
      title,
      body,
      await _notificationDetails(),
    );
  }

  static Future futureNotify(
      {required String title,
      required String body,
      required DateTime date}) async {
    _notification.zonedSchedule(0, title, body,
        tz.TZDateTime.from(date, tz.local), await _notificationDetails(),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }
}
