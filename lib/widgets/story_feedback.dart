import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pixieapp/blocs/StoryFeedback/story_feedback_event.dart'
    as StoryFeedbackEvent;
import 'package:pixieapp/blocs/StoryFeedback/story_feedback_bloc.dart';
import 'package:pixieapp/blocs/StoryFeedback/story_feedback_event.dart';
import 'package:pixieapp/blocs/StoryFeedback/story_feedback_state.dart';
import 'package:pixieapp/blocs/add_character_Bloc.dart/add_character_bloc.dart';
import 'package:pixieapp/blocs/add_character_Bloc.dart/add_character_event.dart';
import 'package:pixieapp/const/colors.dart';

class StoryFeedback extends StatefulWidget {
  final String story;
  final String title;
  final String path;
  final bool textfield;
  const StoryFeedback(
      {super.key,
      required this.story,
      required this.title,
      required this.path,
      this.textfield = true});

  @override
  State<StoryFeedback> createState() => _StoryFeedbackState();
}

class _StoryFeedbackState extends State<StoryFeedback> {
  bool disliked = false;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    TextEditingController textcontroller = TextEditingController();

    return BlocBuilder<StoryFeedbackBloc, StoryFeedbackState>(
      builder: (context, state) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * .7,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () => context.pop(),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: Text(
                      'Skip',
                      style: theme.textTheme.bodyMedium!
                          .copyWith(color: AppColors.textColorWhite),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: const BoxDecoration(
                    color: AppColors.bottomSheetBackground,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          'Rate your story',
                          style: theme.textTheme.bodyLarge!.copyWith(
                            color: AppColors.textColorblack,
                            fontSize: 23,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            return IconButton(
                              onPressed: () {
                                context.read<StoryFeedbackBloc>().add(
                                    StoryFeedbackEvent.UpdateRatingEvent(
                                        index + 1));
                              },
                              icon: Icon(
                                state.rating > index
                                    ? Icons.star_rate_rounded
                                    : Icons.star_border_rounded,
                                color: AppColors.kpurple,
                                size: 50,
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Please select one or more issues',
                          style: theme.textTheme.bodyMedium!.copyWith(
                            color: AppColors.textColorblack,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          children: [
                            for (var issue in [
                              'Narration speed',
                              'Pronunciation',
                              'Voice modulation',
                              'Background music',
                              'User journey',
                              'Storyline'
                            ])
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: ChoiceChip(
                                  label: Text(
                                    issue,
                                    style: TextStyle(
                                        color: state.issues.contains(issue)
                                            ? AppColors.textColorWhite
                                            : AppColors.textColorblack),
                                  ),
                                  selected: state.issues.contains(issue),
                                  onSelected: (selected) {
                                    context
                                        .read<StoryFeedbackBloc>()
                                        .add(ToggleIssueEvent(issue));
                                  },
                                  selectedColor: AppColors.kpurple,
                                  backgroundColor: AppColors.kwhiteColor,
                                  checkmarkColor: AppColors.textColorWhite,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        widget.textfield
                            ? TextField(
                                textCapitalization:
                                    TextCapitalization.sentences,
                                controller: textcontroller,
                                minLines: 3,
                                maxLines: 10,
                                decoration: InputDecoration(
                                  hintText: 'Type in case other',
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Colors.grey,
                                      width: .5,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Colors.grey,
                                      width: .5,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: AppColors.kpurple,
                                      width: .5,
                                    ),
                                  ),
                                ),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.kblackColor,
                                ),
                              )
                            : const SizedBox(),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 22),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * .7,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  foregroundColor: AppColors.kpurple,
                                  backgroundColor: AppColors.kpurple),
                              onPressed: () {
                                if (textcontroller.text.isNotEmpty &&
                                    widget.textfield == true) {
                                  context.read<StoryFeedbackBloc>().add(
                                      AddCustomIssueEvent(textcontroller.text));
                                  context.read<StoryFeedbackBloc>().add(
                                      StoryFeedbackEvent.SubmitFeedbackEvent(
                                          audiopath: widget.path,
                                          story: widget.story,
                                          story_title: widget.title));
                                  context.read<StoryFeedbackBloc>().add(
                                      const UpdatedislikeStateEvent(
                                          isDisliked: true));
                                } else {
                                  context.read<StoryFeedbackBloc>().add(
                                      StoryFeedbackEvent.SubmitFeedbackEvent(
                                          audiopath: widget.path,
                                          story: widget.story,
                                          story_title: widget.title));
                                  context.read<StoryFeedbackBloc>().add(
                                      const UpdatedislikeStateEvent(
                                          isDisliked: true));
                                  context.pop();
                                }
                                context
                                    .read<AddCharacterBloc>()
                                    .add(const UpdatedislikebuttonEvent(true));
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Thank you for your feedback")));
                              },
                              child: Text(
                                'Submit',
                                style: theme.textTheme.bodyMedium!
                                    .copyWith(color: AppColors.textColorWhite),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
