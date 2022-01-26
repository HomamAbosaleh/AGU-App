import 'package:final_project/model/course.dart';
import 'package:final_project/model/department.dart';
import 'package:final_project/services/firestore.dart';
import 'package:final_project/theme/theme_manager.dart';
import 'package:final_project/widgets/dialogbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddCourseScreen extends StatefulWidget {
  bool admin = false;
  String courseUID = '';
  AddCourseScreen({Key? key, this.admin = false, this.courseUID = ''})
      : super(key: key);

  @override
  _AddCourseScreenState createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  final departments = FireStore().getAllDepartments();
  late Future course = isEditMode(widget.courseUID);
  bool editMode = false;
  bool loaded = false;

  final ScrollController _scrollController = ScrollController();

  final TextEditingController _codeTxtController = TextEditingController();
  final TextEditingController _nameTxtController = TextEditingController();
  TextEditingController _creditTxtController = TextEditingController();
  final TextEditingController _ectsTxtController = TextEditingController();

  final List<FocusNode> fNodes = List.generate(5, (index) => FocusNode());

  final List<TextEditingController> _locsTxtControllers = [
    TextEditingController()
  ];
  final List<TextEditingController> _labLocsTxtControllers = [
    TextEditingController()
  ];
  final List<TextEditingController> _instTxtControllers = [
    TextEditingController()
  ];

  final List<FocusNode> _locsNodes = [FocusNode()];
  final List<FocusNode> _labLocsNodes = [FocusNode()];
  final List<FocusNode> _instNodes = [FocusNode()];

  Department? department;

  int numOfLocs = 1;
  int numOfLabLocs = 1;
  int numOfInst = 1;

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    fNodes.forEach((element) {
      element.dispose();
    });
    _locsNodes.forEach((element) {
      element.dispose();
    });
    _labLocsNodes.forEach((element) {
      element.dispose();
    });
    _instNodes.forEach((element) {
      element.dispose();
    });
    super.dispose();
  }

  Future isEditMode(String uid) async {
    try {
      if (uid.isEmpty) {
        editMode = false;
      } else {
        editMode = true;
        return FireStore().getCourseToApprove(widget.courseUID);
      }
    } catch (e) {
      alertDialog(context, "Errorr", e.toString());
      course = FireStore().getCoursesToApprove();
    }
  }

  getCourse(snapshot, depData) async {
    try {
      _codeTxtController.text = snapshot['code'];
      _nameTxtController.text = snapshot['name'];
      _creditTxtController.text = snapshot['credit'].toString();
      _ectsTxtController.text = snapshot['ects'].toString();
      depData.forEach((element) {
        if (element.name == snapshot['department']) {
          department = element;
        }
      });

      int i = 0;
      snapshot['locations'].forEach((element) {
        i++;
        if (i > 1) {
          _locsTxtControllers.add(TextEditingController());
          _locsNodes.add(FocusNode());
          numOfLocs++;
        }
        _locsTxtControllers[i - 1].text = element.toString();
      });

      i = 0;
      snapshot['labLocations'].forEach((element) {
        i++;
        if (i > 1) {
          _labLocsTxtControllers.add(TextEditingController());
          _labLocsNodes.add(FocusNode());
          numOfLabLocs++;
        }
        _labLocsTxtControllers[i - 1].text = element.toString();
      });

      i = 0;
      snapshot['instructors'].forEach((element) {
        i++;
        if (i > 1) {
          _instTxtControllers.add(TextEditingController());
          _instNodes.add(FocusNode());
          numOfInst++;
        }
        _instTxtControllers[i - 1].text = element.toString();
      });
    } catch (e) {
      alertDialog(context, "Error", e.toString());
    }
  }

  addCourseToQueue(bool fastSend) async {
    if (formKey.currentState!.validate()) {
      if (_codeTxtController.text.isEmpty ||
          _nameTxtController.text.isEmpty ||
          _creditTxtController.text.isEmpty ||
          _ectsTxtController.text.isEmpty ||
          department == null) {
        alertDialog(
            context, "Incomplete Information", "Please fill in all the fields");
      } else {
        try {
          List<String> locStrings = [];
          int locs = 0;
          _locsTxtControllers.forEach((element) {
            if (element.text.isNotEmpty) {
              locStrings.add(element.text);
              locs++;
            }
          });
          if (locs == 0) {
            locStrings = [''];
          }

          List<String> labLocStrings = [];
          int labLocs = 0;
          _labLocsTxtControllers.forEach((element) {
            if (element.text.isNotEmpty) {
              labLocStrings.add(element.text);
              labLocs++;
            }
          });
          if (labLocs == 0) {
            labLocStrings = [''];
          }

          List<String> instStrings = [];
          int insts = 0;
          _instTxtControllers.forEach((element) {
            if (element.text.isNotEmpty) {
              instStrings.add(element.text);
              insts++;
            }
          });
          if (insts == 0) {
            instStrings = [''];
          }

          Course course = Course(
            code: _codeTxtController.text.toUpperCase(),
            name: _nameTxtController.text,
            credit: int.parse(_creditTxtController.text),
            ects: int.parse(_ectsTxtController.text),
            department: department!.name,
            locations: locStrings,
            labLocations: labLocStrings,
            instructors: instStrings,
          );
          if (fastSend) {
            int result = await FireStore().addCourse(course: course);
            if (result == 1) {
              alertDialog(context, "Course added successfully!", "Noice");
            } else {
              alertDialog(
                  context, "Course already exists", "Please check database");
            }
          } else {
            int result =
                await FireStore().addCourseToBeApproved(course: course);
            if (result == 1) {
              alertDialog(context, "Course send for approval successfully!",
                  "Thank you for your help!");
            } else {
              alertDialog(context, "Error",
                  "An error occurred while sending the course for approval.");
            }
          }
        } catch (e) {
          alertDialog(context, "Cannot Sign Up", e.toString());
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Add a course!'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              addCourseToQueue(false);
            },
            child: const Text('Send for approval'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        controller: _scrollController,
        child: Column(
          children: [
            FutureBuilder(
              future: Future.wait([departments, course]),
              builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                if (snapshot.hasData) {
                  if (editMode && !loaded) {
                    getCourse(snapshot.data![1], snapshot.data![0]);
                    loaded = true;
                  }
                  return ListView(
                    shrinkWrap: true,
                    controller: _scrollController,
                    children: [
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            requiredInput(snapshot),
                            const Divider(
                              height: 40,
                              color: Colors.black,
                              thickness: 1.2,
                            ),
                            optionalInput(snapshot),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget requiredInput(AsyncSnapshot snapshot) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Required',
              style:
                  Theme.of(context).textTheme.headline5!.copyWith(fontSize: 26),
            ),
            const Spacer(),
            widget.admin
                ? TextButton(
                    onPressed: () {
                      addCourseToQueue(true);
                    },
                    child: const Text('Add course immediately'),
                  )
                : const Spacer(),
          ],
        ),
        const SizedBox(height: 7),
        Row(
          children: [
            SizedBox(
              width: 30,
              child: FittedBox(
                  child: Padding(
                padding: EdgeInsets.all(2.0),
                child: FaIcon(
                  FontAwesomeIcons.code,
                  color: Theme.of(context).colorScheme.surface,
                ),
              )),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(fNodes[1]);
                },
                focusNode: fNodes[0],
                style: TextStyle(
                  fontFamily: 'Roboto',
                  color: Theme.of(context).colorScheme.onSecondary,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
                cursorColor: Theme.of(context).colorScheme.primary,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[A-Za-z0-9]")),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter the code';
                  }
                  return null;
                },
                controller: _codeTxtController,
                decoration: InputDecoration(
                  enabledBorder:
                      Theme.of(context).inputDecorationTheme.enabledBorder,
                  focusedBorder:
                      Theme.of(context).inputDecorationTheme.focusedBorder,
                  hintText: 'Code',
                  hintStyle: TextStyle(
                    color: Theme.of(context).colorScheme.secondaryVariant,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                  suffix: const Text('eg. \'COMP101\''),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 7),
        Row(
          children: [
            SizedBox(
              width: 30,
              child: FittedBox(
                  child: Padding(
                padding: EdgeInsets.all(2.0),
                child: FaIcon(
                  FontAwesomeIcons.pencilAlt,
                  color: Theme.of(context).colorScheme.surface,
                ),
              )),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(fNodes[2]);
                },
                focusNode: fNodes[1],
                style: TextStyle(
                  fontFamily: 'Roboto',
                  color: Theme.of(context).colorScheme.onSecondary,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
                cursorColor: Theme.of(context).colorScheme.primary,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter the name';
                  }
                  return null;
                },
                controller: _nameTxtController,
                decoration: InputDecoration(
                  enabledBorder:
                      Theme.of(context).inputDecorationTheme.enabledBorder,
                  focusedBorder:
                      Theme.of(context).inputDecorationTheme.focusedBorder,
                  hintText: 'Name',
                  hintStyle: TextStyle(
                    color: Theme.of(context).colorScheme.secondaryVariant,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                  suffix: const Text('eg. \'Art of Computing\''),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 7),
        Row(
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints.tightFor(width: 40, height: 40),
              child: ElevatedButton(
                child: const Icon(
                  Icons.remove,
                ),
                onPressed: () {
                  try {
                    int num = int.parse(_creditTxtController.text);
                    _creditTxtController = TextEditingController();
                    if (num > 0) {
                      num--;
                      setState(() {
                        _creditTxtController.text = num.toString();
                      });
                    }
                  } catch (e) {
                    setState(() {
                      _creditTxtController.text = '0';
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: rPrimaryRedColor,
                  shape: const CircleBorder(),
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: TextFormField(
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(fNodes[3]);
                },
                focusNode: fNodes[2],
                style: TextStyle(
                  fontFamily: 'Roboto',
                  color: Theme.of(context).colorScheme.onSecondary,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
                cursorColor: Theme.of(context).colorScheme.primary,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                ],
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter the credit';
                  }
                  return null;
                },
                controller: _creditTxtController,
                decoration: InputDecoration(
                  enabledBorder:
                      Theme.of(context).inputDecorationTheme.enabledBorder,
                  focusedBorder:
                      Theme.of(context).inputDecorationTheme.focusedBorder,
                  hintText: 'Credit',
                  hintStyle: TextStyle(
                    color: Theme.of(context).colorScheme.secondaryVariant,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            ConstrainedBox(
              constraints: const BoxConstraints.tightFor(width: 40, height: 40),
              child: ElevatedButton(
                child: const Icon(
                  Icons.add,
                ),
                onPressed: () {
                  setState(() {
                    try {
                      print(_creditTxtController.text);
                      int num = int.parse(_creditTxtController.text);
                      if (num < 120) {
                        num++;
                        _creditTxtController.text = num.toString();
                        print(_creditTxtController.text);
                      }
                    } catch (e) {
                      _creditTxtController.text = '1';
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  primary: rPrimaryRedColor,
                  shape: const CircleBorder(),
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
            const SizedBox(width: 10),
            ConstrainedBox(
              constraints: const BoxConstraints.tightFor(width: 40, height: 40),
              child: ElevatedButton(
                child: const Icon(
                  Icons.remove,
                ),
                onPressed: () {
                  setState(() {
                    try {
                      int num = int.parse(_ectsTxtController.text);
                      if (num > 0) {
                        num--;
                        _ectsTxtController.text = num.toString();
                      }
                    } catch (e) {
                      _ectsTxtController.text = '0';
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  primary: rPrimaryRedColor,
                  shape: const CircleBorder(),
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: TextFormField(
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(fNodes[4]);
                },
                focusNode: fNodes[3],
                style: TextStyle(
                  fontFamily: 'Roboto',
                  color: Theme.of(context).colorScheme.onSecondary,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
                cursorColor: Theme.of(context).colorScheme.primary,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter the ECTS';
                  }
                  return null;
                },
                controller: _ectsTxtController,
                decoration: InputDecoration(
                  enabledBorder:
                      Theme.of(context).inputDecorationTheme.enabledBorder,
                  focusedBorder:
                      Theme.of(context).inputDecorationTheme.focusedBorder,
                  hintText: 'ECTS',
                  hintStyle: TextStyle(
                    color: Theme.of(context).colorScheme.secondaryVariant,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            ConstrainedBox(
              constraints: const BoxConstraints.tightFor(width: 40, height: 40),
              child: ElevatedButton(
                child: const Icon(
                  Icons.add,
                ),
                onPressed: () {
                  setState(() {
                    try {
                      int num = int.parse(_ectsTxtController.text);
                      if (num < 120) {
                        num++;
                        _ectsTxtController.text = num.toString();
                      }
                    } catch (e) {
                      _ectsTxtController.text = '1';
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  primary: rPrimaryRedColor,
                  shape: const CircleBorder(),
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 7),
        Row(
          children: [
            SizedBox(
              width: 30,
              child: FittedBox(
                  child: Padding(
                padding: EdgeInsets.all(2.0),
                child: FaIcon(
                  FontAwesomeIcons.graduationCap,
                  color: Theme.of(context).colorScheme.surface,
                ),
              )),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: DropdownButtonFormField<dynamic>(
                focusNode: fNodes[4],
                isExpanded: true,
                value: department,
                items: snapshot.data[0]
                    .map<DropdownMenuItem<dynamic>>(dropDownBuilder)
                    .toList(),
                hint: Text(
                  "Department",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondaryVariant,
                  ),
                ),
                selectedItemBuilder: (BuildContext context) {
                  return snapshot.data[0].map<Widget>((dynamic item) {
                    return Text(
                      item.name,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    );
                  }).toList();
                },
                validator: (value) {
                  if (value == null) {
                    return 'Choose a department';
                  }
                  return null;
                },
                iconEnabledColor: Theme.of(context).hoverColor,
                iconDisabledColor: Theme.of(context).iconTheme.color,
                onChanged: (value) {
                  setState(() {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    department = value;
                  });
                },
                dropdownColor: Theme.of(context).colorScheme.onSurface,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  color: Theme.of(context).colorScheme.onSecondary,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget optionalInput(AsyncSnapshot snapshot) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Optional',
          style: Theme.of(context).textTheme.headline5!.copyWith(fontSize: 26),
        ),
        const SizedBox(height: 7),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: numOfLocs,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Row(
              children: [
                SizedBox(
                  width: 30,
                  child: FittedBox(
                      child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: FaIcon(
                      FontAwesomeIcons.mapMarkerAlt,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  )),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 7),
                    child: TextFormField(
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                      cursorColor: Theme.of(context).colorScheme.primary,
                      focusNode: _locsNodes[index],
                      controller: _locsTxtControllers[index],
                      decoration: InputDecoration(
                        enabledBorder: Theme.of(context)
                            .inputDecorationTheme
                            .enabledBorder,
                        focusedBorder: Theme.of(context)
                            .inputDecorationTheme
                            .focusedBorder,
                        hintText: 'Location',
                        hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.secondaryVariant,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                        suffix: const Text('eg. \'Online\''),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 7),
                index != 0
                    ? ConstrainedBox(
                        constraints: const BoxConstraints.tightFor(
                            width: 40, height: 40),
                        child: ElevatedButton(
                          child: const Icon(
                            Icons.remove,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              if (numOfLocs > 0) {
                                numOfLocs--;
                                _locsTxtControllers.removeLast();
                                _locsNodes.removeLast();
                              }
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            primary: rPrimaryRedColor,
                            shape: const CircleBorder(),
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      )
                    : ConstrainedBox(
                        constraints: const BoxConstraints.tightFor(
                            width: 40, height: 40),
                        child: ElevatedButton(
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              if (numOfLocs < 6) {
                                numOfLocs++;
                                _locsTxtControllers
                                    .add(TextEditingController());
                                _locsNodes.add(FocusNode());
                              }
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            primary: rPrimaryRedColor,
                            shape: const CircleBorder(),
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ),
              ],
            );
          },
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: numOfLabLocs,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Row(
              children: [
                SizedBox(
                  width: 30,
                  child: FittedBox(
                      child: Padding(
                    padding: EdgeInsets.all(2.0),
                    child: FaIcon(
                      FontAwesomeIcons.vest,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  )),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 7),
                    child: TextFormField(
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                      cursorColor: Theme.of(context).colorScheme.primary,
                      focusNode: _labLocsNodes[index],
                      controller: _labLocsTxtControllers[index],
                      decoration: InputDecoration(
                        enabledBorder: Theme.of(context)
                            .inputDecorationTheme
                            .enabledBorder,
                        focusedBorder: Theme.of(context)
                            .inputDecorationTheme
                            .focusedBorder,
                        hintText: 'Lab Location',
                        hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.secondaryVariant,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                        suffix: const Text('eg. \'Comp Lab\''),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 7),
                index != 0
                    ? ConstrainedBox(
                        constraints: const BoxConstraints.tightFor(
                            width: 40, height: 40),
                        child: ElevatedButton(
                          child: const Icon(
                            Icons.remove,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              if (numOfLabLocs > 0) {
                                numOfLabLocs--;
                                _labLocsTxtControllers.removeLast();
                                _labLocsNodes.removeLast();
                              }
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            primary: rPrimaryRedColor,
                            shape: const CircleBorder(),
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      )
                    : ConstrainedBox(
                        constraints: const BoxConstraints.tightFor(
                            width: 40, height: 40),
                        child: ElevatedButton(
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              if (numOfLabLocs < 6) {
                                numOfLabLocs++;
                                _labLocsTxtControllers
                                    .add(TextEditingController());
                                _labLocsNodes.add(FocusNode());
                              }
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            primary: rPrimaryRedColor,
                            shape: const CircleBorder(),
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ),
              ],
            );
          },
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: numOfInst,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Row(
              children: [
                SizedBox(
                  width: 30,
                  child: FittedBox(
                      child: Padding(
                    padding: EdgeInsets.all(2.0),
                    child: FaIcon(
                      FontAwesomeIcons.userTie,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  )),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 7),
                    child: TextFormField(
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                      cursorColor: Theme.of(context).colorScheme.primary,
                      focusNode: _instNodes[index],
                      controller: _instTxtControllers[index],
                      decoration: InputDecoration(
                        enabledBorder: Theme.of(context)
                            .inputDecorationTheme
                            .enabledBorder,
                        focusedBorder: Theme.of(context)
                            .inputDecorationTheme
                            .focusedBorder,
                        hintText: 'Instructor',
                        hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.secondaryVariant,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 7),
                index != 0
                    ? ConstrainedBox(
                        constraints: const BoxConstraints.tightFor(
                            width: 40, height: 40),
                        child: ElevatedButton(
                          child: const Icon(
                            Icons.remove,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              if (numOfInst > 0) {
                                numOfInst--;
                                _instTxtControllers.removeLast();
                                _instNodes.removeLast();
                              }
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            primary: rPrimaryRedColor,
                            shape: const CircleBorder(),
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      )
                    : ConstrainedBox(
                        constraints: const BoxConstraints.tightFor(
                            width: 40, height: 40),
                        child: ElevatedButton(
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              if (numOfInst < 10) {
                                numOfInst++;
                                _instTxtControllers
                                    .add(TextEditingController());
                                _instNodes.add(FocusNode());
                              }
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            primary: rPrimaryRedColor,
                            shape: const CircleBorder(),
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ),
              ],
            );
          },
        ),
      ],
    );
  }

  DropdownMenuItem<dynamic> dropDownBuilder(item) {
    return DropdownMenuItem(
      value: item,
      child: Text(item.name, style: Theme.of(context).textTheme.headline4),
    );
  }
}
