import 'package:flutter/material.dart';
import 'package:letsplay/ReservationDetailsPage.dart';
import 'package:table_calendar/table_calendar.dart';
import 'BasePage.dart';

class ReserverPage extends StatefulWidget {
  final String fieldTitle;
  final String fieldLocation;
  final String fieldPrice;

  const ReserverPage({
    required this.fieldTitle,
    required this.fieldLocation,
    required this.fieldPrice,
  });

  @override
  _ReserverPageState createState() => _ReserverPageState();
}

class _ReserverPageState extends State<ReserverPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<String> _timeSlots = [];

  @override
  void initState() {
    super.initState();
    _generateTimeSlots(_focusedDay);
  }

  void _generateTimeSlots(DateTime day) {
    // Generate time slots for the selected day
    setState(() {
      _timeSlots = List.generate(12, (index) {
        final startHour = 8 + index;
        final endHour = startHour + 1;
        return '${startHour.toString().padLeft(2, '0')}:00 - ${endHour.toString().padLeft(2, '0')}:00';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'Réserver: ${widget.fieldTitle}', // Display the field title
      currentIndex: 2,
      body: Column(
        children: [
          // Calendar Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white, // Keep the calendar background white
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.fieldTitle,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.fieldLocation,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Prix: ${widget.fieldPrice}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                      _generateTimeSlots(selectedDay);
                    });
                  },
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    defaultTextStyle: const TextStyle(color: Colors.black),
                    weekendTextStyle: const TextStyle(color: Colors.red),
                  ),
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    leftChevronIcon:
                        Icon(Icons.chevron_left, color: Colors.black),
                    rightChevronIcon:
                        Icon(Icons.chevron_right, color: Colors.black),
                  ),
                  daysOfWeekStyle: const DaysOfWeekStyle(
                    weekdayStyle: TextStyle(color: Colors.grey),
                    weekendStyle: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
          // Time Slots Section
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:
                    const Color(0xFF0B2133), // Dark background for time slots
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Horaires disponibles',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _timeSlots.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _timeSlots[index],
                                style: TextStyle(
                                  fontSize: 16,
                                  color: index % 2 == 0
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (_selectedDay != null) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ReservationDetailsPage(
                                          selectedDay: _selectedDay!,
                                          selectedTimeSlot: _timeSlots[index],
                                        ),
                                      ),
                                    );
                                  } else {
                                    // Show a message if no day is selected
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Veuillez sélectionner une date !',
                                        ),
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text('Réserver'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
