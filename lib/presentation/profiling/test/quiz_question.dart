// ─────────────────────────────────────────────────────────────────────────────
// Quiz Question Model
//
// Represents a single multiple-choice chemistry question.
// ─────────────────────────────────────────────────────────────────────────────

class QuizQuestion {
  /// The main question text.
  final String question;

  /// A short contextual hint shown below the question.
  final String hint;

  /// Exactly 4 answer options (A, B, C, D).
  final List<String> options;

  /// Zero-based index of the correct answer in [options].
  final int correctIndex;

  const QuizQuestion({
    required this.question,
    required this.hint,
    required this.options,
    required this.correctIndex,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Question Bank — 15 Chemistry Questions
// ─────────────────────────────────────────────────────────────────────────────

const List<QuizQuestion> kChemistryQuestions = [
  QuizQuestion(
    question: 'What is the atomic symbol for Gold on the periodic table?',
    hint: 'Gold is a chemical element with atomic number 79. It is one of the higher atomic number elements that occur naturally.',
    options: ['Au', 'Ag', 'Gd', 'Go'],
    correctIndex: 0,
  ),
  QuizQuestion(
    question: 'How many electrons can the second energy level (n=2) hold?',
    hint: 'Energy levels follow the formula 2n², where n is the principal quantum number.',
    options: ['2', '4', '8', '16'],
    correctIndex: 2,
  ),
  QuizQuestion(
    question: 'What type of bond is formed between Na and Cl in table salt?',
    hint: 'This bond involves a complete transfer of electrons from one atom to another, creating oppositely charged ions.',
    options: ['Covalent', 'Ionic', 'Metallic', 'Hydrogen'],
    correctIndex: 1,
  ),
  QuizQuestion(
    question: 'What is the pH of a neutral solution at 25°C?',
    hint: 'pH measures the concentration of hydrogen ions in a solution. Pure water at 25°C is the standard reference.',
    options: ['0', '5', '7', '14'],
    correctIndex: 2,
  ),
  QuizQuestion(
    question: 'Which element has the highest electronegativity?',
    hint: 'Electronegativity generally increases across a period and decreases down a group on the periodic table.',
    options: ['Oxygen', 'Chlorine', 'Nitrogen', 'Fluorine'],
    correctIndex: 3,
  ),
  QuizQuestion(
    question: 'What is the molecular formula for water?',
    hint: 'Water is the most abundant compound on Earth\'s surface and is essential for all known life.',
    options: ['HO', 'H₂O₂', 'H₂O', 'OH'],
    correctIndex: 2,
  ),
  QuizQuestion(
    question: 'In a chemical equation, what does a subscript number represent?',
    hint: 'Subscripts appear after element symbols and cannot be changed when balancing an equation.',
    options: ['Number of molecules', 'Number of atoms of that element in a molecule', 'Atomic mass', 'Charge of the ion'],
    correctIndex: 1,
  ),
  QuizQuestion(
    question: 'Which gas makes up approximately 78% of Earth\'s atmosphere?',
    hint: 'This diatomic gas is also essential for making amino acids and proteins in living organisms.',
    options: ['Oxygen', 'Carbon Dioxide', 'Argon', 'Nitrogen'],
    correctIndex: 3,
  ),
  QuizQuestion(
    question: 'What is the SI unit for the amount of substance?',
    hint: 'This unit is named after the scientist Amadeo Avogadro and is defined as 6.02 × 10²³ particles.',
    options: ['Gram', 'Dalton', 'Mole', 'Kelvin'],
    correctIndex: 2,
  ),
  QuizQuestion(
    question: 'Which type of reaction releases energy to the surroundings?',
    hint: 'Think about combustion reactions — burning wood produces both light and heat.',
    options: ['Endothermic', 'Exothermic', 'Photosynthesis', 'Electrolysis'],
    correctIndex: 1,
  ),
  QuizQuestion(
    question: 'What is the atomic number of Carbon?',
    hint: 'Carbon is the backbone of all organic Chemistry and is the 6th element in the periodic table.',
    options: ['4', '6', '8', '12'],
    correctIndex: 1,
  ),
  QuizQuestion(
    question: 'Which of the following is a noble gas?',
    hint: 'Noble gases are in Group 18 and are largely unreactive due to their full outer electron shells.',
    options: ['Chlorine', 'Nitrogen', 'Helium', 'Hydrogen'],
    correctIndex: 2,
  ),
  QuizQuestion(
    question: 'What is the law of conservation of mass?',
    hint: 'Antoine Lavoisier first proposed this law after careful measurements of chemical reactions.',
    options: [
      'Mass can be created in a reaction',
      'Mass is always destroyed during combustion',
      'Mass of reactants equals mass of products',
      'Energy equals mass times velocity',
    ],
    correctIndex: 2,
  ),
  QuizQuestion(
    question: 'What is the oxidation state of Hydrogen in most compounds?',
    hint: 'Hydrogen is found in Group 1 and typically loses its one electron when forming bonds.',
    options: ['-1', '0', '+1', '+2'],
    correctIndex: 2,
  ),
  QuizQuestion(
    question: 'Which particle has no electrical charge?',
    hint: 'This subatomic particle is found in the nucleus alongside protons and acts as the "glue" of the nucleus.',
    options: ['Proton', 'Electron', 'Neutron', 'Positron'],
    correctIndex: 2,
  ),
];
