import 'package:flutter/material.dart';

import '../crud/journal_services.dart';
import '../helpers/constants.dart';
import '../models/journal.dart';
import 'edit_journal.dart';

class ViewJournal extends StatefulWidget {
  final int id;
  const ViewJournal({super.key, required this.id});

  @override
  State<ViewJournal> createState() => _ViewJournalState();
}

class _ViewJournalState extends State<ViewJournal> {
  late Journal journal;

  late TextEditingController _titleController;

  late TextEditingController _contentController;

  late Emoji _mood;

  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _showDeleteDialogue(int id) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 4, 27, 46),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(
              Icons.delete_sweep_rounded,
              color: Colors.deepOrangeAccent[400],
              size: 24,
            ),
            const Text('  Delete Entry', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: const Text(
            'Are you sure you want to delete this entry, once deleted it cannot be recovered ??'),
        contentTextStyle: const TextStyle(fontSize: 16, color: Colors.white),
        actions: [
          MaterialButton(
            onPressed: () => Navigator.pop(ctx),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Colors.white,
                shadows: [Shadow(color: Colors.white)],
                fontSize: 18,
              ),
            ),
          ),
          Container(
            width: 2,
            height: 25,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          MaterialButton(
            onPressed: () async =>
                await EntryService().deleteEntries(id: id).then((_) {
              Navigator.pop(ctx);
              Navigator.pop(context);
            }),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Text(
              'Delete',
              style: TextStyle(
                color: Colors.deepOrangeAccent[400],
                fontWeight: FontWeight.bold,
                fontSize: 18,
                shadows: const [Shadow(color: Colors.white)],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: EntryService().getEntry(id: widget.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.data != null) {
          var data = snapshot.data!;
          _mood = Constants.returnEmoji(data.mood);
          _titleController.text = data.title;
          _contentController.text = data.subtitle;
          _selectedDate = Constants.getDate(context: context, time: data.date);
          journal = data;
          return Scaffold(
            backgroundColor: const Color.fromARGB(255, 4, 27, 46),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              iconTheme: const IconThemeData(color: Colors.white),
              actions: [
                IconButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditJournal(journal: journal),
                    ),
                  ).then((value) => setState(() {})),
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () => _showDeleteDialogue(journal.id),
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DateText.view(selectedDate: _selectedDate),
                        EmojiText(mood: _mood),
                      ],
                    ),
                    TitleTextField.view(titleController: _titleController),
                    ContentTextField.view(contentControl: _contentController),
                  ],
                ),
              ),
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
