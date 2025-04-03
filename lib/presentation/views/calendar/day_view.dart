import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:calendar_day_view/calendar_day_view.dart';

import '../../../app/typedefs/e_event_type.dart';
import '../../../configurations/strings.dart';
import '../../../data/domain/event.dart';
import '../../view_models/calendar/day_view_model.dart'; // Импортируйте пакет calendar_day_view


class DayViewCalendar extends ConsumerStatefulWidget {
  final DateTime? selectedDay;
  const DayViewCalendar({Key? key, this.selectedDay}) : super(key: key);

  @override
  _DayViewCalendarState createState() => _DayViewCalendarState();
}

class _DayViewCalendarState extends ConsumerState<DayViewCalendar> {
  late DateTime selectedDay;

  @override
  void initState() {
    super.initState();
    selectedDay = widget.selectedDay ?? DateTime.now();
  }

  // Помогает объединить выбранную дату и время из TimeOfDay в DateTime.
  DateTime combineDateAndTime(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(DateFormat('EEEE, MMM d, yyyy').format(selectedDay)),
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: selectedDay,
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            calendarFormat: CalendarFormat.week,
            selectedDayPredicate: (day) => isSameDay(day, selectedDay),
            onDaySelected: (sel, focusedDay) {
              setState(() {
                selectedDay = sel;
              });
            },
            headerStyle: HeaderStyle(
              formatButtonTextStyle: theme.textTheme.bodySmall!,
              formatButtonDecoration: BoxDecoration(
                border: Border.all(width: 1.0, color: theme.colorScheme.primary),
                color: theme.colorScheme.secondary,
                borderRadius: BorderRadius.circular(25.0),
              ),
              formatButtonShowsNext: false,
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary,
                borderRadius: BorderRadius.circular(25.0),
              ),
              headerPadding: const EdgeInsets.all(0),
              headerMargin: const EdgeInsets.fromLTRB(0, 10, 0, 15),
            ),
            calendarBuilders: CalendarBuilders(
              headerTitleBuilder: (context, day) {
                return Center(
                  child: Text(
                    '${DateFormat.MMMM().format(day)} | ${day.day}-th',
                    style: theme.textTheme.bodySmall,
                  ),
                );
              },
              dowBuilder: (context, day) {
                return Center(
                  child: Text(
                    DateFormat.E().format(day).toUpperCase(),
                    style: theme.textTheme.bodySmall?.copyWith(fontSize: 15),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final eventsAsync = ref.watch(dayViewModelProvider);
                return eventsAsync.when(
                  data: (events) {
                    List<DayEvent<Event>> calendarEvents = events?.map((e) {
                      return DayEvent<Event>(
                        start: e.start,
                        end: e.end,
                        value: e,
                      );
                    }).toList() ?? [];

                    if (calendarEvents.isEmpty) {
                      return const Center(child: Text('No events'));
                    }

                    return CalendarDayView.overflow(
                      events: calendarEvents,
                      config: OverFlowDayViewConfig(
                        dividerColor: Colors.black,
                        currentDate: selectedDay,
                        timeGap: 60,
                        heightPerMin: 2,
                        endOfDay: const TimeOfDay(hour: 24, minute: 0),
                        startOfDay: const TimeOfDay(hour: 0, minute: 0),
                        showCurrentTimeLine: true,
                        showMoreOnRowButton: true,
                        time12: false,
                        timeLabelBuilder: (context, time) => Text(
                          '${time.hour}:${time.minute.toString().trim().length < 2 ?
                          '${time.minute}0' : time.minute.toString()}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      onTimeTap: (t) {
                        print(t);
                      },
                      overflowItemBuilder: (context, constraints, itemIndex, event) {
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          key: ValueKey(event.hashCode),
                          onTap: () {
                            print(event.value);
                            print('!' + event.start.toString());
                            print('!' + event.end.toString());
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 3, left: 3),
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            key: ValueKey(event.hashCode),
                            width: size.width / 4 - 6,
                            height: constraints.maxHeight,
                            decoration: BoxDecoration(
                              color: itemIndex % 2 == 0
                                  ? theme.colorScheme.tertiaryContainer
                                  : theme.colorScheme.secondaryContainer,
                              border: Border.all(color: theme.colorScheme.tertiary, width: 2),
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Center(
                              child: Text(
                                event.value.title,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.fade,
                                style: TextStyle(
                                  color: theme.colorScheme.onSecondaryContainer,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  loading: () =>
                  const Center(child: CircularProgressIndicator()),
                  error: (error, stackTrace) =>
                      Center(child: Text(error.toString())),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed(Strings.addEvent, extra: selectedDay);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
