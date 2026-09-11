import 'package:flutter/material.dart';
import 'quiz_screen.dart';

class SubjectScreen extends StatelessWidget {
  final String selectedClass;
  final String mode; // 'mcq', 'practice', या 'notes'

  const SubjectScreen({
    super.key,
    required this.selectedClass,
    required this.mode,
  });

  // डेमो डेटा (चैप्टर लिस्ट - बाद में Google Sheet से आएगी)
  final List<Map<String, dynamic>> subjects = const [
    {
      'name': 'Science',
      'icon': Icons.science,
      'color': Colors.teal,
      'chapters': [
        'Chapter 1: Chemical Reactions & Equations',
        'Chapter 2: Acids, Bases and Salts',
        'Chapter 3: Metals and Non-metals',
        'Chapter 4: Life Processes',
      ]
    },
    {
      'name': 'Mathematics',
      'icon': Icons.calculate,
      'color': Colors.indigo,
      'chapters': [
        'Chapter 1: Real Numbers',
        'Chapter 2: Polynomials',
        'Chapter 3: Quadratic Equations',
      ]
    },
    {
      'name': 'Social Science / History',
      'icon': Icons.history_edu,
      'color': Colors.brown,
      'chapters': [
        'Chapter 1: The Rise of Nationalism in Europe',
        'Chapter 2: Nationalism in India',
      ]
    },
  ];

  // 1. MCQ के लिए 5 क्विज़ सेट्स वाली शीट
  void _openQuizSetsSheet(BuildContext context, String subjectName, String chapterTitle) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(chapterTitle, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('Choose a Quiz Set (20 Questions each)', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
              const SizedBox(height: 16),
              ...List.generate(5, (index) {
                final quizNum = index + 1;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: Colors.deepPurple.shade50,
                    child: Text('$quizNum', style: const TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold)),
                  ),
                  title: Text('Quiz Set $quizNum', style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text('20 Questions • 15 Mins', style: TextStyle(fontSize: 12)),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizScreen(
                            selectedClass: selectedClass,
                            subject: subjectName,
                            chapter: chapterTitle,
                            quizSetNumber: quizNum,
                          ),
                        ),
                      );
                    },
                    child: const Text('Start'),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  // 2. Practice Questions के लिए PDF Question Sets वाली शीट
  void _openPracticePdfsSheet(BuildContext context, String subjectName, String chapterTitle) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(chapterTitle, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('Practice Question Sets (PDFs)', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
              const SizedBox(height: 16),
              ...List.generate(3, (index) {
                final setNum = index + 1;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.picture_as_pdf, color: Colors.orange),
                  ),
                  title: Text('Practice Set $setNum (Questions & Solutions)', style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text('Downloadable PDF • 8 Pages', style: TextStyle(fontSize: 12)),
                  trailing: ElevatedButton.icon(
                    icon: const Icon(Icons.remove_red_eye, size: 16),
                    label: const Text('View PDF'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Opening PDF: Practice Set $setNum for $chapterTitle')),
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  // 3. Purix Notes के लिए PDF Notes वाली शीट
  void _openNotesSheet(BuildContext context, String subjectName, String chapterTitle) {
    final noteTypes = [
      {'title': 'Complete Chapter Notes (Purix Special)', 'desc': 'Full concepts + diagrams', 'color': Colors.purple},
      {'title': 'Quick Revision & Formula Sheet', 'desc': '1-page short summary', 'color': Colors.deepPurple},
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(chapterTitle, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('Purix Academy Study Notes (PDF)', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
              const SizedBox(height: 16),
              ...noteTypes.map((note) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.menu_book, color: Colors.purple),
                  ),
                  title: Text(note['title'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  subtitle: Text(note['desc'] as String, style: const TextStyle(fontSize: 12)),
                  trailing: ElevatedButton.icon(
                    icon: const Icon(Icons.visibility, size: 16),
                    label: const Text('Read'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Opening Notes: ${note['title']}')),
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String titleText;
    IconData leadingIcon;
    Color themeColor;
    String badgeText;

    if (mode == 'mcq') {
      titleText = '$selectedClass - MCQ Test';
      leadingIcon = Icons.quiz;
      themeColor = Colors.green;
      badgeText = '5 Sets';
    } else if (mode == 'practice') {
      titleText = '$selectedClass - Practice Questions';
      leadingIcon = Icons.edit_note;
      themeColor = Colors.orange;
      badgeText = 'Practice PDFs';
    } else {
      titleText = '$selectedClass - Purix Notes';
      leadingIcon = Icons.menu_book;
      themeColor = Colors.purple;
      badgeText = 'Purix Notes';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(titleText, style: const TextStyle(color: Colors.white, fontSize: 17)),
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: subjects.length,
        itemBuilder: (context, sIndex) {
          final sub = subjects[sIndex];
          final chapters = sub['chapters'] as List<String>;

          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ExpansionTile(
              leading: CircleAvatar(
                backgroundColor: (sub['color'] as Color).withValues(alpha: 0.15),
                child: Icon(sub['icon'] as IconData, color: sub['color'] as Color),
              ),
              title: Text(
                sub['name'],
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Text('${chapters.length} Chapters available', style: const TextStyle(fontSize: 12, color: Colors.grey)),
              children: chapters.map((chap) {
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  leading: Icon(leadingIcon, size: 20, color: themeColor),
                  title: Text(chap, style: const TextStyle(fontSize: 14)),
                  trailing: Chip(
                    label: Text(
                      badgeText,
                      style: TextStyle(fontSize: 11, color: themeColor),
                    ),
                    backgroundColor: themeColor.withValues(alpha: 0.1),
                  ),
                  onTap: () {
                    if (mode == 'mcq') {
                      _openQuizSetsSheet(context, sub['name'], chap);
                    } else if (mode == 'practice') {
                      _openPracticePdfsSheet(context, sub['name'], chap);
                    } else {
                      _openNotesSheet(context, sub['name'], chap);
                    }
                  },
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}