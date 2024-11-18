import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pixieapp/blocs/Story_bloc/story_bloc.dart';
import 'package:pixieapp/blocs/Story_bloc/story_event.dart';

import 'package:pixieapp/const/colors.dart';
import 'package:pixieapp/repositories/story_repository.dart';
import 'package:pixieapp/widgets/loading_widget.dart';
import 'package:pixieapp/widgets/navbar2.dart';

class Firebasestory extends StatefulWidget {
  final DocumentReference<Object?> storyDocRef;
  const Firebasestory({super.key, required this.storyDocRef});

  @override
  _FirebasestoryState createState() => _FirebasestoryState();
}

class _FirebasestoryState extends State<Firebasestory> {
  Map<String, dynamic>? storyData;
  File? audioFile;
  String? audioUrl;
  StoryRepository storyRepository = StoryRepository();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Fetch the story data from the document reference
    widget.storyDocRef.get().then((docSnapshot) {
      if (docSnapshot.exists) {
        setState(() {
          storyData = docSnapshot.data() as Map<String, dynamic>?;
        });
      }
    });
  }

  // Function to add a new line after each full stop in the story text
  String formatStory(String story) {
    return story.replaceAll('. ', '.\n');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    if (storyData == null) {
      return const Scaffold(
        body: Center(child: LoadingWidget()),
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: deviceHeight * 0.20,
            toolbarHeight: deviceHeight * 0.07,
            leadingWidth: deviceWidth,
            collapsedHeight: deviceHeight * 0.08,
            pinned: true,
            floating: false,
            backgroundColor: const Color(0xff644a98),
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                var top = constraints.biggest.height;
                bool isCollapsed = top <= kToolbarHeight + 30;

                return FlexibleSpaceBar(
                  centerTitle: true,
                  titlePadding: EdgeInsets.only(
                      left: 16, bottom: 10, right: deviceWidth * 0.13),
                  title: Text(
                    storyData?["title"] ?? "No data",
                    style: theme.textTheme.titleMedium!.copyWith(
                      color: AppColors.textColorWhite,
                      fontWeight: FontWeight.bold,
                      fontSize: isCollapsed ? 5 : 20,
                    ),
                  ),
                  background: Image.asset(
                    'assets/images/appbarbg2.jpg',
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: deviceWidth * 0.01),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.kwhiteColor.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      context.read<StoryBloc>().add(StopplayingEvent());
                      context.pop();
                    },
                  ),
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(
                top: 5,
                left: deviceHeight * 0.0294,
                right: deviceHeight * 0.0294,
                bottom: deviceHeight * 0.0294,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    storyData?["story"] ?? "No data",
                    style: theme.textTheme.bodyMedium!.copyWith(
                        color: AppColors.textColorblack,
                        fontSize: 24,
                        fontWeight: FontWeight.w400),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavBar2(
          documentReference: widget.storyDocRef,
          story: storyData?["story"] ?? 'No Story available',
          title: storyData?["title"] ?? 'No title available',
          firebaseAudioPath: storyData?["audiofile"] ?? 'No fileaudio found',
          suggestedStories: false,
          firebaseStories: true),
    );
  }
}
