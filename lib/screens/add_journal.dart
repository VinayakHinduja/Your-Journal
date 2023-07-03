import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

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
    DateTime? selectedDay = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.utc(2016),
      lastDate: DateTime.utc(2030),
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
        onTap: (p0, p1) {
          setState(() => _mood = p0);
          Navigator.pop(p1);
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
