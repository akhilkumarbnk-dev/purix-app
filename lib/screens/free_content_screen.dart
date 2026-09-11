import 'package:flutter/material.dart';

class FreeContentScreen extends StatelessWidget {
  final String selectedClass;

  const FreeContentScreen({super.key, required this.selectedClass});

  // डेमो बोर्ड फ्री मटीरियल (बाद में Google Sheet से लिंक होगा)
  final List<Map<String, dynamic>> freeCategories = const [
    {
      'title': 'Board Previous Year Papers (PYQs)',
      'subtitle': 'Last 5 years solved papers with marking scheme',
      'icon': Icons.history_edu,
      'color': Colors.redAccent,
      'items': [
        {'name': 'Science Solved Board Paper (2024)', 'pages': '18 Pages'},
        {'name': 'Mathematics Solved Board Paper (2024)', 'pages': '22 Pages'},
        {'name': 'Social Science Solved Board Paper (2023)', 'pages': '20 Pages'},
      ],
    },
    {
      'title': 'Syllabus & Exam Blueprint',
      'subtitle': 'Chapter-wise marks distribution & deleted topics',
      'icon': Icons.assignment_turned_in,
      'color': Colors.blue,
      'items': [
        {'name': 'Complete Board Science Blueprint', 'pages': '6 Pages'},
        {'name': 'Mathematics Unit-wise Marks Scheme', 'pages': '5 Pages'},
      ],
    },
    {
      'title': 'Formula Sheets & Quick Maps',
      'subtitle': 'Key definitions, formulas and reaction charts',
      'icon': Icons.menu_book,
      'color': Colors.amber,
      'items': [
        {'name': 'All Chemical Reactions & Formula Sheet', 'pages': '8 Pages'},
        {'name': 'Maths Important Theorems & Identities', 'pages': '10 Pages'},
      ],
    },
    {
      'title': 'Model / Sample Guess Papers',
      'subtitle': 'Purix special practice sets based on new board pattern',
      'icon': Icons.description,
      'color': Colors.green,
      'items': [
        {'name': 'Science Sample Paper 1 (Solved)', 'pages': '14 Pages'},
        {'name': 'Maths Standard Sample Paper 1 (Solved)', 'pages': '16 Pages'},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$selectedClass - Free Content', style: const TextStyle(color: Colors.white, fontSize: 17)),
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: freeCategories.length,
        itemBuilder: (context, catIndex) {
          final category = freeCategories[catIndex];
          final items = category['items'] as List<Map<String, String>>;

          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ExpansionTile(
              leading: CircleAvatar(
                backgroundColor: (category['color'] as Color).withValues(alpha: 0.15),
                child: Icon(category['icon'] as IconData, color: category['color'] as Color),
              ),
              title: Text(
                category['title'] as String,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              subtitle: Text(
                category['subtitle'] as String,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              children: items.map((doc) {
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  leading: const Icon(Icons.picture_as_pdf, size: 22, color: Colors.redAccent),
                  title: Text(doc['name']!, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                  subtitle: Text(doc['pages']!, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Opening PDF: ${doc['name']}')),
                      );
                    },
                    child: const Text('View PDF', style: TextStyle(fontSize: 11)),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}