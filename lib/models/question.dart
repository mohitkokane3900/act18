class Question {
  final String question;
  final List<String> options;
  final String correctAnswer;

  Question({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    List<String> opts = List<String>.from(
      json['incorrect_answers'] as List<dynamic>,
    );
    opts.add(json['correct_answer']);
    opts.shuffle();

    return Question(
      question: json['question'],
      options: opts,
      correctAnswer: json['correct_answer'],
    );
  }
}
