import 'package:flutter/material.dart';
import '../models/question.dart';
import '../services/api_service.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Question> _questions = [];
  int _index = 0;
  int _score = 0;
  bool _loading = true;
  bool _answered = false;
  String _selected = "";
  String _feedback = "";

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final qs = await ApiService.fetchQuestions();
    setState(() {
      _questions = qs;
      _loading = false;
    });
  }

  void _select(String answer) {
    if (_answered) return;

    final correct = _questions[_index].correctAnswer;

    setState(() {
      _selected = answer;
      _answered = true;

      if (answer == correct) {
        _score++;
        _feedback = "Correct! The answer is $correct.";
      } else {
        _feedback = "Incorrect. The correct answer is $correct.";
      }
    });
  }

  void _next() {
    setState(() {
      _answered = false;
      _selected = "";
      _feedback = "";
      _index++;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_index >= _questions.length) {
      return Scaffold(
        body: Center(
          child: Text(
            "Quiz Finished! Score: $_score/${_questions.length}",
            style: const TextStyle(fontSize: 22),
          ),
        ),
      );
    }

    final q = _questions[_index];

    return Scaffold(
      appBar: AppBar(title: const Text("Quiz App")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Question ${_index + 1}/${_questions.length}",
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 16),
            Text(q.question, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            ...q.options.map(
              (opt) => ElevatedButton(
                onPressed: () => _select(opt),
                child: Text(opt),
              ),
            ),
            const SizedBox(height: 20),
            if (_answered)
              Text(
                _feedback,
                style: TextStyle(
                  fontSize: 16,
                  color: _selected == q.correctAnswer
                      ? Colors.green
                      : Colors.red,
                ),
              ),
            const SizedBox(height: 10),
            if (_answered)
              ElevatedButton(
                onPressed: _next,
                child: const Text("Next Question"),
              ),
          ],
        ),
      ),
    );
  }
}
