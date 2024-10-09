import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixieapp/blocs/introduction/introduction_bloc.dart';
import 'package:pixieapp/blocs/introduction/introduction_event.dart';
import 'package:pixieapp/blocs/introduction/introduction_state.dart';
import 'package:pixieapp/const/colors.dart';
import 'package:go_router/go_router.dart';
import 'package:pixieapp/models/Child_data_model.dart';

class AddFavoritesBottomsheet extends StatefulWidget {
  const AddFavoritesBottomsheet({super.key});

  @override
  State<AddFavoritesBottomsheet> createState() =>
      _AddFavoritesBottomsheetState();
}

class _AddFavoritesBottomsheetState extends State<AddFavoritesBottomsheet> {
  final TextEditingController addyourown = TextEditingController();
  ClildDataModel childdata = ClildDataModel(
      name: 'name',
      gender: Gender.prefernottosay,
      favthings: ["Motorbike", "Robot", "Monkey", "Race cars"],
      dob: DateTime.now(),
      lovedonce: []);
      
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<IntroductionBloc, IntroductionState>(
      listener: (context, state) {
        if (state is FavListUpdated) {
          String lastadded = state.favList;
          childdata.favthings.add(lastadded);
          print('.....${childdata.favthings}');
          FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).update({
            'fav_things': childdata.favthings,
          });
        }
      },
      builder: (context, state) {
        return Container(
          height: MediaQuery.of(context).size.height * .8,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              color: AppColors.bottomSheetBackground,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18), topRight: Radius.circular(18))),
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      context.pop();
                    },
                  ),
                ),
                Text(
                  'Add your own',
                  style: theme.textTheme.displayMedium?.copyWith(
                      color: AppColors.textColorblue,
                      fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: addyourown,
                  cursorColor: AppColors.textColorblue,
                  decoration: InputDecoration(
                    hintText: 'Ex: car, toys',
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textColorGrey,
                        fontWeight: FontWeight.w400),
                    focusColor: AppColors.textColorblue,
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.textColorblue)),
                    border: OutlineInputBorder(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 28),
                  child: SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.85,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        context
                            .read<IntroductionBloc>()
                            .add(FavListChanged(favList: addyourown.text));
                        context.pop();
                        
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        foregroundColor: Colors.white,
                        backgroundColor: AppColors.buttonblue,
                      ),
                      child: Text("Save",
                          style: theme.textTheme.bodyLarge!.copyWith(
                              color: AppColors.textColorWhite,
                              fontSize: 20,
                              fontWeight: FontWeight.w400)),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}