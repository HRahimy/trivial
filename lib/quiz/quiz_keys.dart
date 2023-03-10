import 'package:flutter/widgets.dart';

class QuizKeys {
  static const Key quizBody = Key('__quizBody__');

  static const Key questionPanel = Key('__questionPanel__');
  static const Key questionText = Key('__questionText__');

  // Timer must have unique key for each question to simplify
  // resetting the counter when questions change
  static Function(String) get questionTimer =>
          (String id) => Key('__questionTimer_$id');

  static const Key scorePanel = Key('__scorePanel__');
  static const Key scoreText = Key('__scoreText__');

  static const Key optionsPanel = Key('__optionsPanel__');
  static const Key optionAButton = Key('__optionAButton__');
  static const Key optionAButtonText = Key('__optionAButtonText__');
  static const Key optionBButton = Key('__optionBButton__');
  static const Key optionBButtonText = Key('__optionBButtonText__');
  static const Key optionCButton = Key('__optionCButton__');
  static const Key optionCButtonText = Key('__optionCButtonText__');
  static const Key optionDButton = Key('__optionDButton__');
  static const Key optionDButtonText = Key('__optionDButtonText__');

  static const Key continueButton = Key('__continueButton__');
  static const Key continueButtonText = Key('__continueButtonText__');

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
}
