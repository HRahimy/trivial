import 'package:flutter/widgets.dart';

class QuizKeys {
  static const Key loadableQuizScreen = Key('__loadableQuizScreen__');
  static const Key loadedQuizScreen = Key('__loadedQuizScreen__');
  static const Key quizRunningBody = Key('__quizRunningBody__');

  //region Quiz start menu
  static const Key quizStartMenu = Key('__quizStartMenu__');
  static const Key startMenuTitle = Key('__startMenuTitle__');
  static const Key startMenuDescriptionText = Key('__startMenuDescription__');
  static const Key startMenuQuestionsText = Key('__startMenuQuestionsText__');
  static const Key startMenuScoreText = Key('__startMenuScoreText__');
  static const Key startMenuPlayButton = Key('__startMenuPlayButton__');
  static const Key startMenuPlayButtonText = Key('__startMenuPlayButtonText__');
  static const Key startMenuBackButton = Key('__startMenuBackButton__');
  static const Key startMenuBackButtonText = Key('__startMenuBackButtonText__');

  //endregion

  //region Abort button
  static const Key abortButton = Key('__abortButton__');
  static const Key abortButtonText = Key('__abortButtonText__');
  static const Key abortButtonIcon = Key('__abortButtonIcon__');
  static const Key abortDialog = Key('__abortDialog__');
  static const Key abortDialogTitle = Key('__abortDialogTitle__');
  static const Key abortDialogSubtitle = Key('__abortDialogSubtitle__');
  static const Key abortDialogCancelButton = Key('__abortDialogCancelButton__');
  static const Key abortDialogCancelButtonText =
      Key('__abortDialogCancelButtonText__');
  static const Key abortDialogAcceptButton = Key('__abortDialogAcceptButton__');
  static const Key abortDialogAcceptButtonText =
      Key('__abortDialogAcceptButtonText__');

  //endregion

  //region Question panel
  static Function(String) get questionPanel =>
      (String id) => Key('__questionPanel_${id}__');

  static Function(String) get questionText =>
      (String id) => Key('__questionText_${id}__');

  //endregion

  // Timer must have unique key for each question to simplify
  // resetting the counter when questions change
  static Function(String) get questionTimer =>
      (String id) => Key('__questionTimer_${id}__');

  //region Score panel
  static const Key scorePanel = Key('__scorePanel__');
  static const Key scoreText = Key('__scoreText__');

  //endregion

  //region Options panel
  static Function(String) get optionsPanel =>
      (String id) => Key('__optionsPanel_${id}__');

  static Function(String) get optionAButton =>
      (String id) => Key('__optionAButton_${id}__');

  static Function(String) get optionAButtonText =>
      (String id) => Key('__optionAButtonText_${id}__');

  static Function(String) get optionBButton =>
      (String id) => Key('__optionBButton_${id}__');

  static Function(String) get optionBButtonText =>
      (String id) => Key('__optionBButtonText_${id}__');

  static Function(String) get optionCButton =>
      (String id) => Key('__optionCButton_${id}__');

  static Function(String) get optionCButtonText =>
      (String id) => Key('__optionCButtonText_${id}__');

  static Function(String) get optionDButton =>
      (String id) => Key('__optionDButton_${id}__');

  static Function(String) get optionDButtonText =>
      (String id) => Key('__optionDButtonText_${id}__');

  //endregion

  //region Answer controls section
  static Function(String) get answerControlsSection =>
      (String id) => Key('__answerControlsSection_${id}__');

  static Function(String) get selectMessage =>
      (String id) => Key('__selectMessage_${id}__');

  static Function(String) get confirmTile =>
      (String id) => Key('__confirmTile_${id}__');

  static Function(String) get confirmTileTitle =>
      (String id) => Key('__confirmMessage_${id}__');

  static Function(String) get confirmTileActionButton =>
      (String id) => Key('__confirmButton_${id}__');

  static Function(String) get confirmTileActionButtonIcon =>
      (String id) => Key('__confirmButtonIcon_${id}__');

  static Function(String) get continueTile =>
      (String id) => Key('__continueTile_${id}__');

  static Function(String) get continueTileCorrectTitle =>
      (String id) => Key('__correctMessage_${id}__');

  static Function(String) get continueTileCorrectScore =>
      (String id) => Key('__correctScoreMessage_${id}__');

  static Function(String) get continueTileIncorrectTitle =>
      (String id) => Key('__incorrectMessage_${id}__');

  static Function(String) get continueTileActionButton =>
      (String id) => Key('__continueButton_${id}__');

  static Function(String) get continueTileActionButtonIcon =>
      (String id) => Key('__continueButtonIcon_${id}__');

  //endregion

  //region Quiz end screen
  static const Key quizEndBody = Key('__quizEndBody__');
  static const Key twinkleContainer = Key('__twinkleContainer__');

  static const Key quizEndFlavorTextSection =
      Key('__quizEndFlavorTextSection__');
  static const Key quizEndFlavorText = Key('__quizEndFlavorText__');
  static const Key quizEndScoreText = Key('__quizEndScoreText__');

  static const Key quizEndControlsSection = Key('__quizEndControlsSection__');
  static const Key tryAgainButton = Key('__tryAgainButton__');
  static const Key tryAgainButtonText = Key('__tryAgainButtonText__');
  static const Key goodbyeButton = Key('__goodbyeButton__');
  static const Key goodbyeButtonText = Key('__goodbyeButtonText__');
//endregion
}
