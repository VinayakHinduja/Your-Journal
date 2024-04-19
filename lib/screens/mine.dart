import 'dart:ui';

import 'package:flutter/material.dart';

import '../crud/journal_services.dart';
import '../helpers/constants.dart';
import '../models/journal.dart';

class Mine extends StatefulWidget {
  const Mine({super.key});

  @override
  State<Mine> createState() => _MineState();
}

class _MineState extends State<Mine> {
  int weekOffset = 0;

  final DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    ///

    final DateTime sunday = now.subtract(Duration(days: now.weekday - 1));

    final DateTime startingDate = sunday.add(Duration(days: weekOffset * 7));

    // final DateFormat formatter = DateFormat('dd');

    final List<DateTime> weekDates = List.generate(7, (index) {
      return startingDate.add(Duration(days: index));
    });

    final List<DateTime> formattedDates = weekDates
        .map((date) => DateTime.utc(date.year, date.month, date.day))
        .toList();

    ///

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 50,
        title: const Text('Stats'),
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 18),
      ),
      backgroundColor: const Color.fromARGB(255, 4, 27, 46),
      body: Column(
        children: [
          FutureBuilder(
            future: EntryService().getAllEntries(),
            builder: (context, snapshot) {
              List<Journal> list = snapshot.data ?? [];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                height: MediaQuery.of(context).size.height * .25,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/images/purple.jpg'),
                    fit: BoxFit.fill,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 15,
                    left: 20,
                    right: 20,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            height: 30,
                            width: 30,
                            child: Image.asset('assets/images/book.png'),
                          ),
                          const Text(
                            '   YourJournal',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              list.length.toString(),
                              style: const TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              list.length == 1 ? 'Entry' : 'Entries',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 23),
                        child: Text(
                          'A Dairy Means Yes Indeed',
                          style: TextStyle(
                            fontSize: 36,
                            letterSpacing: 1.5,
                            color: Colors.white,
                            fontFamily: 'Italianno',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * .17,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color.fromARGB(125, 13, 72, 161),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 15,
                    left: 20,
                    right: 20,
                    bottom: 15,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Daily Statistics',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                height: 25,
                                width: 25,
                                child: IconButton(
                                  padding: const EdgeInsets.all(0),
                                  onPressed: () => setState(() => weekOffset--),
                                  alignment: Alignment.center,
                                  color: Colors.white,
                                  icon: const Icon(Icons.arrow_back_ios),
                                ),
                              ),
                              Text(
                                '${formattedDates.first.month}/${formattedDates.first.day} - ${formattedDates.last.month}/${formattedDates.last.day}',
                                style: TextStyle(
                                  color: Colors.grey[300],
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                height: 25,
                                width: 25,
                                child: IconButton(
                                  padding: const EdgeInsets.all(0),
                                  onPressed: () => setState(() => weekOffset++),
                                  alignment: Alignment.center,
                                  color: Colors.white,
                                  icon: const Icon(Icons.arrow_forward_ios),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          for (var i in formattedDates)
                            NoOfEntries(
                                day: i.millisecondsSinceEpoch.toString())
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NoOfEntries extends StatelessWidget {
  final String day;

  const NoOfEntries({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(int.parse(day));
    DateTime now = DateTime.now();
    return FutureBuilder(
      future: EntryService().getEntriesOfDay(day: day),
      builder: (context, snapshot) {
        List<Journal> list = snapshot.data ?? [];
        bool today = date.day == now.day &&
            date.month == now.month &&
            date.year == now.year;
        Color g = Colors.lightGreenAccent[400]!;
        return Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: list.isEmpty ? Colors.transparent : Colors.orange,
                border: Border.all(
                  color: list.isEmpty
                      ? today
                          ? g
                          : Colors.grey
                      : today
                          ? g
                          : Colors.orange,
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Text(
                list.length.toString(),
                style:
                    TextStyle(color: list.isEmpty ? Colors.grey : Colors.white),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              Constants.getWeekDay(date),
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        );
      },
    );
  }
}
