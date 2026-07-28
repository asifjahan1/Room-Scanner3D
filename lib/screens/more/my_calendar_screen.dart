import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/perfekt_theme.dart';

enum EventType { workDay, meeting, training, leave }

class CalendarEvent {
  final String title;
  final String subtitle;
  final String time;
  final EventType type;
  final String location;

  CalendarEvent({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.type,
    required this.location,
  });
}

class CalendarController extends GetxController {
  final Rx<DateTime> currentMonthDate = DateTime.now().obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;

  // Get month name string dynamically
  String get currentMonthName {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    final monthIndex = currentMonthDate.value.month - 1;
    return "${months[monthIndex]} ${currentMonthDate.value.year}";
  }

  void nextMonth() {
    final current = currentMonthDate.value;
    currentMonthDate.value = DateTime(current.year, current.month + 1, 1);
  }

  void previousMonth() {
    final current = currentMonthDate.value;
    currentMonthDate.value = DateTime(current.year, current.month - 1, 1);
  }

  void selectDay(int day) {
    selectedDate.value = DateTime(
      currentMonthDate.value.year,
      currentMonthDate.value.month,
      day,
    );
  }

  // Determine event type based on date logic to ensure rich dynamic display
  EventType? getEventTypeForDay(int day) {
    if (day % 7 == 0 || day == 2 || day == 14 || day == 21) {
      return EventType.workDay;
    } else if (day == 5 || day == 12 || day == 19 || day == 25) {
      return EventType.meeting;
    } else if (day == 9 || day == 18 || day == 26) {
      return EventType.training;
    } else if (day == 15 || day == 29) {
      return EventType.leave;
    }
    return null;
  }

  Color getEventColor(EventType? type) {
    switch (type) {
      case EventType.workDay:
        return PerfektTheme.primaryBlue; // #155DFC
      case EventType.meeting:
        return const Color(0xFF10B981); // Emerald Green
      case EventType.training:
        return const Color(0xFFD97706); // Amber Orange
      case EventType.leave:
        return const Color(0xFFDC2626); // Alert Red
      default:
        return Colors.transparent;
    }
  }

  String getEventTypeName(EventType type) {
    switch (type) {
      case EventType.workDay:
        return "Work Day";
      case EventType.meeting:
        return "Meeting";
      case EventType.training:
        return "Training";
      case EventType.leave:
        return "Leave";
    }
  }

  List<CalendarEvent> getEventsForSelectedDate() {
    final day = selectedDate.value.day;
    final type = getEventTypeForDay(day);

    if (type == EventType.workDay || (day % 2 == 0 && type == null)) {
      return [
        CalendarEvent(
          title: "Site Inspection & LiDAR Verification",
          subtitle: "Verify structural dimensions with original visual scanner.",
          time: "08:30 AM – 12:00 PM",
          type: EventType.workDay,
          location: "Skyline Phase 2 – Zone A",
        ),
        CalendarEvent(
          title: "Foundation Structural Review",
          subtitle: "Audit U-Value thermal insulation & condensation logs.",
          time: "02:00 PM – 04:30 PM",
          type: EventType.workDay,
          location: "Sector C – Basement",
        ),
      ];
    } else if (type == EventType.meeting) {
      return [
        CalendarEvent(
          title: "SteinMetz Engineering Syndicate",
          subtitle: "Foreman coordination & R&D Monocular Depth roadmap.",
          time: "10:00 AM – 11:30 AM",
          type: EventType.meeting,
          location: "Central HQ & Live Video Stream",
        ),
      ];
    } else if (type == EventType.training) {
      return [
        CalendarEvent(
          title: "ISO 27001 & Vault-Shield Workshop",
          subtitle: "Mandatory site safety protocol & offline data sync certification.",
          time: "09:00 AM – 03:00 PM",
          type: EventType.training,
          location: "Regional Training Academy",
        ),
      ];
    } else if (type == EventType.leave) {
      return [
        CalendarEvent(
          title: "Personal Approved Leave",
          subtitle: "Leave balance updated in SteinMetz Human Capital OS.",
          time: "All Day",
          type: EventType.leave,
          location: "Offsite",
        ),
      ];
    } else {
      return [
        CalendarEvent(
          title: "Standard On-Call Shift",
          subtitle: "Standby for equipment diagnostics or material requisitions.",
          time: "08:00 AM – 05:00 PM",
          type: EventType.workDay,
          location: "Mobile Support Units",
        ),
      ];
    }
  }
}

class MyCalendarScreen extends StatelessWidget {
  const MyCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CalendarController());
    final now = DateTime.now();

    return Theme(
      data: ThemeData.light().copyWith(
        scaffoldBackgroundColor: PerfektTheme.backgroundLight,
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: PerfektTheme.primaryBlue, size: 20),
            onPressed: () => Get.back(),
          ),
          title: Text(
            'MY CALENDER',
            style: PerfektTheme.fontBold(17, color: PerfektTheme.primaryBlue).copyWith(
              letterSpacing: 1.0,
            ),
          ),
          centerTitle: false,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Main Calendar Card
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: PerfektTheme.radiusCard,
                    border: Border.all(color: PerfektTheme.borderLight),
                    boxShadow: PerfektTheme.cardShadow,
                  ),
                  child: Column(
                    children: [
                      // Month Selector Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chevron_left_rounded, color: PerfektTheme.textDark, size: 28),
                            onPressed: controller.previousMonth,
                            constraints: const BoxConstraints(),
                            padding: EdgeInsets.zero,
                          ),
                          Obx(() => Text(
                            controller.currentMonthName,
                            style: PerfektTheme.fontBold(20, color: PerfektTheme.textDark),
                          )),
                          IconButton(
                            icon: const Icon(Icons.chevron_right_rounded, color: PerfektTheme.textDark, size: 28),
                            onPressed: controller.nextMonth,
                            constraints: const BoxConstraints(),
                            padding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Weekday Headers (M T W T F S S)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: ['M', 'T', 'W', 'T', 'F', 'S', 'S'].map((day) {
                          return SizedBox(
                            width: 38,
                            child: Center(
                              child: Text(
                                day,
                                style: PerfektTheme.fontBold(13, color: PerfektTheme.textLight),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 12),
                      const Divider(height: 1, color: Color(0xFFF1F5F9)),
                      const SizedBox(height: 12),

                      // Dynamic Date Grid Computation
                      Obx(() {
                        final year = controller.currentMonthDate.value.year;
                        final month = controller.currentMonthDate.value.month;
                        final daysInMonth = DateTime(year, month + 1, 0).day;
                        
                        // Monday is 1, Sunday is 7. Calculate leading empty cells
                        final firstDayWeekday = DateTime(year, month, 1).weekday;
                        final leadingEmpty = firstDayWeekday - 1;

                        final totalCells = leadingEmpty + daysInMonth;

                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 7,
                            childAspectRatio: 0.88,
                          ),
                          itemCount: totalCells,
                          itemBuilder: (context, index) {
                            if (index < leadingEmpty) {
                              return const SizedBox.shrink();
                            }
                            final dayNumber = index - leadingEmpty + 1;
                            final isSelected = controller.selectedDate.value.year == year &&
                                controller.selectedDate.value.month == month &&
                                controller.selectedDate.value.day == dayNumber;
                            final isToday = now.year == year &&
                                now.month == month &&
                                now.day == dayNumber;
                            final eventType = controller.getEventTypeForDay(dayNumber);
                            final dotColor = controller.getEventColor(eventType);

                            return GestureDetector(
                              onTap: () => controller.selectDay(dayNumber),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: isSelected ? PerfektTheme.primaryBlue : Colors.transparent,
                                      shape: BoxShape.circle,
                                      border: isToday && !isSelected
                                          ? Border.all(color: PerfektTheme.primaryBlue, width: 2)
                                          : null,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "$dayNumber",
                                        style: PerfektTheme.fontBold(
                                          15,
                                          color: isSelected
                                              ? Colors.white
                                              : (isToday ? PerfektTheme.primaryBlue : PerfektTheme.textDark),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  // Colored dot indicator
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: dotColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }),
                      const SizedBox(height: 20),
                      const Divider(height: 1, color: Color(0xFFF1F5F9)),
                      const SizedBox(height: 18),

                      // Event Category Legend
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildLegendItem("Work Day", PerfektTheme.primaryBlue),
                          _buildLegendItem("Meeting", const Color(0xFF10B981)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildLegendItem("Training", const Color(0xFFD97706)),
                          _buildLegendItem("Leave", const Color(0xFFDC2626)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Selected Date Events Header
                Obx(() {
                  final sel = controller.selectedDate.value;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "SCHEDULE FOR ${sel.day}/${sel.month}/${sel.year}",
                        style: PerfektTheme.fontBold(11, color: PerfektTheme.textLight).copyWith(letterSpacing: 1.0),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "Verified",
                          style: PerfektTheme.fontBold(11, color: PerfektTheme.primaryBlue),
                        ),
                      ),
                    ],
                  );
                }),
                const SizedBox(height: 14),

                // Dynamic Events List
                Obx(() {
                  final events = controller.getEventsForSelectedDate();
                  return Column(
                    children: events.map((ev) => _buildEventCard(ev, controller)).toList(),
                  );
                }),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(label, style: PerfektTheme.fontBold(13, color: PerfektTheme.textDark)),
      ],
    );
  }

  Widget _buildEventCard(CalendarEvent ev, CalendarController controller) {
    final badgeColor = controller.getEventColor(ev.type);
    final typeName = controller.getEventTypeName(ev.type);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: PerfektTheme.radiusCard,
        border: Border.all(color: PerfektTheme.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 5,
              decoration: BoxDecoration(
                color: badgeColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.access_time_rounded, size: 15, color: PerfektTheme.textMedium),
                            const SizedBox(width: 6),
                            Text(
                              ev.time,
                              style: PerfektTheme.fontBold(12, color: PerfektTheme.textMedium),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: badgeColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            typeName,
                            style: PerfektTheme.fontBold(11, color: badgeColor),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      ev.title,
                      style: PerfektTheme.fontBold(17, color: PerfektTheme.textDark),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      ev.subtitle,
                      style: PerfektTheme.fontRegular(13, color: PerfektTheme.textMedium),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, size: 14, color: PerfektTheme.primaryBlue),
                        const SizedBox(width: 4),
                        Text(
                          ev.location,
                          style: PerfektTheme.fontMedium(12, color: PerfektTheme.primaryBlue),
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
    );
  }
}
