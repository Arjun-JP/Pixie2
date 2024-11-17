import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pixieapp/blocs/Story_bloc/story_bloc.dart';
import 'package:pixieapp/blocs/Story_bloc/story_event.dart';
import 'package:pixieapp/blocs/Story_bloc/story_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pixieapp/blocs/add_character_Bloc.dart/add_character_bloc.dart';
import 'package:pixieapp/blocs/add_character_Bloc.dart/add_character_event.dart';
import 'package:pixieapp/blocs/add_character_Bloc.dart/add_character_state.dart';
import 'package:pixieapp/const/colors.dart';
import 'package:pixieapp/widgets/audio_record_navbar.dart';
import 'package:pixieapp/widgets/errorNavbar.dart';
import 'package:pixieapp/widgets/progress_nav_bar.dart';
import 'package:pixieapp/widgets/navbar_loading_audio.dart';
import 'package:pixieapp/widgets/navbar2.dart';
import 'package:pixieapp/widgets/record_listen_navbar.dart';
import 'package:pixieapp/widgets/story_feedback.dart';

class StoryGeneratePage extends StatefulWidget {
  final Map<String, String> story;
  final String storytype;
  final String language;

  const StoryGeneratePage({
    Key? key,
    required this.story,
    required this.storytype,
    required this.language,
  }) : super(key: key);

  @override
  _StoryGeneratePageState createState() => _StoryGeneratePageState();
}

class _StoryGeneratePageState extends State<StoryGeneratePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DocumentReference<Object?>? _documentReference;

  File? audioFile;
  bool audioLoaded = false;
  String? audioUrl;

  bool isStoryInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initializeStory());
  }

  Future<void> _initializeStory() async {
    if (isStoryInitialized) return;
    isStoryInitialized = true;

    final queryParams = GoRouterState.of(context).uri.queryParameters;
    _documentReference = await _addStoryToFirebase(
      audiopath: '',
      fav: false,
      genre: widget.story["genre"] ?? "Surprise me",
      story: widget.story["story"] ?? "No data",
      title: widget.story["title"] ?? "No data",
      type: queryParams['storytype']!,
      language: queryParams['language']!,
      createdTime: DateTime.now(),
      audioRecordUrl: '',
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);

    return MultiBlocListener(
      listeners: [
        BlocListener<StoryBloc, StoryState>(
          listener: (context, state) async {
            if (state is StoryAudioSuccess) {
              audioFile = state.audioFile;
              audioUrl = await _uploadAudioToStorage(audioFile!);
              await _updateStoryWithAudioUrl(audioUrl!);
              setState(() {
                audioLoaded = true;
              });
            } else if (state is RecordedStoryAudioSuccess) {
              audioFile = state.musicAddedaudioFile;
              audioUrl = await _uploadAudioToStorage(audioFile!);
              await _updateStoryWithAudioUrl(audioUrl!);
            }
          },
        ),
      ],
      child: BlocBuilder<StoryBloc, StoryState>(builder: (context, state) {
        return Scaffold(
            backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  expandedHeight: deviceHeight * 0.2,
                  leadingWidth: deviceWidth,
                  collapsedHeight: deviceHeight * 0.08,
                  toolbarHeight: deviceHeight * 0.07,
                  pinned: true,
                  floating: false,
                  backgroundColor: const Color(0xff644a98),
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
                        child: BlocBuilder<AddCharacterBloc, AddCharacterState>(
                          builder: (context, state) => IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () async {
                              if (state.showfeedback) {
                                await showModalBottomSheet(
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  enableDrag: false,
                                  context: context,
                                  builder: (context) {
                                    return GestureDetector(
                                      onTap: () =>
                                          FocusScope.of(context).unfocus(),
                                      child: Padding(
                                        padding:
                                            MediaQuery.viewInsetsOf(context),
                                        child: StoryFeedback(
                                          story: widget.story['story'] ??
                                              'No Story available',
                                          title: widget.story['title'] ??
                                              'No title available',
                                          path: audioUrl ?? '',
                                          textfield: false,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                              context.read<StoryBloc>().add(StopplayingEvent());
                              context.read<AddCharacterBloc>().add(
                                  const ShowfeedbackEvent(showfeedback: false));
                              context
                                  .read<AddCharacterBloc>()
                                  .add(ResetStateEvent());
                              context.go('/HomePage');
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                  flexibleSpace: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      var top = constraints.biggest.height;
                      bool isCollapsed = top <= kToolbarHeight + 30;

                      return FlexibleSpaceBar(
                        centerTitle: false,
                        titlePadding: EdgeInsets.only(
                          left: 16,
                          bottom: 10,
                          right: deviceWidth * 0.13,
                        ),
                        title: Text(
                          widget.story["title"] ?? "No data",
                          style: theme.textTheme.titleMedium!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: isCollapsed ? 15 : 20,
                          ),
                        ),
                        background: Image.asset(
                          'assets/images/appbarbg2.jpg',
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
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
                          widget.story["story"] ?? "No data",
                          style: theme.textTheme.bodyMedium!.copyWith(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            bottomNavigationBar: (state is StorySuccess)
                ? RecordListenNavbar(
                    story: widget.story['story']!,
                    title: widget.story['title']!,
                    language: widget.language,
                  )
                : (state is StoryAudioSuccess ||
                        state is RecordedStoryAudioSuccess)
                    ? NavBar2(
                        documentReference: _documentReference,
                        audioFile: audioFile!,
                        story: widget.story['story'] ?? 'No Story available',
                        title: widget.story['title'] ?? 'No title available',
                        firebaseAudioPath: audioUrl ?? '',
                        suggestedStories: false,
                        firebaseStories: false,
                      )
                    : (state is StartRecordaudioScreen ||
                            state is AudioRecording ||
                            state is AudioStopped)
                        ? const BottomNavRecord()
                        : (state is StoryLoading)
                            ? const ProgressNavBar()
                            : const Errornavbar());
      }),
    );
  }

  Future<DocumentReference<Object?>?> _addStoryToFirebase({
    required String genre,
    required String title,
    required String audiopath,
    required bool fav,
    required String story,
    required String type,
    required String language,
    required DateTime createdTime,
    required String audioRecordUrl,
  }) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return null;
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
      final docRef = await _firestore.collection('fav_stories').add({
        'storytype': type,
        'title': title,
        'audiofile': audiopath,
        'story': story,
        'isfav': fav,
        'user_ref': userRef,
        'language': language,
        'genre': genre,
        'createdTime': FieldValue.serverTimestamp(),
        'audioRecordUrl': audioRecordUrl,
      });

      print('Story added to favorites');
      return docRef;
    } catch (e) {
      print('Error adding story: $e');
      return null;
    }
  }

  Future<void> _updateStoryWithAudioUrl(String audioUrl) async {
    if (_documentReference != null) {
      try {
        await _documentReference!.update({'audiofile': audioUrl});
        print('Audio URL updated in Firestore');
      } catch (e) {
        print('Error updating audio URL: $e');
      }
    }
  }

  Future<String?> _uploadAudioToStorage(File audioFile) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_audio')
          .child('${DateTime.now().millisecondsSinceEpoch}.mp3');

      final snapshot = await storageRef.putFile(audioFile);
      final audioUrl = await snapshot.ref.getDownloadURL();

      print('Audio uploaded: $audioUrl');
      return audioUrl;
    } catch (e) {
      print('Error uploading audio: $e');
      return null;
    }
  }
}
