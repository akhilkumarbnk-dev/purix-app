import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/sheet_service.dart';
import 'quiz_screen.dart';

class SubjectScreen extends StatefulWidget {
  final String selectedClass;
  final String mode; // 'mcq', 'practice', या 'notes'

  const SubjectScreen({
    super.key,
    required this.selectedClass,
    required this.mode,
  });

  @override
  State<SubjectScreen> createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  bool _isLoading = true;
  String _userSubscription = 'FREE';

  Map<String, List<Map<String, dynamic>>> _groupedData = {};

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  String _getTargetSheetName() {
    // क्लास नाम को साफ करके "8th", "9th", "10th" में बदलना
    String prefix = "8th";
    if (widget.selectedClass.contains("9")) {
      prefix = "9th";
    } else if (widget.selectedClass.contains("10")) {
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

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    _userSubscription = prefs.getString('user_sub') ?? 'FREE';

    final targetSheet = _getTargetSheetName();
    final data = await SheetService.fetchSheetData(targetSheet);

    // Subject के आधार पर डेटा ग्रुप करना
    final Map<String, List<Map<String, dynamic>>> grouped = {};
    for (var row in data) {
      final subject = (row['Subject'] ?? row['subject'] ?? 'General').toString().trim();
      if (subject.isNotEmpty) {
        if (!grouped.containsKey(subject)) {
          grouped[subject] = [];
        }
        grouped[subject]!.add(row);
      }
    }

    if (mounted) {
      setState(() {
        
        _groupedData = grouped;
        _isLoading = false;
      });
    }
  }

  void _openPdfLink(String url) async {
    if (url.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Resource link not available.")),
      );
      return;
    }

    final uri = Uri.parse(url.trim());
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Unable to open resource link.")),
        );
      }
    }
  }

  void _showLockAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0B111E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: Color(0xFFFFD700), width: 1.2),
        ),
        title: const Row(
          children: [
            Icon(Icons.lock, color: Color(0xFFFFD700), size: 22),
            SizedBox(width: 8),
            Text(
              "PRO MODULE LOCKED",
              style: TextStyle(color: Color(0xFFFFD700), fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: const Text(
          "This study asset is part of the Purix Pro Pass. Upgrade your account or contact support on WhatsApp to unlock complete access.",
          style: TextStyle(color: Colors.white70, fontSize: 12),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("CLOSE", style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFD700),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // डैशबोर्ड पर वापस जाकर अपग्रेड कर सकते हैं
            },
            child: const Text("VIEW PRO PASS", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const darkVoid = Color(0xFF070B14);
    const cardBg = Color(0xFF0B111E);
    const neonCyan = Color(0xFF00F0FF);
    const neonGreen = Color(0xFF00FF66);
    const neonGold = Color(0xFFFFD700);

    String titleText = "${widget.selectedClass} - Modules";
    Color themeGlow = neonGreen;

    if (widget.mode == 'mcq') {
      titleText = "${widget.selectedClass} - MCQ Tests";
      themeGlow = const Color(0xFF00FF66);
    } else if (widget.mode == 'practice') {
      titleText = "${widget.selectedClass} - Practice Sets";
      themeGlow = const Color(0xFFFF9900);
    } else {
      titleText = "${widget.selectedClass} - Purix Notes";
      themeGlow = const Color(0xFFBF00FF);
    }

    return Scaffold(
      backgroundColor: darkVoid,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0F1D),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          titleText.toUpperCase(),
          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: neonCyan),
            onPressed: _loadInitialData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: neonCyan),
                  SizedBox(height: 16),
                  Text("FETCHING CURRICULUM NODE...", style: TextStyle(color: neonCyan, fontFamily: 'monospace', fontSize: 12)),
                ],
              ),
            )
          : _groupedData.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.layers_clear_outlined, color: Colors.white.withValues(alpha: 0.3), size: 48),
                        const SizedBox(height: 12),
                        const Text(
                          "NO DATA LOADED YET",
                          style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1.2),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Ensure records exist in sheet: ${_getTargetSheetName()}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white38, fontSize: 11, fontFamily: 'monospace'),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF101726)),
                          onPressed: _loadInitialData,
                          icon: const Icon(Icons.refresh, size: 16, color: neonCyan),
                          label: const Text("RETRY CONNECTION", style: TextStyle(color: neonCyan, fontSize: 12)),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  itemCount: _groupedData.keys.length,
                  itemBuilder: (context, index) {
                    final subject = _groupedData.keys.elementAt(index);
                    final items = _groupedData[subject]!;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: themeGlow.withValues(alpha: 0.3), width: 1.2),
                      ),
                      child: Theme(
                        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          leading: CircleAvatar(
                            backgroundColor: themeGlow.withValues(alpha: 0.12),
                            child: Icon(
                              widget.mode == 'mcq'
                                  ? Icons.quiz
                                  : widget.mode == 'notes'
                                      ? Icons.menu_book
                                      : Icons.hub,
                              color: themeGlow,
                              size: 20,
                            ),
                          ),
                          title: Text(
                            subject.toUpperCase(),
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1.1),
                          ),
                          subtitle: Text(
                            "${items.length} MODULES READY",
                            style: TextStyle(color: themeGlow.withValues(alpha: 0.7), fontSize: 10, fontFamily: 'monospace'),
                          ),
                          children: items.map((item) {
                            final accessType = (item['Access_Type'] ?? item['access_type'] ?? 'FREE').toString().toUpperCase().trim();
                            final isItemFree = accessType == 'FREE';
                            final hasAccess = isItemFree || _userSubscription == 'PRO';

                            final chapterName = item['Chapter'] ?? item['chapter'] ?? 'Chapter';
                            final titleHin = item['Title-hin'] ?? item['Title_hin'] ?? item['Set Name-hin'] ?? item['MCQ hin'] ?? '';
                            final titleEng = item['Title-eng'] ?? item['Title_eng'] ?? item['Set-name-eng'] ?? item['MCQ eng'] ?? '';

                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF101726),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.white12),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          chapterName,
                                          style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                                        ),
                                        if (titleEng.isNotEmpty || titleHin.isNotEmpty) ...[
                                          const SizedBox(height: 3),
                                          Text(
                                            titleEng.isNotEmpty ? titleEng : titleHin,
                                            style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 11),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: isItemFree ? neonGreen.withValues(alpha: 0.15) : neonGold.withValues(alpha: 0.15),
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                isItemFree ? "FREE" : "PRO ONLY",
                                                style: TextStyle(
                                                  color: isItemFree ? neonGreen : neonGold,
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'monospace',
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (!hasAccess)
                                    IconButton(
                                      icon: const Icon(Icons.lock, color: neonGold, size: 20),
                                      onPressed: _showLockAlert,
                                    )
                                  else if (widget.mode == 'mcq')
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: neonGreen,
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => QuizScreen(
                                              selectedClass: widget.selectedClass,
                                              subject: subject,
                                              chapter: chapterName,
                                              quizSetNumber: 1,
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text("START", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 11)),
                                    )
                                  else ...[
                                    // Notes & Practice Links
                                    IconButton(
                                      tooltip: "Open Resource",
                                      icon: Icon(
                                        widget.mode == 'notes' ? Icons.menu_book : Icons.picture_as_pdf,
                                        color: neonCyan,
                                        size: 22,
                                      ),
                                      onPressed: () {
                                        final link = (item['Drive-link-eng'] ??
                                                item['Drive_link_eng'] ??
                                                item['Drive-link-hin'] ??
                                                item['Drive_link_hin'] ??
                                                item['Question-pdf-link'] ??
                                                item['Question_pdf_link'] ??
                                                '')
                                            .toString();
                                        _openPdfLink(link);
                                      },
                                    ),
                                  ],
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}