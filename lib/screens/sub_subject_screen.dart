import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/sheet_service.dart';
import 'quiz_screen.dart';

class SubSubjectScreen extends StatefulWidget {
  final String className;
  final String subjectName;
  final String mode; // 'mcq', 'notes', या 'practice'

  const SubSubjectScreen({
    super.key,
    required this.className,
    required this.subjectName,
    required this.mode,
  });

  @override
  State<SubSubjectScreen> createState() => _SubSubjectScreenState();
}

class _SubSubjectScreenState extends State<SubSubjectScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _subSubjects = [];
  bool _isHindiLanguage = false;

  @override
  void initState() {
    super.initState();
    _loadSubSubjects();
  }

  String _getTargetSheetName() {
    String prefix = "8th";
    if (widget.className.contains("9")) {
      prefix = "9th";
    } else if (widget.className.contains("10")) {
      prefix = "10th";
    }

    if (widget.mode == 'mcq') {
      return '$prefix MCQ';
    } else if (widget.mode == 'notes') {
      return '$prefix Notes';
    } else {
      return '$prefix practice pdf';
    }
  }

  Future<void> _loadSubSubjects() async {
    setState(() => _isLoading = true);
    final targetSheet = _getTargetSheetName();
    final data = await SheetService.fetchSheetData(targetSheet);

    // सिर्फ उसी सब्जेक्ट के डेटा को फिल्टर करें जो यूजर ने चुना है
    final filtered = data.where((item) {
      final sub = (item['Subject'] ?? item['subject'] ?? '').toString().trim();
      return sub.toLowerCase() == widget.subjectName.toLowerCase();
    }).toList();

    if (!mounted) return;
    setState(() {
      _subSubjects = filtered;
      _isLoading = false;
    });
  }

  void _openPdfLink(String url) async {
    if (url.trim().isEmpty || url.trim() == 'N/A') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Resource link not available.")),
      );
      return;
    }

    String finalUrl = url.trim();
    if (finalUrl.contains('drive.google.com') && finalUrl.contains('/view')) {
      finalUrl = finalUrl.replaceAll('/view?usp=sharing', '/preview').replaceAll('/view', '/preview');
    }

    final uri = Uri.parse(finalUrl);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Unable to open resource link.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error opening resource link.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const darkVoid = Color(0xFF070B14);
    const cardBg = Color(0xFF0B111E);
    const neonCyan = Color(0xFF00F0FF);
    const neonGreen = Color(0xFF00FF66);

    return Scaffold(
      backgroundColor: darkVoid,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0F1D),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "${widget.subjectName.toUpperCase()} - TOPICS",
          style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1.1),
        ),
        actions: [
          InkWell(
            onTap: () => setState(() => _isHindiLanguage = !_isHindiLanguage),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                color: neonCyan.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: neonCyan),
              ),
              child: Text(
                _isHindiLanguage ? "HIN" : "ENG",
                style: const TextStyle(color: neonCyan, fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: neonCyan))
          : _subSubjects.isEmpty
              ? const Center(
                  child: Text(
                    "No Sub-Subjects found for this category!",
                    style: TextStyle(color: Colors.white54, fontSize: 13),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _subSubjects.length,
                  itemBuilder: (context, index) {
                    final item = _subSubjects[index];
                    final chapterName = item['Chapter'] ?? item['chapter'] ?? 'Topic ${index + 1}';
                    
                    final pdfLinkHin = item['Drive-link-hin'] ?? item['Drive_link_hin'] ?? '';
                    final pdfLinkEng = item['Drive-link-eng'] ?? item['Drive_link_eng'] ?? '';
                    final selectedPdfLink = _isHindiLanguage ? (pdfLinkHin.isNotEmpty ? pdfLinkHin : pdfLinkEng) : (pdfLinkEng.isNotEmpty ? pdfLinkEng : pdfLinkHin);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: neonCyan.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              chapterName,
                              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                          ),
                          const SizedBox(width: 12),
                          if (widget.mode == 'mcq')
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: neonGreen),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => QuizScreen(
                                      selectedClass: widget.className,
                                      subject: widget.subjectName,
                                      chapter: chapterName,
                                      quizSetNumber: 1,
                                    ),
                                  ),
                                );
                              },
                              child: const Text("START", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 11)),
                            )
                          else
                            IconButton(
                              icon: Icon(
                                widget.mode == 'notes' ? Icons.menu_book : Icons.picture_as_pdf,
                                color: neonCyan,
                                size: 24,
                              ),
                              onPressed: () => _openPdfLink(selectedPdfLink),
                            ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}