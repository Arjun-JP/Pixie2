import 'package:equatable/equatable.dart';

class AddCharacterState extends Equatable {
  final int currentpageindex;

  const AddCharacterState({required this.currentpageindex});

  @override
  List<Object?> get props => [currentpageindex];
}

// // State for language updates
// class LanguageUpdatedState extends AddCharacterState {
//   final String selectedLanguage;

//   const LanguageUpdatedState(this.selectedLanguage);

//   @override
//   List<Object?> get props => [selectedLanguage];
// }
