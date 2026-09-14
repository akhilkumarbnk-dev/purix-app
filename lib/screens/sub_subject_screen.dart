import 'package:flutter/material.dart';
import '../services/sheet_service.dart';

class SubSubjectScreen extends StatefulWidget {
  final String className;
  final String subjectName;

  const SubSubjectScreen({super.key, required this.className, required this.subjectName});

  @override
  State<SubSubjectScreen> createState() => _SubSubjectScreenState();
}

class _SubSubjectScreenState extends State<SubSubjectScreen> {
  List<String> _subSubjects = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSubSubjects();
  }

  Future<void> _fetchSubSubjects() async {
    try {
      // सही स्टैटिक मेथड का इस्तेमाल किया गया है
      final data = await SheetService.fetchSheetData(widget.className);
      
      final filtered = data.where((item) {
        final subj = (item['Subject'] ?? item['subject'] ?? '').toString().trim();
        return subj.toLowerCase() == widget.subjectName.toLowerCase();
      }).toList();

      Set<String> subSet = {};
      for (var item in filtered) {
        final subSub = (item['Sub-subject'] ?? item['sub-subject'] ?? '').toString().trim();
        if (subSub.isNotEmpty) {
          subSet.add(subSub);
        }
      }

      setState(() {
        _subSubjects = subSet.toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.subjectName} - ${widget.className}'),
        backgroundColor: Colors.deepPurple,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _subSubjects.isEmpty
              ? const Center(child: Text("No Sub-subjects found!", style: TextStyle(color: Colors.white)))
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _subSubjects.length,
                  itemBuilder: (context, index) {
                    final subSubject = _subSubjects[index];
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      // यहाँ BorderRadius.circular को ठीक कर दिया गया है
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.deepPurple,
                          child: Icon(Icons.book, color: Colors.white),
                        ),
                        title: Text(
                          subSubject.toUpperCase(),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {},
                      ),
                    );
                  },
                ),
    );
  }
}