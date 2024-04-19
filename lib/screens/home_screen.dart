import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../crud/journal_services.dart';
import '../helpers/constants.dart';
import '../models/journal.dart';
import '../widgets/journal_card.dart';
import 'add_journal.dart';
import 'calendar.dart';
import 'mine.dart';
import 'view_journal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _searching = false;

  final List<Journal> _searchList = [];

  List<Journal> _list = [];

  bool _onWillPop() {
    if (_searching) {
      _searchList.clear();
      setState(() => _searching = !_searching);
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) => _onWillPop(),
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        backgroundColor: const Color.fromARGB(255, 4, 27, 46),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: _searching
            ? null
            : FloatingActionButton(
                onPressed: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (c) => const AddJournal()))
                    .whenComplete(
                      () => setState(() {}),
                    ),
                backgroundColor: Colors.lightBlueAccent,
                shape: const CircleBorder(),
                child: const Icon(Icons.add, color: Colors.black),
              ),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.white),
          title: _searching
              ? TextField(
                  autofocus: true,
                  textAlign: TextAlign.start,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search for entry',
                    hintStyle: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  cursorWidth: 1.5,
                  style: const TextStyle(
                    fontSize: 20,
                    letterSpacing: 1,
                    color: Colors.white,
                  ),
                  onChanged: (val) async {
                    _searchList.clear();

                    for (var i in _list) {
                      if (i.title.toLowerCase().contains(val.toLowerCase()) ||
                          i.subtitle
                              .toLowerCase()
                              .contains(val.toLowerCase())) {
                        _searchList.add(i);
                      }
                    }

                    setState(() => _searchList);
                  },
                )
              : null,
          actions: [
            IconButton(
              onPressed: () => setState(() {
                _searching = !_searching;
                _searchList.clear();
              }),
              icon: Icon(
                  _searching ? CupertinoIcons.clear_circled : Icons.search),
              color: Colors.white,
            ),
          ],
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/peakpx.jpg'),
              fit: BoxFit.fill,
            ),
          ),
          child: FutureBuilder(
            future: EntryService().getAllEntries(),
            builder: (ctx1, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (!_searching) const Spacer(),
                      if (!_searching) const FirstEntry(),
                      if (!_searching)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: BottomContainer(
                            calendarOnTap: () => Navigator.of(context)
                                .push(
                                  MaterialPageRoute(
                                    builder: (context) => const CalendarCard(),
                                  ),
                                )
                                .then(
                                  (value) => setState(() {}),
                                ),
                            mineOnTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Mine()),
                            ),
                          ),
                        )
                    ],
                  );
                }
                if (snapshot.data!.isNotEmpty) {
                  _list = snapshot.data!;
                  _list.sort(
                    (a, b) {
                      return DateTime.fromMillisecondsSinceEpoch(
                              int.parse(b.day))
                          .compareTo(DateTime.fromMillisecondsSinceEpoch(
                              int.parse(a.day)));
                    },
                  );
                  // setState(() => );
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .89,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _searching
                                ? _searchList.length
                                : snapshot.data!.length,
                            // itemCount: snapshot.data!.length,
                            itemBuilder: (ctx, i) {
                              if (!_searching) {
                                return JournalCard(
                                  title: snapshot.data![i].title,
                                  subtitle: snapshot.data![i].subtitle,
                                  mood: Constants.returnEmoji(
                                      snapshot.data![i].mood),
                                  time: snapshot.data![i].date,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ViewJournal(id: snapshot.data![i].id),
                                    ),
                                  ).whenComplete(() => setState(() {})),
                                );
                              } else {
                                return JournalCard(
                                  title: _searchList[i].title,
                                  subtitle: _searchList[i].subtitle,
                                  mood: Constants.returnEmoji(
                                      _searchList[i].mood),
                                  time: _searchList[i].date,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ViewJournal(id: _searchList[i].id),
                                    ),
                                  ).whenComplete(() => setState(() {})),
                                );
                              }
                            },
                          ),
                        ),
                        if (!_searching)
                          Padding(
                            padding: const EdgeInsets.only(top: 17),
                            child: BottomContainer(
                              calendarOnTap: () => Navigator.of(context)
                                  .push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const CalendarCard(),
                                    ),
                                  )
                                  .then(
                                    (value) => setState(() {}),
                                  ),
                              mineOnTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Mine(),
                                ),
                              ),
                            ),
                          )
                      ],
                    ),
                  );
                }
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}

class BottomContainer extends StatelessWidget {
  final void Function() calendarOnTap;

  final void Function() mineOnTap;

  const BottomContainer({
    super.key,
    required this.calendarOnTap,
    required this.mineOnTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        BottomButtons(
          icon: Icons.calendar_today_rounded,
          toolTip: 'Calendar',
          onPressed: calendarOnTap,
        ),
        const SizedBox(),
        BottomButtons(
          icon: Icons.stacked_bar_chart_sharp,
          toolTip: 'Stats',
          onPressed: mineOnTap,
        ),
      ],
    );
  }
}
