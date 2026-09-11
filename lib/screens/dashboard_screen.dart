import 'package:flutter/material.dart';
import 'class_screen.dart';
import 'subject_screen.dart';
import 'free_content_screen.dart';

class DashboardScreen extends StatefulWidget {
  final String userName;
  final String selectedClass;

  const DashboardScreen({
    super.key,
    required this.userName,
    required this.selectedClass,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late String currentClass;

  @override
  void initState() {
    super.initState();
    currentClass = widget.selectedClass;
  }

  void _changeClass() async {
    final newClass = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => ClassScreen(
          userName: widget.userName,
          isChangingClass: true,
        ),
      ),
    );

    if (newClass != null && mounted) {
      setState(() {
        currentClass = newClass;
      });
    }
  }

  void _openProfileSheet() {
    const neonCyan = Color(0xFF00F0FF);
    const neonGreen = Color(0xFF00FF66);

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0B111E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        side: BorderSide(color: neonCyan, width: 1.2),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 36,
                backgroundColor: neonCyan.withValues(alpha: 0.15),
                child: Text(
                  widget.userName.isNotEmpty ? widget.userName[0].toUpperCase() : 'U',
                  style: const TextStyle(fontSize: 28, color: neonCyan, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                widget.userName.toUpperCase(),
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.2),
              ),
              const SizedBox(height: 4),
              Text(
                'ACTIVE NODE: $currentClass',
                style: const TextStyle(color: neonGreen, fontSize: 12, fontFamily: 'monospace'),
              ),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF101726),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white12),
                ),
                child: ListTile(
                  leading: const Icon(Icons.swap_horiz, color: neonCyan),
                  title: const Text('Switch Target Class', style: TextStyle(color: Colors.white, fontSize: 14)),
                  subtitle: const Text('Change syllabus & questions node', style: TextStyle(color: Colors.white54, fontSize: 11)),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white38, size: 14),
                  onTap: () {
                    Navigator.pop(context);
                    _changeClass();
                  },
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const neonCyan = Color(0xFF00F0FF);
    const neonGreen = Color(0xFF00FF66);
    const darkVoid = Color(0xFF070B14);

    return Scaffold(
      backgroundColor: darkVoid,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0F1D),
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: neonGreen,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: neonGreen, blurRadius: 6)],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  widget.userName.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 14,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              currentClass.toUpperCase(),
              style: TextStyle(
                fontSize: 11,
                fontFamily: 'monospace',
                letterSpacing: 1.2,
                color: neonCyan.withValues(alpha: 0.9),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: _openProfileSheet,
              child: CircleAvatar(
                radius: 18,
                backgroundColor: neonCyan.withValues(alpha: 0.15),
                child: Text(
                  widget.userName.isNotEmpty ? widget.userName[0].toUpperCase() : 'U',
                  style: const TextStyle(color: neonCyan, fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWideScreen = constraints.maxWidth > 750;
          final crossAxisCount = isWideScreen ? 4 : 2;
          final aspectRatio = isWideScreen ? 1.05 : 0.92;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // अपडेटेड Purix Academy बैनर
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D1424),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: neonCyan.withValues(alpha: 0.35), width: 1.2),
                    boxShadow: [
                      BoxShadow(
                        color: neonCyan.withValues(alpha: 0.08),
                        blurRadius: 15,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'PURIX ACADEMY',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'NEW WAY OF LEARNING',
                            style: TextStyle(
                              color: neonCyan.withValues(alpha: 0.85),
                              fontSize: 11,
                              letterSpacing: 1.5,
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: neonGreen.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: neonGreen.withValues(alpha: 0.4)),
                        ),
                        child: const Text(
                          'TARGET: 95%+',
                          style: TextStyle(
                            color: neonGreen,
                            fontSize: 11,
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'CORE MODULES',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.8,
                        fontFamily: 'monospace',
                      ),
                    ),
                    Text(
                      isWideScreen ? '// DESKTOP MATRIX [1x4]' : '// MOBILE ARRAY [2x2]',
                      style: TextStyle(
                        color: neonCyan.withValues(alpha: 0.6),
                        fontSize: 10,
                        letterSpacing: 1.2,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: aspectRatio,
                  children: [
                    _sciFiModuleCard(
                      code: 'SEC.01',
                      title: 'MCQ TEST',
                      desc: 'Timed Simulation',
                      glowColor: const Color(0xFF00FF66),
                      icon: Icons.flash_on_rounded,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SubjectScreen(
                              selectedClass: currentClass,
                              mode: 'mcq',
                            ),
                          ),
                        );
                      },
                    ),
                    _sciFiModuleCard(
                      code: 'SEC.02',
                      title: 'PRACTICE SETS',
                      desc: 'Question Bank',
                      glowColor: const Color(0xFFFF9900),
                      icon: Icons.hub_rounded,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SubjectScreen(
                              selectedClass: currentClass,
                              mode: 'practice',
                            ),
                          ),
                        );
                      },
                    ),
                    _sciFiModuleCard(
                      code: 'SEC.03',
                      title: 'PURIX NOTES',
                      desc: 'Core Theory Data',
                      glowColor: const Color(0xFFBF00FF),
                      icon: Icons.memory_rounded,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SubjectScreen(
                              selectedClass: currentClass,
                              mode: 'notes',
                            ),
                          ),
                        );
                      },
                    ),
                    _sciFiModuleCard(
                      code: 'SEC.04',
                      title: 'FREE MATRIX',
                      desc: 'PYQs & Blueprint',
                      glowColor: const Color(0xFF00F0FF),
                      icon: Icons.radar_rounded,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FreeContentScreen(
                              selectedClass: currentClass,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _sciFiModuleCard({
    required String code,
    required String title,
    required String desc,
    required Color glowColor,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0B111E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: glowColor.withValues(alpha: 0.4), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: glowColor.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: glowColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: glowColor.withValues(alpha: 0.3), width: 0.8),
                  ),
                  child: Text(
                    code,
                    style: TextStyle(
                      color: glowColor,
                      fontSize: 9,
                      letterSpacing: 1.2,
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: glowColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                    border: Border.all(color: glowColor.withValues(alpha: 0.4), width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: glowColor.withValues(alpha: 0.2),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Icon(icon, color: glowColor, size: 30),
                ),
                const SizedBox(height: 14),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  desc,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.55),
                    fontSize: 10,
                    fontFamily: 'monospace',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}