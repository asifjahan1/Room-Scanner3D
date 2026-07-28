import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/routes/app_routes.dart';
import '../../theme/perfekt_theme.dart';

/// Represents a daily scheduled shift in PerfektWerk OS.
class ScheduleAssignment {
  final String dayName;
  final String dayNumber;
  final String fullDateString;
  final String title;
  final String location;
  final String startTime;
  final String endTime;
  final String status;
  final String relativeLabel; // e.g. "TODAY", "TOMORROW", "THURSDAY"

  const ScheduleAssignment({
    required this.dayName,
    required this.dayNumber,
    required this.fullDateString,
    required this.title,
    required this.location,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.relativeLabel,
  });
}

class MyScheduleScreen extends StatefulWidget {
  const MyScheduleScreen({super.key});

  @override
  State<MyScheduleScreen> createState() => _MyScheduleScreenState();
}

class _MyScheduleScreenState extends State<MyScheduleScreen> {
  int selectedDayIndex = 1; // Default selected to TUE 12 (matching design)

  final List<ScheduleAssignment> weeklySchedule = const [
    ScheduleAssignment(
      dayName: "MON",
      dayNumber: "11",
      fullDateString: "Monday, Sep 11",
      title: "Berlin Central Terminal - Phase 1",
      location: "Alexanderplatz 4, Berlin",
      startTime: "07:30",
      endTime: "16:00",
      status: "COMPLETED",
      relativeLabel: "YESTERDAY",
    ),
    ScheduleAssignment(
      dayName: "TUE",
      dayNumber: "12",
      fullDateString: "Tuesday, Sep 12",
      title: "Skyline Apartments – Phase 2",
      location: "Kurfürstendamm 21, Berlin",
      startTime: "08:00",
      endTime: "17:00",
      status: "CONFIRMED",
      relativeLabel: "TODAY",
    ),
    ScheduleAssignment(
      dayName: "WED",
      dayNumber: "13",
      fullDateString: "Wednesday, Sep 13",
      title: "Skyline Apartments – Phase 2",
      location: "Kurfürstendamm 21, Berlin",
      startTime: "08:00",
      endTime: "17:00",
      status: "CONFIRMED",
      relativeLabel: "TOMORROW",
    ),
    ScheduleAssignment(
      dayName: "THU",
      dayNumber: "14",
      fullDateString: "Thursday, Sep 14",
      title: "Main Street Renovation",
      location: "Friedrichstraße 102, Berlin",
      startTime: "09:00",
      endTime: "18:00",
      status: "SCHEDULED",
      relativeLabel: "THURSDAY",
    ),
    ScheduleAssignment(
      dayName: "FRI",
      dayNumber: "15",
      fullDateString: "Friday, Sep 15",
      title: "Bavarian Towers Inspection",
      location: "Münchner Allee 18, Munich",
      startTime: "08:30",
      endTime: "15:30",
      status: "TENTATIVE",
      relativeLabel: "FRIDAY",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final currentAssignment = weeklySchedule[selectedDayIndex];
    final upcomingShifts = weeklySchedule
        .where((s) => weeklySchedule.indexOf(s) > selectedDayIndex)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 8.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    Text(
                      "My Schedule",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: PerfektTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildWeeklyDateSelector(),
                    const SizedBox(height: 32),
                    _buildSelectedAssignmentSection(currentAssignment),
                    const SizedBox(height: 32),
                    if (upcomingShifts.isNotEmpty) ...[
                      Text(
                        "UPCOMING SHIFTS",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: PerfektTheme.textLight,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...upcomingShifts.map(
                        (shift) => _buildUpcomingShiftCard(shift),
                      ),
                    ] else ...[
                      _buildNoMoreShiftsCard(),
                    ],
                    const SizedBox(height: 24),
                    _buildQuickActionFooter(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Header row with Back Arrow and centered "MY SCHEDULE" title
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => Get.back(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.arrow_back,
                    color: PerfektTheme.primaryBlue,
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "MY SCHEDULE",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: PerfektTheme.primaryBlue,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => Get.toNamed(AppRoutes.myCalendar),
            icon: const Icon(
              Icons.calendar_month_outlined,
              color: PerfektTheme.textMedium,
            ),
            tooltip: "Full Calendar View",
          ),
        ],
      ),
    );
  }

  /// Weekly Date Selector with dynamic tap selection
  Widget _buildWeeklyDateSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(weeklySchedule.length, (index) {
        final item = weeklySchedule[index];
        final isSelected = (index == selectedDayIndex);

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedDayIndex = index;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            width: 62,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: isSelected ? PerfektTheme.primaryBlue : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: PerfektTheme.primaryBlue.withValues(alpha: 0.35),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: const Color(0xFF0F172A).withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.dayName,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    color: isSelected
                        ? Colors.white.withValues(alpha: 0.9)
                        : PerfektTheme.textMedium,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item.dayNumber,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: isSelected ? Colors.white : PerfektTheme.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                // Tiny dot underneath the selected day
                Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? Colors.white : Colors.transparent,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  /// Displays today's or the currently selected day's assignment card
  Widget _buildSelectedAssignmentSection(ScheduleAssignment assignment) {
    String headerTitle = "SELECTED ASSIGNMENT";
    if (assignment.relativeLabel == "TODAY") {
      headerTitle = "TODAY'S ASSIGNMENT";
    } else if (assignment.relativeLabel == "TOMORROW") {
      headerTitle = "TOMORROW'S ASSIGNMENT";
    } else if (assignment.relativeLabel == "YESTERDAY") {
      headerTitle = "YESTERDAY'S ASSIGNMENT";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              headerTitle,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: PerfektTheme.primaryBlue,
                letterSpacing: 0.8,
              ),
            ),
            Text(
              assignment.fullDateString,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: PerfektTheme.textMedium,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        InkWell(
          onTap: () => Get.toNamed(AppRoutes.jobDetails),
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0F172A).withValues(alpha: 0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        assignment.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: PerfektTheme.textDark,
                          height: 1.3,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(
                          assignment.status,
                        ).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        assignment.status,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: _getStatusColor(assignment.status),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 18,
                      color: PerfektTheme.textMedium,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        assignment.location,
                        style: const TextStyle(
                          fontSize: 14,
                          color: PerfektTheme.textMedium,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: _buildTimeBox(
                        label: "SHIFT START",
                        time: assignment.startTime,
                        icon: Icons.access_time_filled_rounded,
                        iconColor: PerfektTheme.primaryBlue,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _buildTimeBox(
                        label: "SHIFT END",
                        time: assignment.endTime,
                        icon: Icons.output_rounded,
                        iconColor: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Divider(color: Colors.grey.withValues(alpha: 0.15)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.assignment_turned_in_outlined,
                          size: 16,
                          color: PerfektTheme.primaryBlue,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "View Architectural Tasks & LiDAR Scan",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: PerfektTheme.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: PerfektTheme.primaryBlue,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeBox({
    required String label,
    required String time,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F6FA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Color(0xFF64748B),
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(icon, size: 20, color: iconColor),
              const SizedBox(width: 8),
              Text(
                time,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: PerfektTheme.textDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds individual cards for Upcoming Shifts with colored vertical indicator on left edge
  Widget _buildUpcomingShiftCard(ScheduleAssignment shift) {
    final isTomorrow = (shift.relativeLabel == "TOMORROW");
    final accentColor = isTomorrow
        ? PerfektTheme.primaryBlue
        : const Color(0xFF94A3B8);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: InkWell(
        onTap: () => Get.toNamed(AppRoutes.jobDetails),
        borderRadius: BorderRadius.circular(18),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F172A).withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                // Left vertical bar
                Container(
                  width: 5,
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(18),
                      bottomLeft: Radius.circular(18),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          shift.relativeLabel,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: accentColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              shift.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: PerfektTheme.textDark,
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right_rounded,
                              color: Color(0xFF94A3B8),
                              size: 22,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_outlined,
                              size: 14,
                              color: PerfektTheme.textMedium,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "Sep ${shift.dayNumber}",
                              style: const TextStyle(
                                fontSize: 13,
                                color: PerfektTheme.textMedium,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Icon(
                              Icons.access_time_rounded,
                              size: 14,
                              color: PerfektTheme.textMedium,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "${shift.startTime} – ${shift.endTime}",
                              style: const TextStyle(
                                fontSize: 13,
                                color: PerfektTheme.textMedium,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNoMoreShiftsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: PerfektTheme.borderLight),
      ),
      child: Column(
        children: [
          Icon(
            Icons.task_alt_rounded,
            size: 36,
            color: PerfektTheme.primaryBlue.withValues(alpha: 0.7),
          ),
          const SizedBox(height: 12),
          const Text(
            "End of Weekly Roster",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: PerfektTheme.textDark,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "You have viewed all scheduled shifts for this week.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: PerfektTheme.textMedium),
          ),
        ],
      ),
    );
  }

  /// Quick link connecting the schedule to active execution and time tracking
  Widget _buildQuickActionFooter() {
    return InkWell(
      onTap: () => Get.toNamed(AppRoutes.myDayTimeline),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF155DFC), Color(0xFF0C4BCE)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: PerfektTheme.primaryBlue.withValues(alpha: 0.3),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.timer_outlined,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Launch Shift Execution",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "Switch to live time tracking & offline work mode",
                    style: TextStyle(fontSize: 12, color: Color(0xFFD3E4FF)),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_rounded, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case "CONFIRMED":
        return PerfektTheme.primaryBlue;
      case "COMPLETED":
        return const Color(0xFF16A34A); // Green
      case "SCHEDULED":
        return const Color(0xFFF97316); // Orange
      default:
        return PerfektTheme.textMedium;
    }
  }
}
