import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

import '../crud/journal_services.dart';
import '../helpers/constants.dart';
import '../models/journal.dart';
import '../widgets/pop_up.dart';

class EditJournal extends StatefulWidget {
  final Journal journal;

  const EditJournal({super.key, required this.journal});

  @override
  State<EditJournal> createState() => _EditJournalState();
}

class _EditJournalState extends State<EditJournal> {
  late TextEditingController _titleControl;
  late TextEditingController _contentControl;

  late Emoji _mood;
  late DateTime _selectedDate;
  late DateTime _day;

  @override
  void initState() {
    super.initState();
    _titleControl = TextEditingController();
    _contentControl = TextEditingController();
    _titleControl.text = widget.journal.title;
    _contentControl.text = widget.journal.subtitle;
    _mood = Constants.returnEmoji(widget.journal.mood);
    _selectedDate =
        Constants.getDate(context: context, time: widget.journal.date);
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
      initialDate: _selectedDate,
      firstDate: DateTime.utc(2016),
      lastDate: DateTime.utc(2030),
    );

    if (selectedDay == null) return;

    setState(() => _selectedDate = selectedDay);
  }

  void _save(DateTime day) async {
    if (_titleControl.text.isEmpty || _titleControl.text == '') return;
    if (_contentControl.text.isEmpty || _contentControl.text == '') return;

    await EntryService()
        .updateEntry(
      id: widget.journal.id,
      title: _titleControl.text,
      subtitle: _contentControl.text,
      mood: _mood.name,
      day: _day.millisecondsSinceEpoch.toString(),
      date: _selectedDate.millisecondsSinceEpoch.toString(),
    )
        .then((_) {
      Fluttertoast.showToast(msg: 'Entry updated successfully !!');
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
    _day = DateTime.utc(
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
        actions: [SaveUpdateButton(text: 'UPDATE', onTap: () => _save(_day))],
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
