import 'package:flutter/widgets.dart';

class QuizKeys {
  static const Key quizBody = Key('__quizBody__');

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

  //region Continue button
  static Function(String) get continueButton =>
      (String id) => Key('__continueButton_${id}__');

  static Function(String) get continueButtonText =>
      (String id) => Key('__continueButtonText_${id}__');

  //endregion

  //region Quiz end screen
  static const Key quizEndBody = Key('__quizEndBody__');

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
