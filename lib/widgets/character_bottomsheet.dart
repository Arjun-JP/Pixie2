import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pixieapp/blocs/add_character_Bloc.dart/add_character_bloc.dart';
import 'package:pixieapp/blocs/add_character_Bloc.dart/add_character_event.dart';
import 'package:pixieapp/blocs/add_character_Bloc.dart/add_character_state.dart';
import 'package:pixieapp/const/colors.dart';

class CharacterBottomsheet extends StatefulWidget {
  const CharacterBottomsheet({super.key});

  @override
  State<CharacterBottomsheet> createState() => _CharacterBottomsheetState();
}

class _CharacterBottomsheetState extends State<CharacterBottomsheet> {
  List<dynamic> character = []; // List to store character

  @override
  void initState() {
    super.initState();
    _getcharacter().then((characterlist) {
      setState(() {
        character = characterlist;
      });
    }); // Fetch character when the widget is initialized
  }

  // Function to get character from Firestore

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<AddCharacterBloc, AddCharacterState>(
      builder: (context, state) => Container(
        height: MediaQuery.of(context).size.height * .7,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: AppColors.bottomSheetBackground,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 25, left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select a Character',
                  style: theme.textTheme.displayMedium?.copyWith(
                      color: AppColors.textColorblue,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 25),
              Wrap(
                children: List<Widget>.generate(character.length, (int index) {
                  var charectoritem = character[
                      index]; // Get the lesson data for the current index
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ChoiceChip(
                      onSelected: (value) {
                        // Trigger an event or do something with the selected lesson
                        context.read<AddCharacterBloc>().add(
                            AddcharactorstoryEvent(charectoritem,
                                selectedindexcharactor: index));
                        context.pop();
                      },
                      selectedColor: AppColors.kpurple,
                      elevation: 3,
                      checkmarkColor: AppColors.kwhiteColor,
                      label: Text(
                        charectoritem.toString(), // Display the lesson name
                        style: TextStyle(
                          color: state.selectedindexcharactor == index
                              ? AppColors.kwhiteColor
                              : AppColors.kblackColor,
                        ),
                      ),
                      selected: state.selectedindexcharactor ==
                          index, // Set the selection based on index
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding: const EdgeInsets.all(16),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<dynamic>> _getcharacter() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // Handle the case where the user is not authenticated
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User is not authenticated")),
      );
      return [];
    } else {
      try {
        // Fetch the user document from Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        // Extract character from the user document
        var userData = userDoc.data() as Map<String, dynamic>?;
        if (userData != null) {
          return userData['storycharactors'] ?? [];
        }
      } catch (e) {
        // Handle error if something goes wrong
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to load character: $e")),
        );
        return [];
      }
      return [];
    }
  }
}