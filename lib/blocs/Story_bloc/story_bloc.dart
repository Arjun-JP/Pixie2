import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audio_session/audio_session.dart';

import 'package:pixieapp/widgets/audio_controller.dart';
import 'story_event.dart';
import 'story_state.dart';
import 'package:pixieapp/repositories/story_repository.dart';

class StoryBloc extends Bloc<StoryEvent, StoryState> {
  final StoryRepository storyRepository;
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final FlutterSoundPlayer _player = FlutterSoundPlayer();
  String? _audioPath;
  final AudioController _audioController = AudioController();
  StoryBloc({required this.storyRepository}) : super(StoryInitial()) {
    _initializeAudioSession();

    // Register events
    on<GenerateStoryEvent>(_onGenerateStoryEvent);
    on<SpeechToTextEvent>(_onSpeechToTextEvent);
    on<AddMusicEvent>(_onAddMusicEvent);
    on<StartRecordnavbarEvent>(_onStartRecordnavbarEvent);
    on<StartRecordingEvent>((event, emit) async => await _startRecording(emit));
    on<StopRecordingEvent>((event, emit) async => await _stopRecording(emit));
    on<StopplayingEvent>((event, emit) async => await _stopplaying(emit));
  }

  /// Initialize the audio session
  Future<void> _initializeAudioSession() async {
    try {
      // Determine platform-specific audio path
      if (Platform.isIOS) {
        var directory = await getApplicationDocumentsDirectory();
        _audioPath = '${directory.path}/';
      } else {
        _audioPath = '/sdcard/Download/appname/';
      }

      // Ensure directories exist
      await Directory(_audioPath!).create(recursive: true);

      // Initialize recorder and player
      await _recorder.openRecorder();
      await _player.openPlayer();

      // Configure AudioSession
      final session = await AudioSession.instance;
      await session.configure(AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
        avAudioSessionCategoryOptions:
            AVAudioSessionCategoryOptions.allowBluetooth |
                AVAudioSessionCategoryOptions.defaultToSpeaker,
        avAudioSessionMode: AVAudioSessionMode.spokenAudio,
        avAudioSessionRouteSharingPolicy:
            AVAudioSessionRouteSharingPolicy.defaultPolicy,
        avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
        androidAudioAttributes: const AndroidAudioAttributes(
          contentType: AndroidAudioContentType.speech,
          flags: AndroidAudioFlags.none,
          usage: AndroidAudioUsage.voiceCommunication,
        ),
        androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
        androidWillPauseWhenDucked: true,
      ));

      // Set subscription durations for real-time progress tracking
      await _recorder.setSubscriptionDuration(const Duration(milliseconds: 10));
      await _player.setSubscriptionDuration(const Duration(milliseconds: 10));

      print('Audio session initialized successfully.');
    } catch (e) {
      print('Error initializing audio session: $e');
    }
  }

  /// Start recording audio
  Future<void> _startRecording(Emitter<StoryState> emit) async {
    try {
      // Check and request permissions
      if (!await _checkPermissions()) {
        emit(AudioUploadError('Permissions are required.'));
        return;
      }

      // Define the audio file path
      final String fileName =
          'audio_${DateTime.now().millisecondsSinceEpoch}.aac';
      final String fullPath = '$_audioPath$fileName';

      emit(AudioRecording());

      // Start recording
      await _recorder.startRecorder(
        toFile: fullPath,
        codec: Codec.aacMP4, // AAC MP4 codec for `.m4a` compatibility
      );

      print('Recording started. File: $fullPath');
    } catch (e) {
      emit(AudioUploadError('Failed to start recording: $e'));
      print('Error starting recorder: $e');
    }
  }

  /// Stop recording audio
  Future<void> _stopRecording(Emitter<StoryState> emit) async {
    try {
      final filePath = await _recorder.stopRecorder();
      if (filePath != null) {
        final file = File(filePath);
        if (await file.exists() && (await file.length() > 0)) {
          emit(AudioStopped(audioPath: filePath));
          print('Recording stopped successfully. File saved at $filePath');
        } else {
          emit(AudioUploadError('Recording failed: File is empty.'));
          print('Error: Recorded file is empty.');
        }
      } else {
        emit(AudioUploadError('Recording failed: File path is null.'));
        print('Error: File path is null.');
      }
    } catch (e) {
      emit(AudioUploadError('Failed to stop recording: $e'));
      print('Error stopping recorder: $e');
    }
  }

  /// Check and request permissions
  Future<bool> _checkPermissions() async {
    var micStatus = await Permission.microphone.status;
    var storageStatus = await Permission.storage.status;

    if (!micStatus.isGranted) micStatus = await Permission.microphone.request();
    if (!storageStatus.isGranted) {
      storageStatus = await Permission.storage.request();
    }
    if (Platform.isAndroid) {
      var manageStorage = await Permission.manageExternalStorage.status;
      if (!manageStorage.isGranted) {
        manageStorage = await Permission.manageExternalStorage.request();
      }
    }
    return micStatus.isGranted && storageStatus.isGranted;
  }

  /// Generate story
  Future<void> _onGenerateStoryEvent(
      GenerateStoryEvent event, Emitter<StoryState> emit) async {
    emit(StoryLoading());
    try {
      final storyResponse = await storyRepository.generateStory(
          event: event.event,
          age: int.parse(event.age),
          topic: event.topic,
          child_name: event.childName,
          gender: event.gender,
          relation: event.relation,
          relative_name: event.relativeName,
          genre: event.genre,
          lessons: event.lessons,
          length: event.length,
          language: event.language,
          character_name: event.characterName,
          city: event.city);

      emit(StorySuccess(story: storyResponse));
    } catch (error) {
      emit(StoryFailure(error: error.toString()));
    }
  }

  /// Speech to text
  Future<void> _onSpeechToTextEvent(
      SpeechToTextEvent event, Emitter<StoryState> emit) async {
    emit(StoryLoading());
    try {
      print(event.text);
      final audioFile = await storyRepository.speechToText(
          text: event.text, language: event.language, event: event.event);

      emit(StoryAudioSuccess(audioFile: audioFile));
    } catch (error) {
      emit(StoryFailure(error: error.toString()));
    }
  }

  /// Add music to audio
  Future<void> _onAddMusicEvent(
      AddMusicEvent event, Emitter<StoryState> emit) async {
    emit(StoryLoading());
    try {
      final audioFile = await storyRepository.addMusicToAudio(
        event: event.event,
        audioFile: event.audiofile,
      );
      print('Audio with music: $audioFile');
      emit(RecordedStoryAudioSuccess(musicAddedaudioFile: audioFile));
    } catch (error) {
      emit(StoryFailure(error: error.toString()));
    }
  }

  /// Start recording interface
  void _onStartRecordnavbarEvent(
      StartRecordnavbarEvent event, Emitter<StoryState> emit) {
    emit(StartRecordaudioScreen());
  }

  /// Dispose the recorder when bloc is closed
  @override
  Future<void> close() async {
    try {
      if (_recorder.isRecording) {
        await _recorder.stopRecorder();
      }
      await _recorder.closeRecorder();
      print('Audio session closed successfully.');
    } catch (e) {
      print('Error closing recorder: $e');
    }
    return super.close();
  }

  _stopplaying(Emitter<StoryState> emit) {
    _audioController.stop();
    emit(const Stopplayingstate());
  }
}

Future<void> _updateStoryWithAudioUrl(
  DocumentReference<Object?>? storyref,
  String audioUrl,
) async {
  if (storyref != null) {
    try {
      await storyref!.update({'audiofile': audioUrl});
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
