import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  final String selectedClass;
  final String subject;
  final String chapter;
  final int quizSetNumber;

  const QuizScreen({
    super.key,
    required this.selectedClass,
    this.subject = 'Science',
    this.chapter = 'Chapter 1',
    this.quizSetNumber = 1,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  // [याद रखें: यह टेस्टिंग डेटा है, बाद में Google Sheets कनेक्ट होते ही इसे हटाएंगे]
  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'विद्युत धारा (Electric Current) का SI मात्रक क्या है?',
      'options': ['Ampere', 'Volt', 'Ohm', 'Watt'],
      'answer': 'Ampere',
    },
    {
      'question': 'पौधों में प्रकाश संश्लेषण (Photosynthesis) के दौरान कौन-सी गैस निकलती है?',
      'options': ['Carbon Dioxide', 'Oxygen', 'Nitrogen', 'Hydrogen'],
      'answer': 'Oxygen',
    },
    {
      'question': 'जल का रासायनिक सूत्र (Chemical Formula) क्या है?',
      'options': ['CO2', 'NaCl', 'H2O', 'CH4'],
      'answer': 'H2O',
    },
  ];

  int _currentIndex = 0;
  String? _selectedOption;
  int _score = 0;
  bool _answered = false;

  void _checkAnswer(String option) {
    if (_answered) return;

    setState(() {
      _selectedOption = option;
      _answered = true;
      if (option == _questions[_currentIndex]['answer']) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedOption = null;
        _answered = false;
      });
    } else {
      _showResultDialog();
    }
  }

  void _showResultDialog() {
    const neonCyan = Color(0xFF00F0FF);
    const neonGreen = Color(0xFF00FF66);

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0B111E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: neonCyan, width: 1.5),
        ),
        title: Column(
          children: [
            const Icon(Icons.military_tech, color: neonGreen, size: 44),
            const SizedBox(height: 8),
            const Text(
              '// SIMULATION COMPLETE',
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'monospace',
                letterSpacing: 2,
                color: neonCyan,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'SET 0${widget.quizSetNumber} EVALUATION',
              style: const TextStyle(color: Colors.white70, fontSize: 13, fontFamily: 'monospace'),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: neonGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: neonGreen.withValues(alpha: 0.5)),
              ),
              child: Text(
                '$_score / ${_questions.length}',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: neonGreen,
                  letterSpacing: 2,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _score == _questions.length
                  ? 'PERFECT MATRIX OVERRIDE! 🎯'
                  : 'GOOD EFFORT • RE-SIMULATE FOR 100%',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white54, fontSize: 11),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('EXIT', style: TextStyle(color: Colors.white60, fontFamily: 'monospace')),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: neonCyan.withValues(alpha: 0.2),
              foregroundColor: neonCyan,
              side: const BorderSide(color: neonCyan),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _currentIndex = 0;
                _selectedOption = null;
                _answered = false;
                _score = 0;
              });
            },
            child: const Text('RE-ENGAGE', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const darkVoid = Color(0xFF070B14);
    const neonCyan = Color(0xFF00F0FF);
    const neonGreen = Color(0xFF00FF66);
    const neonRed = Color(0xFFFF0055);

    final currentQ = _questions[_currentIndex];
    final progress = (_currentIndex + 1) / _questions.length;

    return Scaffold(
      backgroundColor: darkVoid,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0F1D),
        elevation: 0,
        iconTheme: const IconThemeData(color: neonCyan),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '// ${widget.subject.toUpperCase()}',
                  style: const TextStyle(color: neonCyan, fontSize: 11, fontFamily: 'monospace', letterSpacing: 1.2),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(
                    color: neonGreen.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: neonGreen.withValues(alpha: 0.4)),
                  ),
                  child: Text(
                    'SET 0${widget.quizSetNumber}',
                    style: const TextStyle(color: neonGreen, fontSize: 9, fontFamily: 'monospace', fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              widget.chapter,
              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Linear Cyber Progress HUD
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'PHASE 0${_currentIndex + 1} / 0${_questions.length}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: neonCyan,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  'SCORE: $_score',
                  style: const TextStyle(
                    fontSize: 11,
                    color: neonGreen,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 4,
                backgroundColor: Colors.white10,
                valueColor: const AlwaysStoppedAnimation<Color>(neonCyan),
              ),
            ),
            const SizedBox(height: 20),

            // Question Container
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF0D1524),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: neonCyan.withValues(alpha: 0.35), width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: neonCyan.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '// QUERY MATRIX',
                    style: TextStyle(
                      color: neonCyan.withValues(alpha: 0.7),
                      fontSize: 10,
                      fontFamily: 'monospace',
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    currentQ['question'],
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            // Options List
            Expanded(
              child: ListView.builder(
                itemCount: currentQ['options'].length,
                itemBuilder: (context, index) {
                  final option = currentQ['options'][index];
                  final optionLetter = String.fromCharCode(65 + index); // A, B, C, D

                  Color cardBg = const Color(0xFF0B111E);
                  Color borderColor = Colors.white12;
                  Color textColor = Colors.white;
                  Color badgeColor = neonCyan;

                  if (_answered) {
                    if (option == currentQ['answer']) {
                      cardBg = neonGreen.withValues(alpha: 0.12);
                      borderColor = neonGreen;
                      badgeColor = neonGreen;
                      textColor = Colors.white;
                    } else if (option == _selectedOption) {
                      cardBg = neonRed.withValues(alpha: 0.12);
                      borderColor = neonRed;
                      badgeColor = neonRed;
                      textColor = Colors.white;
                    }
                  }

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor, width: 1.2),
                      boxShadow: _answered && (option == currentQ['answer'] || option == _selectedOption)
                          ? [
                              BoxShadow(
                                color: (option == currentQ['answer'] ? neonGreen : neonRed).withValues(alpha: 0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              )
                            ]
                          : [],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _checkAnswer(option),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          child: Row(
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: badgeColor.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: badgeColor.withValues(alpha: 0.4)),
                                ),
                                child: Text(
                                  optionLetter,
                                  style: TextStyle(
                                    color: badgeColor,
                                    fontSize: 12,
                                    fontFamily: 'monospace',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  option,
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              if (_answered && option == currentQ['answer'])
                                const Icon(Icons.check_circle_rounded, color: neonGreen, size: 22),
                              if (_answered && option == _selectedOption && option != currentQ['answer'])
                                const Icon(Icons.cancel_rounded, color: neonRed, size: 22),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Next / Finish Action Button
            if (_answered)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _nextQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: neonCyan.withValues(alpha: 0.2),
                    foregroundColor: neonCyan,
                    side: const BorderSide(color: neonCyan, width: 1.2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _currentIndex == _questions.length - 1 ? 'TERMINATE SIMULATION' : 'PROCEED TO NEXT QUERY',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1.2, fontFamily: 'monospace'),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward, size: 16),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}