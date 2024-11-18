import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pixieapp/const/colors.dart';
import 'package:go_router/go_router.dart';
import 'package:pixieapp/widgets/add_charactor_story.dart';
import 'package:pixieapp/widgets/add_favorites_bottomsheet.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _familyController = TextEditingController();
  String? childName;
  String? pronoun;
  String? dateOfBirth;
  List<dynamic> favoriteThings = [];
  String? motherName;
  String? fatherName;
  String? grandMotherName;
  String? grandFatherName;
  String? petDogName;
  User? user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchUserData();
    _nameController = TextEditingController(text: childName);
  }

  Future<void> _fetchUserData() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(user?.uid)
          .get();
      if (userDoc.exists) {
        setState(() {
          childName = userDoc.data()?['child_name'] ?? 'Zoe';
          pronoun = userDoc.data()?['gender'] ?? 'prefer not to say';
          Timestamp dobTimestamp = userDoc.data()?['dob'];
          DateTime dobDateTime = dobTimestamp.toDate();

          dateOfBirth = DateFormat('dd/MM/yyyy').format(dobDateTime);
          favoriteThings =
              List<String>.from(userDoc.data()?['storycharactors'] ?? []);

          List<dynamic> lovedOnes = userDoc.data()?['loved_once'] ?? [];

          for (var lovedOne in lovedOnes) {
            String? relation = lovedOne['relation'];
            String? name = lovedOne['name'];

            if (relation != null && name != null) {
              switch (relation) {
                case 'Mother':
                  motherName = name;
                  break;
                case 'Father':
                  fatherName = name;
                  break;
                case 'Grand mother':
                  grandMotherName = name;
                  break;
                case 'Grand father':
                  grandFatherName = name;
                  break;
                case 'Female friend':
                  petDogName = name;
                  break;
                default:
                  break;
              }
            }
          }
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  void _editName() {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.kwhiteColor,
          title: Text(
            "Edit Name",
            style: theme.textTheme.bodyMedium,
          ),
          content: TextField(
            textCapitalization: TextCapitalization.sentences,
            style: theme.textTheme.bodyMedium,
            controller: _nameController,
            cursorColor: AppColors.textColorblue,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.kpurple)),
              hintText: "Update your name",
              hintStyle: theme.textTheme.bodyMedium,
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                "Cancel",
                style: theme.textTheme.bodyMedium,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                "Save",
                style: theme.textTheme.bodyMedium,
              ),
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(user?.uid)
                    .update({
                  'child_name': _nameController.text,
                });
                setState(() {
                  childName = _nameController.text;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _editDateOfBirth() {
    DateTime selectedDate = DateTime.now();

    showModalBottomSheet(
      backgroundColor: AppColors.bottomSheetBackground,
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 200,
                child: CupertinoTheme(
                  data: const CupertinoThemeData(
                    textTheme: CupertinoTextThemeData(
                      dateTimePickerTextStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textColorblue,
                      ),
                    ),
                  ),
                  child: CupertinoDatePicker(
                    maximumYear: DateTime.now().year,
                    minimumYear: 2000,
                    initialDateTime: selectedDate,
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: (DateTime newDate) {
                      setState(() {
                        selectedDate = newDate;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * .9,
                child: ElevatedButton(
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(user?.uid)
                        .update({
                      'dob': selectedDate,
                    });

                    setState(() {
                      dateOfBirth =
                          DateFormat('dd/MM/yyyy').format(selectedDate);
                    });

                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      backgroundColor: AppColors.buttonblue),
                  child: const Text(
                    'Update',
                    style: TextStyle(
                        color: AppColors.textColorWhite, fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void editGender() {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.kwhiteColor,
          title: Text(
            "Update Pronoun",
            style: theme.textTheme.bodyMedium,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () async {
                      await updateGender("He");
                      context.pop();
                    },
                    child: Container(
                        height: 50,
                        width: 100,
                        decoration: BoxDecoration(
                          color: AppColors.kpurple,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: const Center(
                            child: Text(
                          "He",
                          style: TextStyle(color: AppColors.kwhiteColor),
                        ))),
                  ),
                  InkWell(
                    onTap: () async {
                      await updateGender("She");
                      context.pop();
                    },
                    child: Container(
                        height: 50,
                        width: 100,
                        decoration: BoxDecoration(
                          color: AppColors.kpurple,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: const Center(
                            child: Text(
                          "She",
                          style: TextStyle(color: AppColors.kwhiteColor),
                        ))),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () async {
                  await updateGender("Prefer not to say");
                  context.pop();
                },
                child: Container(
                    height: 50,
                    width: 200,
                    decoration: BoxDecoration(
                      color: AppColors.kpurple,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: const Center(
                        child: Text(
                      "Prefer not to say",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.kwhiteColor),
                    ))),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text(
                "Cancel",
                style: theme.textTheme.bodyMedium,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> updateGender(String selectedPronoun) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .update({'gender': selectedPronoun});

    setState(() {
      pronoun = selectedPronoun;
    });
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController reasonController = TextEditingController();
        return AlertDialog(
          title: const Text("Delete Account"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Are you sure you want to delete your account?"),
              const SizedBox(height: 10),
              TextField(
                textCapitalization: TextCapitalization.sentences,
                maxLines: null,
                controller: reasonController,
                decoration: const InputDecoration(
                  labelText: "Reason for deletion",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _deleteAccount(reasonController.text);
                Navigator.of(context).pop();
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAccount(String reason) async {
    try {
      await FirebaseFirestore.instance.collection('deleteAccount').add({
        'userRef':
            FirebaseFirestore.instance.collection('users').doc(user?.uid),
        'reason': reason,
        'deleted_at': Timestamp.now(),
      });
    } catch (e) {
      print("Error deleting account: $e");
    }
  }

  void _editFamilyName(String relation) {
    print('....$relation');
    final theme = Theme.of(context);
    _familyController.clear();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.kwhiteColor,
          title: Text(
            "Edit name",
            style: theme.textTheme.bodyMedium,
          ),
          content: TextField(
            textCapitalization: TextCapitalization.sentences,
            style: theme.textTheme.bodyMedium,
            cursorColor: AppColors.kpurple,
            controller: _familyController,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.kpurple)),
              hintText: "Update name",
              hintStyle: theme.textTheme.bodyMedium,
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                "Cancel",
                style: theme.textTheme.bodyMedium,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                "Save",
                style: theme.textTheme.bodyMedium,
              ),
              onPressed: () async {
                DocumentSnapshot userDoc = await FirebaseFirestore.instance
                    .collection('users')
                    .doc(user?.uid)
                    .get();
                Map<String, dynamic> userData =
                    userDoc.data() as Map<String, dynamic>;

                List lovedOnes = userData['loved_once'] ?? [];

                for (var lovedOne in lovedOnes) {
                  if (lovedOne['relation'] == relation) {
                    lovedOne['name'] = _familyController.text;
                    break;
                  }
                }

                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(user?.uid)
                    .update({
                  'loved_once': lovedOnes,
                });

                setState(() {
                  switch (relation) {
                    case 'Mother':
                      motherName = _familyController.text;
                      break;
                    case 'Father':
                      fatherName = _familyController.text;
                      break;
                    case 'Grand mother':
                      grandMotherName = _familyController.text;
                      break;
                    case 'Grand father':
                      grandFatherName = _familyController.text;
                      break;
                    case 'Female friend':
                      petDogName = _familyController.text;
                      break;
                  }
                });

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _familyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: deviceHeight,
        width: deviceWidth,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xffead4f9),
              Color(0xfff7f1d1),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        context.pop();
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        color: AppColors.sliderColor,
                        size: 25,
                      ),
                    ),
                    const SizedBox(width: 20),
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [
                          AppColors.textColorGrey,
                          AppColors.textColorSettings,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ).createShader(
                        Rect.fromLTWH(0.0, 0.0, bounds.width, bounds.height),
                      ),
                      child: Text(
                        "Profile",
                        style: theme.textTheme.headlineMedium!.copyWith(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textColorWhite),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TabBar(
                dividerColor: Colors.transparent,
                controller: _tabController,
                indicatorColor: Colors.transparent,
                onTap: (index) {
                  setState(() {});
                },
                tabs: [
                  _tabTitle(deviceWidth, childName ?? '', 0),
                  _tabTitle(deviceWidth, "Family", 1),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: [
                    profileChildTab(theme),
                    profileFamilyTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tabTitle(double deviceWidth, String title, int index) {
    bool isSelected = _tabController.index == index;
    return Container(
      width: deviceWidth * 0.475,
      height: 50,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.kpurple : AppColors.kwhiteColor,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Center(
        child: Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color:
                  isSelected ? AppColors.kwhiteColor : AppColors.textColorblack,
              fontWeight: FontWeight.w400),
        ),
      ),
    );
  }

  Widget profileChildTab(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  detailsChild('Name', childName ?? 'Loading...', _editName),
                  const SizedBox(height: 20),
                  detailsChild('Pronoun', pronoun ?? 'Loading...', editGender),
                  const SizedBox(height: 20),
                  detailsChild('Date Of Birth', dateOfBirth.toString(),
                      _editDateOfBirth),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Favorite thing',
                        style: theme.textTheme.bodyMedium!.copyWith(
                            color: AppColors.textColorblack,
                            fontWeight: FontWeight.w400),
                      ),
                      const Spacer(),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.5555,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: StreamBuilder<
                                  DocumentSnapshot<Map<String, dynamic>>>(
                              stream: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user?.uid)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                var userDoc = snapshot.data?.data();
                                List<String> favoriteThings = List<String>.from(
                                    userDoc?['storycharactors'] ?? []);
                                return Column(
                                  children: [
                                    ...favoriteThings.map((thing) {
                                      return Column(
                                        children: [
                                          ListTile(
                                            title: Text(
                                              thing,
                                              style: theme.textTheme.bodyMedium,
                                            ),
                                            trailing: InkWell(
                                              onTap: () async {
                                                favoriteThings.remove(thing);
                                                await FirebaseFirestore.instance
                                                    .collection('users')
                                                    .doc(user?.uid)
                                                    .update({
                                                  'storycharactors':
                                                      favoriteThings,
                                                });
                                              },
                                              child: Image.asset(
                                                'assets/images/delete.png',
                                                width: 20,
                                                height: 20,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          const Divider(
                                            color: AppColors.kgreyColor,
                                            thickness: 0.45,
                                          ),
                                        ],
                                      );
                                    }),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.5555,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.3),
                                            spreadRadius: 1,
                                            blurRadius: 5,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: InkWell(
                                          onTap: () async {
                                            await showModalBottomSheet(
                                              isScrollControlled: true,
                                              backgroundColor:
                                                  Colors.transparent,
                                              enableDrag: false,
                                              context: context,
                                              builder: (context) {
                                                return const AddCharactorStory(
                                                  titleown: true,
                                                );
                                              },
                                            );
                                          },
                                          child: const Text(
                                            'Add your own',
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              })),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    onPressed: () {
                      _showDeleteAccountDialog(context);
                    },
                    child: Text(
                      "Delete my account",
                      style: theme.textTheme.bodyMedium!.copyWith(
                          color: AppColors.textColorblue,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(MediaQuery.of(context).size.width, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: Colors.white,
              ),
              child: Text(
                "Save",
                style: theme.textTheme.bodyLarge!.copyWith(
                  color: AppColors.textColorblue,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget detailsChild(
      String title, String detailAnswer, VoidCallback onpressed) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style:
              theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w400),
        ),
        Container(
          padding: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppColors.kwhiteColor,
          ),
          width: MediaQuery.of(context).size.width * 0.5555,
          height: 48,
          child: Center(
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    textCapitalization: TextCapitalization.sentences,
                    controller: TextEditingController(text: detailAnswer),
                    enabled: false,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(left: 15),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      fillColor: AppColors.kwhiteColor,
                      focusColor: AppColors.textColorblue,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: onpressed,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget profileFamilyTab() {
    final deviceWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          detailsChild(
              'Mother', motherName ?? ' ', () => _editFamilyName('Mother')),
          const SizedBox(height: 20),
          detailsChild(
              'Father', fatherName ?? ' ', () => _editFamilyName('Father')),
          const SizedBox(height: 20),
          detailsChild('Grand mother', grandMotherName ?? ' ',
              () => _editFamilyName('Grand mother')),
          const SizedBox(height: 20),
          detailsChild('Grand father', grandFatherName ?? '',
              () => _editFamilyName('Grand father')),
          const SizedBox(height: 20),
          detailsChild('Female friend', petDogName ?? '',
              () => _editFamilyName('Female friend')),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(deviceWidth, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: AppColors.kwhiteColor,
              ),
              child: Text(
                "Save",
                style: theme.textTheme.bodyLarge!.copyWith(
                  color: AppColors.textColorblue,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
