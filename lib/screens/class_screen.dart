import 'package:flutter/material.dart';
import 'dashboard_screen.dart';

class ClassScreen extends StatelessWidget {
  final String userName;
  final bool isChangingClass;

  const ClassScreen({
    super.key,
    required this.userName,
    this.isChangingClass = false,
  });

  final List<String> classes = const [
    'Class 8th',
    'Class 9th ',
    'Class 10th ',
    'Board Special',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Your Goal', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hi, $userName 👋', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            const Text('Which class or exam are you preparing for?', style: TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: classes.length,
                itemBuilder: (context, i) {
                  final item = classes[i];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 1.5,
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.deepPurple,
                        child: Icon(Icons.school, color: Colors.white, size: 20),
                      ),
                      title: Text(item, style: const TextStyle(fontWeight: FontWeight.bold)),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        if (isChangingClass) {
                          // अगर प्रोफाइल से बदलने आए हैं तो सिर्फ नाम लौटाकर बैक होंगे
                          Navigator.pop(context, item);
                        } else {
                          // पहली बार आए हैं तो डैशबोर्ड पर ले जाएंगे
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DashboardScreen(
                                userName: userName,
                                selectedClass: item,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}