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

  static const QuizQuestion scrollsQuestion1 = QuizQuestion(
    id: 19,
    quizId: 2,
    sequenceIndex: 1,
    points: 1,
    question:
        'By what title was the Guild Master of the Thieves Guild once known?',
    options: {
      OptionIndex.A: 'Shadow Fox',
      OptionIndex.B: 'Grey Fox',
      OptionIndex.C: 'Black Fox',
      OptionIndex.D: 'Phantom Fox',
    },
    correctOption: OptionIndex.B,
  );

  static const QuizQuestion scrollsQuestion2 = QuizQuestion(
    id: 20,
    quizId: 2,
    sequenceIndex: 2,
    points: 5,
    question:
        'What Daedric Realm is said to be so beautiful that mortals are half-blinded upon entering it?',
    options: {
      OptionIndex.A: 'Moonshadow (Azura)',
      OptionIndex.B: 'Colored Rooms (Meridia)',
      OptionIndex.C: 'Evergloam (Nocturnal)',
      OptionIndex.D: 'Hunting Grounds (Hircine)',
    },
    correctOption: OptionIndex.A,
  );

  static const QuizQuestion scrollsQuestion3 = QuizQuestion(
    id: 21,
    quizId: 2,
    sequenceIndex: 3,
    points: 6,
    question: 'What race worships The Twelve Divines?',
    options: {
      OptionIndex.A: 'Redguard',
      OptionIndex.B: 'Dunmer (Dark Elf)',
      OptionIndex.C: 'Khajiit',
      OptionIndex.D: 'Breton',
    },
    correctOption: OptionIndex.D,
  );

  static const QuizQuestion scrollsQuestion4 = QuizQuestion(
    id: 22,
    quizId: 2,
    sequenceIndex: 4,
    points: 8,
    question: 'What is the Argonian native language?',
    options: {
      OptionIndex.A: 'Jel',
      OptionIndex.B: 'Ta\'agra',
      OptionIndex.C: 'Tamrielic',
      OptionIndex.D: 'Ayleidoon',
    },
    correctOption: OptionIndex.A,
  );

  static const QuizQuestion scrollsQuestion5 = QuizQuestion(
    id: 23,
    quizId: 2,
    sequenceIndex: 5,
    points: 10,
    question: 'What realm/plane does the Daedric Prince Paryite command?',
    options: {
      OptionIndex.A: 'Deadlands',
      OptionIndex.B: 'Ashpit',
      OptionIndex.C: 'The Pits',
      OptionIndex.D: 'Coldharbor',
    },
    correctOption: OptionIndex.C,
  );

  static const QuizQuestion scrollsQuestion6 = QuizQuestion(
    id: 24,
    quizId: 2,
    sequenceIndex: 6,
    points: 12,
    question: 'What province in Tamriel is known for its sweets and pastries',
    options: {
      OptionIndex.A: 'Cyrodiil',
      OptionIndex.B: 'Elsweyr',
      OptionIndex.C: 'Valenwood',
      OptionIndex.D: 'Summerset Isles',
    },
    correctOption: OptionIndex.B,
  );

  static const QuizQuestion scrollsQuestion7 = QuizQuestion(
    id: 25,
    quizId: 2,
    sequenceIndex: 7,
    points: 15,
    question:
        'Which God/Goddess is most directly responsible for the creation of Nirn?',
    options: {
      OptionIndex.A: 'Akatosh',
      OptionIndex.B: 'Khyne',
      OptionIndex.C: 'Sithis',
      OptionIndex.D: 'Lorkhan (Shor)',
    },
    correctOption: OptionIndex.D,
  );

  static const QuizQuestion scrollsQuestion8 = QuizQuestion(
    id: 26,
    quizId: 2,
    sequenceIndex: 8,
    points: 18,
    question: 'Which Daedric Prince created vampires?',
    options: {
      OptionIndex.A: 'Nocturnal',
      OptionIndex.B: 'Molag Bal',
      OptionIndex.C: 'Mephala',
      OptionIndex.D: 'Vaermina',
    },
    correctOption: OptionIndex.B,
  );

  static const QuizQuestion scrollsQuestion9 = QuizQuestion(
    id: 27,
    quizId: 2,
    sequenceIndex: 9,
    points: 20,
    question:
        'Which of these lycans/were-creatures does NOT exist, nor have any (unproven) rumors of existence?',
    options: {
      OptionIndex.A: 'Wereboar',
      OptionIndex.B: 'Werevulture',
      OptionIndex.C: 'Wereskeever',
      OptionIndex.D: 'Wereshark',
    },
    correctOption: OptionIndex.C,
  );

  static const QuizQuestion scrollsQuestion10 = QuizQuestion(
    id: 28,
    quizId: 2,
    sequenceIndex: 10,
    points: 22,
    question: 'Which of these words in Dunmeri is an insult?',
    options: {
      OptionIndex.A: 'Gahmerdohn',
      OptionIndex.B: 'Aka',
      OptionIndex.C: 'Albumuhr',
      OptionIndex.D: 'S\'wit',
    },
    correctOption: OptionIndex.D,
  );

  static const QuizQuestion scrollsQuestion11 = QuizQuestion(
    id: 29,
    quizId: 2,
    sequenceIndex: 11,
    points: 25,
    question: 'Which of these is an alternate name for the province of Skyrim?',
    options: {
      OptionIndex.A: 'The Fatherland',
      OptionIndex.B: 'Atmora',
      OptionIndex.C: 'Hegathe',
      OptionIndex.D: 'Volenfell',
    },
    correctOption: OptionIndex.A,
  );

  static const QuizQuestion scrollsQuestion12 = QuizQuestion(
    id: 30,
    quizId: 2,
    sequenceIndex: 12,
    points: 28,
    question:
        'During the duel at the Tor, whose name was Pelinal Whitestrake said to have praised dispite this person not being born until thousands of years later?',
    options: {
      OptionIndex.A: 'Tiber Septim',
      OptionIndex.B: 'Vivec',
      OptionIndex.C: 'Voryn Dagoth',
      OptionIndex.D: 'Reman Cyrodiil',
    },
    correctOption: OptionIndex.D,
  );

  static const QuizQuestion scrollsQuestion13 = QuizQuestion(
    id: 31,
    quizId: 2,
    sequenceIndex: 13,
    points: 30,
    question:
        'Who was the first known human to master the Elven methods of enchanting?',
    options: {
      OptionIndex.A: 'Miraak',
      OptionIndex.B: 'Ahzidal',
      OptionIndex.C: 'Krosis',
      OptionIndex.D: 'Nahkriin',
    },
    correctOption: OptionIndex.B,
  );

  static const QuizQuestion scrollsQuestion14 = QuizQuestion(
    id: 32,
    quizId: 2,
    sequenceIndex: 14,
    points: 32,
    question:
        'What race was said to have created the Thrassian Plague that killed half of Tamriels population around the 1E 2200s?',
    options: {
      OptionIndex.A: 'Tsaesci',
      OptionIndex.B: 'Yokudans',
      OptionIndex.C: 'Sload',
      OptionIndex.D: 'Altmer',
    },
    correctOption: OptionIndex.C,
  );

  static const QuizQuestion scrollsQuestion15 = QuizQuestion(
    id: 33,
    quizId: 2,
    sequenceIndex: 15,
    points: 35,
    question: 'What is believed to be the oldest building in Tamriel?',
    options: {
      OptionIndex.A: 'Jorrvaskr',
      OptionIndex.B: 'The White Gold Tower',
      OptionIndex.C: 'The Adamantine Tower',
      OptionIndex.D: 'Saarthal',
    },
    correctOption: OptionIndex.C,
  );

  static const List<QuizQuestion> scrollsQuestions = [
    scrollsQuestion1,
    scrollsQuestion2,
    scrollsQuestion3,
    scrollsQuestion4,
    scrollsQuestion5,
    scrollsQuestion6,
    scrollsQuestion7,
    scrollsQuestion8,
    scrollsQuestion9,
    scrollsQuestion10,
    scrollsQuestion11,
    scrollsQuestion12,
    scrollsQuestion13,
    scrollsQuestion14,
    scrollsQuestion15,
  ];

  static const List<QuizQuestion> allQuestions = [
    ...wowQuestions,
    ...scrollsQuestions,
  ];
}
