import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
// import 'package:path_provider/path_provider.dart' as p;

import '../crud/journal_services.dart';
import '../helpers/constants.dart';
import '../widgets/pop_up.dart';

class AddJournal extends StatefulWidget {
  final bool fromCalendar;

  final DateTime? date;

  const AddJournal({super.key})
      : date = null,
        fromCalendar = false;

  const AddJournal.cal({
    super.key,
    this.fromCalendar = true,
    required this.date,
  });

  @override
  State<AddJournal> createState() => _AddJournalState();
}

class _AddJournalState extends State<AddJournal> {
  late TextEditingController _titleControl;
  late TextEditingController _contentControl;

  // ignore: prefer_final_fields
  Emoji _mood = Emoji.happy;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _titleControl = TextEditingController();
    _contentControl = TextEditingController();
  }

  @override
  void dispose() {
    _titleControl.dispose();
    _contentControl.dispose();
    super.dispose();
  }

  Future _showdatePicker() async {
    DateTime? day;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (c) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 4, 27, 46),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(Icons.access_time_rounded), Text('    Pick a Date')],
        ),
        contentPadding: const EdgeInsets.all(10),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: MediaQuery.of(c).size.height * 0.30,
              child: CupertinoTheme(
                data: const CupertinoThemeData(
                  textTheme: CupertinoTextThemeData(
                    dateTimePickerTextStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                child: CupertinoDatePicker(
                  initialDateTime: day ?? DateTime.now(),
                  minimumDate: DateTime(2016),
                  maximumDate: DateTime(2030),
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: (d) => setState(() {
                    day = d;
                    _selectedDate = d;
                  }),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CupertinoButton(
                  padding: const EdgeInsets.all(0),
                  onPressed: () {
                    setState(() => _selectedDate = day ?? DateTime.now());
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                CupertinoButton(
                  padding: const EdgeInsets.all(0),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'CANCEL',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _save(DateTime day) async {
    if (_titleControl.text.isEmpty ||
        _titleControl.text == '' ||
        _contentControl.text.isEmpty ||
        _contentControl.text == '') {
      Fluttertoast.showToast(msg: 'Please enter something in title or content');
      return;
    }

    await EntryService()
        .createEntry(
      title: _titleControl.text,
      subtitle: _contentControl.text,
      mood: _mood.name,
      day: day.millisecondsSinceEpoch.toString(),
      date: _selectedDate.millisecondsSinceEpoch.toString(),
    )
        .then((_) {
      Fluttertoast.showToast(msg: 'Entry added successfully !!');
      Navigator.pop(context);
    });
  }

  Future<void> _showDialogue(DateTime selectedDate) async {
    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: const Color.fromARGB(255, 4, 27, 46),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      builder: (c) => PopUp(
        selectedDate: selectedDate,
        onTap: (m, ctx) {
          setState(() => _mood = m);
          Navigator.pop(ctx);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.fromCalendar) setState(() => _selectedDate = widget.date!);
    DateTime day = DateTime.utc(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
    );

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 4, 27, 46),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close_rounded),
        ),
        actions: [SaveUpdateButton(text: 'SAVE', onTap: () => _save(day))],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DateText(
                  showDatePicker: _showdatePicker,
                  // () async {
                  //   final docPath = await p.getExternalStorageDirectories(
                  //       type: p.StorageDirectory.documents);
                  //   print(docPath!.first);
                  // },
                  selectedDate: _selectedDate,
                ),
                IconButton(
                  onPressed: () => _showDialogue(_selectedDate),
                  icon: EmojiText(mood: _mood),
                ),
              ],
            ),
            TitleTextField(titleController: _titleControl),
            Expanded(child: ContentTextField(contentControl: _contentControl)),
          ],
        ),
      ),
    );
  }
}



/*

Future _showdatePicker() async {
    DateTime? selectedDay = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2016),
      lastDate: DateTime(2030),
      keyboardType: TextInputType.datetime,
      initialEntryMode: DatePickerEntryMode.input,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.white, // selected backgrond color
              onPrimary: Colors.black, // selected text color
              onSurface: Colors.white, // date text
              onBackground: Colors.white, // line
              surface: Color.fromARGB(255, 4, 27, 46), // background
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDay == null) return;

    setState(() => _selectedDate = selectedDay);
  }

 */