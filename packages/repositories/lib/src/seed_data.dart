import 'package:repositories/src/models/quiz.dart';
import 'package:repositories/src/models/quiz_question.dart';

class SeedData {
  static const Quiz wowQuiz = Quiz(
    id: 1,
    name: 'World of Warcraft',
  );

  static const Quiz elderScrollsQuiz = Quiz(
    id: 2,
    name: 'Elder Scrolls',
  );

  static const List<Quiz> quizzes = [
    wowQuiz,
    elderScrollsQuiz,
  ];

  static const QuizQuestion wowQuestion1 = QuizQuestion(
    id: 1,
    quizId: 1,
    sequenceIndex: 1,
    points: 10,
    question: 'Who was the High Chieftain of the Tauren before Baine Bloodhoof',
    options: {
      OptionIndex.A: 'Cairne Bloodhoof',
      OptionIndex.B: 'Varok Saurfang',
      OptionIndex.C: 'Tamalaa Bloodhoof',
      OptionIndex.D: 'Elder Bloodhoof',
    },
    correctOption: OptionIndex.A,
  );

  static const QuizQuestion wowQuestion2 = QuizQuestion(
    id: 2,
    quizId: 1,
    sequenceIndex: 2,
    points: 15,
    question: 'Which of these creatures are native to Elwynn Forest?',
    options: {
      OptionIndex.A: 'Quillboar',
      OptionIndex.B: 'Murlocs',
      OptionIndex.C: 'Tauren',
      OptionIndex.D: 'Dreadlords',
    },
    correctOption: OptionIndex.B,
  );

  static const QuizQuestion wowQuestion3 = QuizQuestion(
    id: 3,
    quizId: 1,
    sequenceIndex: 3,
    points: 20,
    question: 'What is the title of Stormwind\'s ruling monarch?',
    options: {
      OptionIndex.A: 'High Priest',
      OptionIndex.B: 'Prophet',
      OptionIndex.C: 'King',
      OptionIndex.D: 'Overlord',
    },
    correctOption: OptionIndex.C,
  );

  static const QuizQuestion wowQuestion4 = QuizQuestion(
    id: 4,
    quizId: 1,
    sequenceIndex: 4,
    points: 25,
    question:
        'The primary means of aerial zone-to-zone travel on Azeroth and beyond is managed by a group of NPCs called',
    options: {
      OptionIndex.A: 'Wing Lords',
      OptionIndex.B: 'Aviators',
      OptionIndex.C: 'Flight Masters',
      OptionIndex.D: 'Skylords',
    },
    correctOption: OptionIndex.C,
  );

  static const QuizQuestion wowQuestion5 = QuizQuestion(
    id: 5,
    quizId: 1,
    sequenceIndex: 5,
    points: 30,
    question:
        'The ranks of which of these covenants consist of manual workers which bear a strong visual resemblance to owls?',
    options: {
      OptionIndex.A: 'The Venthyr',
      OptionIndex.B: 'The Necrolords',
      OptionIndex.C: 'The Night Fae',
      OptionIndex.D: 'The Kyrian',
    },
    correctOption: OptionIndex.D,
  );

  static const QuizQuestion wowQuestion6 = QuizQuestion(
    id: 6,
    quizId: 1,
    sequenceIndex: 6,
    points: 35,
    question:
        'In the context of today\'s state of the game (9.0.2), which of these words portends doom in the eyes of most PvP enthusiasts when facing a feathered beast?',
    options: {
      OptionIndex.A: 'Golf stroke',
      OptionIndex.B: 'Egg yolk',
      OptionIndex.C: 'Slowpoke',
      OptionIndex.D: 'Convoke',
    },
    correctOption: OptionIndex.D,
  );

  static const QuizQuestion wowQuestion7 = QuizQuestion(
    id: 7,
    quizId: 1,
    sequenceIndex: 7,
    points: 40,
    question:
        'The name \'Coldheart Interstitia\' is associated with which of these options?',
    options: {
      OptionIndex.A: 'Naxxramas',
      OptionIndex.B: 'Torghast',
      OptionIndex.C: 'Frost mages',
      OptionIndex.D: 'Frost death knights',
    },
    correctOption: OptionIndex.B,
  );

  static const QuizQuestion wowQuestion8 = QuizQuestion(
    id: 8,
    quizId: 1,
    sequenceIndex: 8,
    points: 45,
    question:
        'How many dungeons and raids with the word \'Blackrock\' in their name exist in the game?',
    options: {
      OptionIndex.A: '6',
      OptionIndex.B: '5',
      OptionIndex.C: '3',
      OptionIndex.D: '5',
    },
    correctOption: OptionIndex.D,
  );

  static const QuizQuestion wowQuestion9 = QuizQuestion(
    id: 9,
    quizId: 1,
    sequenceIndex: 9,
    points: 50,
    question:
        'In which year was World of Warcraft: Mists of Pandaria released?',
    options: {
      OptionIndex.A: '2012',
      OptionIndex.B: '2011',
      OptionIndex.C: '2013',
      OptionIndex.D: '2010',
    },
    correctOption: OptionIndex.A,
  );

  static const QuizQuestion wowQuestion10 = QuizQuestion(
    id: 10,
    quizId: 1,
    sequenceIndex: 10,
    points: 55,
    question:
        'What is the name of the disease strain which Vectis in Uldir infects players during its encounter?',
    options: {
      OptionIndex.A: 'Delta Parasite',
      OptionIndex.B: 'Red Death virus',
      OptionIndex.C: 'Omega Vector',
      OptionIndex.D: 'Hematocythemia',
    },
    correctOption: OptionIndex.C,
  );

  static const QuizQuestion wowQuestion11 = QuizQuestion(
    id: 11,
    quizId: 1,
    sequenceIndex: 11,
    points: 60,
    question:
        'Which electric term inspired the name of the first boss encounter of The Mechanar',
    options: {
      OptionIndex.A: 'Reactance',
      OptionIndex.B: 'Inductance',
      OptionIndex.C: 'Capacitance',
      OptionIndex.D: 'Resistance',
    },
    correctOption: OptionIndex.C,
  );

  static const QuizQuestion wowQuestion12 = QuizQuestion(
    id: 12,
    quizId: 1,
    sequenceIndex: 12,
    points: 65,
    question:
        'What was the name of the Iron Horde\'s expeditionary force tasked with invading Azeroth?',
    options: {
      OptionIndex.A: 'The Iron March',
      OptionIndex.B: 'The Grom\'kar',
      OptionIndex.C: 'Dragonmaw Expedition',
      OptionIndex.D: 'Blackrock Legion',
    },
    correctOption: OptionIndex.A,
  );

  static const QuizQuestion wowQuestion13 = QuizQuestion(
    id: 13,
    quizId: 1,
    sequenceIndex: 13,
    points: 70,
    question:
        'Players who wish to reach the peak of Mount Neverest by foot must begin their ascent from which side of the mountain\'s base?',
    options: {
      OptionIndex.A: 'Eastern',
      OptionIndex.B: 'Northern',
      OptionIndex.C: 'Southern',
      OptionIndex.D: 'Western',
    },
    correctOption: OptionIndex.B,
  );

  static const QuizQuestion wowQuestion14 = QuizQuestion(
    id: 14,
    quizId: 1,
    sequenceIndex: 14,
    points: 75,
    question:
        'Which of these green dragons, once guardians of the outdoor Emerald Dream portals, appears in the Emerald Nightmare raid instance?',
    options: {
      OptionIndex.A: 'Lethlas',
      OptionIndex.B: 'Rothos',
      OptionIndex.C: 'Dreamstalker',
      OptionIndex.D: 'Dreamtracker',
    },
    correctOption: OptionIndex.B,
  );

  static const QuizQuestion wowQuestion15 = QuizQuestion(
    id: 15,
    quizId: 1,
    sequenceIndex: 15,
    points: 80,
    question:
        'In which expansion did the Ankylodon specie make it\'s first appearance in-game?',
    options: {
      OptionIndex.A: 'Battle for Azeroth',
      OptionIndex.B: 'Mists of Pandaria',
      OptionIndex.C: 'Warlords of Draenor',
      OptionIndex.D: 'Legion',
    },
    correctOption: OptionIndex.A,
  );

  static const QuizQuestion wowQuestion16 = QuizQuestion(
    id: 16,
    quizId: 1,
    sequenceIndex: 16,
    points: 85,
    question:
        'Which of these pieces of the Ironweave Battlesuit set is still obtainable in the retail version of World of Warcraft?',
    options: {
      OptionIndex.A: 'Pants',
      OptionIndex.B: 'Boots',
      OptionIndex.C: 'Cowl',
      OptionIndex.D: 'Bracers',
    },
    correctOption: OptionIndex.D,
  );

  static const QuizQuestion wowQuestion17 = QuizQuestion(
    id: 17,
    quizId: 1,
    sequenceIndex: 17,
    points: 90,
    question:
        'In which month of the year 2016 did Chris Metzen announce his retirement from Blizzard Entertainment',
    options: {
      OptionIndex.A: 'September',
      OptionIndex.B: 'July',
      OptionIndex.C: 'June',
      OptionIndex.D: 'October',
    },
    correctOption: OptionIndex.A,
  );

  static const QuizQuestion wowQuestion18 = QuizQuestion(
    id: 18,
    quizId: 1,
    sequenceIndex: 18,
    points: 95,
    question:
        'In the fateful story of Pyramond and Theleste, what was it about the latter that prompted Pyramond\'s parents to disallow their son from meeting Theleste?',
    options: {
      OptionIndex.A: 'Her social class',
      OptionIndex.B: 'Her age',
      OptionIndex.C: 'Her race',
      OptionIndex.D: 'Her lineage',
    },
    correctOption: OptionIndex.A,
  );

  static const List<QuizQuestion> wowQuestions = [
    wowQuestion1,
    wowQuestion2,
    wowQuestion3,
    wowQuestion4,
    wowQuestion5,
    wowQuestion6,
    wowQuestion7,
    wowQuestion8,
    wowQuestion9,
    wowQuestion10,
    wowQuestion11,
    wowQuestion12,
    wowQuestion13,
    wowQuestion14,
    wowQuestion15,
    wowQuestion16,
    wowQuestion17,
    wowQuestion18,
  ];
}
