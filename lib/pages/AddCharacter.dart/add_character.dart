import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:pixieapp/const/colors.dart';
import 'package:pixieapp/widgets/choicechip.dart';

class AddCharacter extends StatefulWidget {
  const AddCharacter({super.key});

  @override
  State<AddCharacter> createState() => _AddCharacterState();
}

class _AddCharacterState extends State<AddCharacter> {
  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController1;
  List<String>? get choiceChipsValues1 => choiceChipsValueController1?.value;
  set choiceChipsValues1(List<String>? val) =>
      choiceChipsValueController1?.value = val;
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController2;
  List<String>? get choiceChipsValues2 => choiceChipsValueController2?.value;
  set choiceChipsValues2(List<String>? val) =>
      choiceChipsValueController2?.value = val;
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController3;
  String? get choiceChipsValue3 =>
      choiceChipsValueController3?.value?.firstOrNull;
  set choiceChipsValue3(String? val) =>
      choiceChipsValueController3?.value = val != null ? [val] : [];
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController4;
  String? get choiceChipsValue4 =>
      choiceChipsValueController4?.value?.firstOrNull;
  set choiceChipsValue4(String? val) =>
      choiceChipsValueController4?.value = val != null ? [val] : [];
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController5;
  List<String>? get choiceChipsValues5 => choiceChipsValueController5?.value;
  set choiceChipsValues5(List<String>? val) =>
      choiceChipsValueController5?.value = val;
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController6;
  List<String>? get choiceChipsValues6 => choiceChipsValueController6?.value;
  set choiceChipsValues6(List<String>? val) =>
      choiceChipsValueController6?.value = val;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 236, 215, 244),
        key: scaffoldKey,
        body: Container(
          width: MediaQuery.sizeOf(context).width * 1.0,
          height: MediaQuery.sizeOf(context).height * 1.0,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 231, 201, 249),
                Color.fromARGB(255, 248, 244, 187)
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 0.0, 0.0, 40.0),
                      child: PageView(
                        controller: pageViewController ??=
                            PageController(initialPage: 0),
                        scrollDirection: Axis.horizontal,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    15.0, 0.0, 15.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                          color: const Color(
                                              0xFFE8DEF8), // Background color
                                          borderRadius:
                                              BorderRadius.circular(40.0),
                                        ),
                                        child: IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                            Icons.arrow_back,
                                            color: AppColors.sliderColor,
                                          ),
                                        )),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(15.0, 0.0, 0.0, 0.0),
                                        child: LinearPercentIndicator(
                                          percent: 0.166,
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  0.72,
                                          lineHeight: 12.0,
                                          animation: true,
                                          animateFromLastPercent: true,
                                          progressColor: AppColors.sliderColor,
                                          backgroundColor:
                                              AppColors.sliderBackground,
                                          barRadius:
                                              const Radius.circular(20.0),
                                          padding: EdgeInsets.zero,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    15.0, 30.0, 15.0, 0.0),
                                child: Text(
                                  'Let’s add in some characters...',
                                  style: theme.textTheme.headlineLarge,
                                ),
                              ),
                              const SizedBox(height: 25),
                              Expanded(
                                child: ChoiceChips(
                                  options: const [
                                    ChipData('Elephant',
                                        Icons.star_purple500_rounded),
                                    ChipData(
                                        'Name', Icons.star_purple500_rounded),
                                    ChipData('Hippopotamus',
                                        Icons.star_purple500_rounded),
                                    ChipData(
                                        'Person', Icons.star_rate_outlined),
                                    ChipData(
                                        'Friend', Icons.star_purple500_rounded),
                                    ChipData(
                                        'Name', Icons.star_purple500_rounded)
                                  ],
                                  onChanged: (val) => choiceChipsValues1 = val,
                                  selectedChipStyle: ChipStyle(
                                    backgroundColor: AppColors.sliderColor,
                                    textStyle: theme.textTheme.bodyMedium,
                                    iconColor: AppColors.sliderColor,
                                    iconSize: 18.0,
                                    elevation: 0.0,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  unselectedChipStyle: ChipStyle(
                                    backgroundColor:
                                        AppColors.choicechipUnSelected,
                                    textStyle: theme.textTheme.bodySmall,
                                    iconColor: AppColors.sliderColor,
                                    iconSize: 16.0,
                                    elevation: 0.0,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  chipSpacing: 10.0,
                                  rowSpacing: 10.0,
                                  multiselect: true,
                                  alignment: WrapAlignment.start,
                                  controller: choiceChipsValueController1 ??=
                                      FormFieldController<List<String>>(
                                    [],
                                  ),
                                  wrapped: true,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    15.0, 0.0, 15.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                          color: const Color(
                                              0xFFE8DEF8), // Background color
                                          borderRadius:
                                              BorderRadius.circular(40.0),
                                        ),
                                        child: IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                            Icons.arrow_back,
                                            color: AppColors.sliderColor,
                                          ),
                                        )),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(15.0, 0.0, 0.0, 0.0),
                                        child: LinearPercentIndicator(
                                          percent: 0.332,
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  0.72,
                                          lineHeight: 12.0,
                                          animation: true,
                                          animateFromLastPercent: true,
                                          progressColor: AppColors.sliderColor,
                                          backgroundColor:
                                              AppColors.sliderBackground,
                                          barRadius:
                                              const Radius.circular(20.0),
                                          padding: EdgeInsets.zero,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    15.0, 30.0, 15.0, 0.0),
                                child: Text('Add loved ones in...',
                                    style: theme.textTheme.headlineLarge),
                              ),
                              const SizedBox(height: 25),
                              Expanded(
                                child: ChoiceChips(
                                  options: const [
                                    ChipData(
                                        'Mom', Icons.star_purple500_rounded),
                                    ChipData(
                                        'Dad', Icons.star_purple500_rounded),
                                    ChipData(
                                        'Nidhi', Icons.star_purple500_rounded),
                                    ChipData(
                                        'Mishka', Icons.star_rate_outlined),
                                    ChipData(
                                        'Friend', Icons.star_purple500_rounded),
                                    ChipData(
                                        'Name', Icons.star_purple500_rounded)
                                  ],
                                  onChanged: (val) => choiceChipsValues2 = val,
                                  selectedChipStyle: ChipStyle(
                                    backgroundColor: AppColors.sliderColor,
                                    textStyle: theme.textTheme.bodyMedium,
                                    iconColor: AppColors.sliderColor,
                                    iconSize: 18.0,
                                    elevation: 0.0,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  unselectedChipStyle: ChipStyle(
                                    backgroundColor:
                                        AppColors.choicechipUnSelected,
                                    textStyle: theme.textTheme.bodySmall,
                                    iconColor: AppColors.sliderColor,
                                    iconSize: 16.0,
                                    elevation: 0.0,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  chipSpacing: 10.0,
                                  rowSpacing: 10.0,
                                  multiselect: true,
                                  alignment: WrapAlignment.start,
                                  controller: choiceChipsValueController2 ??=
                                      FormFieldController<List<String>>(
                                    [],
                                  ),
                                  wrapped: true,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    15.0, 0.0, 15.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                          color: const Color(
                                              0xFFE8DEF8), // Background color
                                          borderRadius:
                                              BorderRadius.circular(40.0),
                                        ),
                                        child: IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                            Icons.arrow_back,
                                            color: AppColors.sliderColor,
                                          ),
                                        )),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(15.0, 0.0, 0.0, 0.0),
                                        child: LinearPercentIndicator(
                                          percent: 0.498,
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  0.72,
                                          lineHeight: 12.0,
                                          animation: true,
                                          animateFromLastPercent: true,
                                          progressColor: AppColors.sliderColor,
                                          backgroundColor:
                                              AppColors.sliderBackground,
                                          barRadius:
                                              const Radius.circular(20.0),
                                          padding: EdgeInsets.zero,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    15.0, 30.0, 15.0, 0.0),
                                child: Text('What’s the occasion',
                                    style: theme.textTheme.headlineLarge),
                              ),
                              const SizedBox(height: 25),
                              addoccasion(theme, "Bead time"),
                              addoccasion(theme, "Play time"),
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    15.0, 0.0, 15.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                          color: const Color(
                                              0xFFE8DEF8), // Background color
                                          borderRadius:
                                              BorderRadius.circular(40.0),
                                        ),
                                        child: IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                            Icons.arrow_back,
                                            color: AppColors.sliderColor,
                                          ),
                                        )),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(15.0, 0.0, 0.0, 0.0),
                                        child: LinearPercentIndicator(
                                          percent: 0.664,
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  0.72,
                                          lineHeight: 12.0,
                                          animation: true,
                                          animateFromLastPercent: true,
                                          progressColor: AppColors.sliderColor,
                                          backgroundColor:
                                              AppColors.sliderBackground,
                                          barRadius:
                                              const Radius.circular(20.0),
                                          padding: EdgeInsets.zero,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    15.0, 0.0, 15.0, 0.0),
                                child: Text('Language of the story',
                                    style: theme.textTheme.headlineLarge),
                              ),
                              Expanded(
                                child: ChoiceChips(
                                  options: const [
                                    ChipData(
                                        'Mom', Icons.star_purple500_rounded),
                                    ChipData(
                                        'Dad', Icons.star_purple500_rounded),
                                    ChipData(
                                        'Nidhi', Icons.star_purple500_rounded),
                                    ChipData(
                                        'Mishka', Icons.star_rate_outlined),
                                    ChipData(
                                        'Friend', Icons.star_purple500_rounded),
                                    ChipData(
                                        'Name', Icons.star_purple500_rounded)
                                  ],
                                  onChanged: (val) =>
                                      choiceChipsValue4 = val?.firstOrNull,
                                  selectedChipStyle: ChipStyle(
                                    backgroundColor: AppColors.sliderColor,
                                    textStyle: theme.textTheme.bodyMedium,
                                    iconColor: AppColors.sliderColor,
                                    iconSize: 18.0,
                                    elevation: 0.0,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  unselectedChipStyle: ChipStyle(
                                    backgroundColor:
                                        AppColors.choicechipUnSelected,
                                    textStyle: theme.textTheme.bodySmall,
                                    iconColor: AppColors.sliderColor,
                                    iconSize: 16.0,
                                    elevation: 0.0,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  chipSpacing: 10.0,
                                  rowSpacing: 10.0,
                                  multiselect: true,
                                  alignment: WrapAlignment.start,
                                  controller: choiceChipsValueController4 ??=
                                      FormFieldController<List<String>>(
                                    [],
                                  ),
                                  wrapped: true,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    15.0, 0.0, 15.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                          color: const Color(
                                              0xFFE8DEF8), // Background color
                                          borderRadius:
                                              BorderRadius.circular(40.0),
                                        ),
                                        child: IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                            Icons.arrow_back,
                                            color: AppColors.sliderColor,
                                          ),
                                        )),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(15.0, 0.0, 0.0, 0.0),
                                        child: LinearPercentIndicator(
                                          percent: 0.83,
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  0.72,
                                          lineHeight: 12.0,
                                          animation: true,
                                          animateFromLastPercent: true,
                                          progressColor: AppColors.sliderColor,
                                          backgroundColor:
                                              AppColors.sliderBackground,
                                          barRadius:
                                              const Radius.circular(20.0),
                                          padding: EdgeInsets.zero,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    15.0, 0.0, 15.0, 0.0),
                                child: Text('Add a lesson',
                                    style: theme.textTheme.headlineLarge),
                              ),
                              Expanded(
                                child: ChoiceChips(
                                  options: const [
                                    ChipData(
                                        'Mom', Icons.star_purple500_rounded),
                                    ChipData(
                                        'Dad', Icons.star_purple500_rounded),
                                    ChipData(
                                        'Nidhi', Icons.star_purple500_rounded),
                                    ChipData(
                                        'Mishka', Icons.star_rate_outlined),
                                    ChipData(
                                        'Friend', Icons.star_purple500_rounded),
                                    ChipData(
                                        'Name', Icons.star_purple500_rounded)
                                  ],
                                  onChanged: (val) => choiceChipsValues5 = val,
                                  selectedChipStyle: ChipStyle(
                                    backgroundColor: AppColors.sliderColor,
                                    textStyle: theme.textTheme.bodyMedium,
                                    iconColor: AppColors.sliderColor,
                                    iconSize: 18.0,
                                    elevation: 0.0,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  unselectedChipStyle: ChipStyle(
                                    backgroundColor:
                                        AppColors.choicechipUnSelected,
                                    textStyle: theme.textTheme.bodySmall,
                                    iconColor: AppColors.sliderColor,
                                    iconSize: 16.0,
                                    elevation: 0.0,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  chipSpacing: 10.0,
                                  rowSpacing: 10.0,
                                  multiselect: true,
                                  alignment: WrapAlignment.start,
                                  controller: choiceChipsValueController5 ??=
                                      FormFieldController<List<String>>(
                                    [],
                                  ),
                                  wrapped: true,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    15.0, 0.0, 15.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                          color: const Color(
                                              0xFFE8DEF8), // Background color
                                          borderRadius:
                                              BorderRadius.circular(40.0),
                                        ),
                                        child: IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                            Icons.arrow_back,
                                            color: AppColors.sliderColor,
                                          ),
                                        )),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(15.0, 0.0, 0.0, 0.0),
                                        child: LinearPercentIndicator(
                                          percent: 1,
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  0.72,
                                          lineHeight: 12.0,
                                          animation: true,
                                          animateFromLastPercent: true,
                                          progressColor: AppColors.sliderColor,
                                          backgroundColor:
                                              AppColors.sliderBackground,
                                          barRadius:
                                              const Radius.circular(20.0),
                                          padding: EdgeInsets.zero,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    15.0, 0.0, 15.0, 0.0),
                                child: Text('Genre of the story',
                                    style: theme.textTheme.headlineLarge),
                              ),
                              Expanded(
                                child: ChoiceChips(
                                  options: const [
                                    ChipData(
                                        'Mom', Icons.star_purple500_rounded),
                                    ChipData(
                                        'Dad', Icons.star_purple500_rounded),
                                    ChipData(
                                        'Nidhi', Icons.star_purple500_rounded),
                                    ChipData(
                                        'Mishka', Icons.star_rate_outlined),
                                    ChipData(
                                        'Friend', Icons.star_purple500_rounded),
                                    ChipData(
                                        'Name', Icons.star_purple500_rounded)
                                  ],
                                  onChanged: (val) => choiceChipsValues6 = val,
                                  selectedChipStyle: ChipStyle(
                                    backgroundColor: AppColors.sliderColor,
                                    textStyle: theme.textTheme.bodyMedium,
                                    iconColor: AppColors.sliderColor,
                                    iconSize: 18.0,
                                    elevation: 0.0,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  unselectedChipStyle: ChipStyle(
                                    backgroundColor:
                                        AppColors.choicechipUnSelected,
                                    textStyle: theme.textTheme.bodySmall,
                                    iconColor: AppColors.sliderColor,
                                    iconSize: 16.0,
                                    elevation: 0.0,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  chipSpacing: 10.0,
                                  rowSpacing: 10.0,
                                  multiselect: true,
                                  alignment: WrapAlignment.start,
                                  controller: choiceChipsValueController6 ??=
                                      FormFieldController<List<String>>(
                                    [],
                                  ),
                                  wrapped: true,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.sizeOf(context).width * 1.0,
                  height: 100.0,
                  decoration: const BoxDecoration(
                      // color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.85,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () async {
                            await pageViewController?.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.ease,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            foregroundColor: Colors.white,
                            backgroundColor:
                                Colors.white, // Text (foreground) color
                          ),
                          child: Text("Continue",
                              style: theme.textTheme.bodyLarge!
                                  .copyWith(color: AppColors.textColorblue)),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget addoccasion(ThemeData theme, String title) => Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.85,
          height: 60,
          child: ElevatedButton(
            onPressed: () async {},
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              foregroundColor: AppColors.sliderColor,
              backgroundColor: AppColors.sliderColor, // Text (foreground) color
            ),
            child: Text(title,
                style: const TextStyle(color: AppColors.textColorWhite)),
          ),
        ),
      );
}

class FormFieldController<T> extends ValueNotifier<T?> {
  FormFieldController(this.initialValue) : super(initialValue);

  final T? initialValue;

  void reset() => value = initialValue;
  void update() => notifyListeners();
}

class FormListFieldController<T> extends FormFieldController<List<T>> {
  final List<T>? _initialListValue;

  FormListFieldController(super.initialValue)
      : _initialListValue = List<T>.from(initialValue ?? []);

  @override
  void reset() => value = List<T>.from(_initialListValue ?? []);
}