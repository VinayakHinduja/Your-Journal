// ignore_for_file: empty_catches

import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../models/journal.dart';
import 'const.dart';
import 'crud_exceptions.dart';

class EntryService {
  Database? _db;

  List<Journal> _entry = [];

  static final EntryService _shared = EntryService._sharedInstance();
  factory EntryService() => _shared;
  late final StreamController<List<Journal>> _notesStreamController;
  Stream<List<Journal>> get allEntries => _notesStreamController.stream;

  EntryService._sharedInstance() {
    _ensureDbIsOpen();
    _notesStreamController =
        StreamController<List<Journal>>.broadcast(onListen: () {
      _notesStreamController.sink.add(_entry);
    });
  }

  Future<void> _cacheEntries() async {
    final allEntries = await getAllEntries();
    _entry = allEntries.toList();
    _notesStreamController.add(_entry);
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      return db;
    }
  }

  Future<void> _ensureDbIsOpen() async {
    try {
      await open();
    } on DatabaseAlreadyOpen {}
  }

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpen();
    }
    try {
      final docPath = await getExternalStorageDirectory();
      final dbPath = p.join(docPath!.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;
      await db.execute(createJournalTable);
      await _cacheEntries();
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectory();
    }
  }

  Future<Journal> createEntry({
    required String title,
    required String subtitle,
    required String date,
    required String mood,
    required String day,
  }) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    if (title.isEmpty) throw NoTextFound();

    final entry = await db.insert(journalTable, {
      titleColumn: title,
      subtitleColumn: subtitle,
      dateColumn: date,
      moodColumn: mood,
      dayColumn: day,
    });

    final enter = Journal(
      id: entry,
      title: title,
      subtitle: subtitle,
      date: date,
      mood: mood,
      day: day,
    );

    _entry.add(enter);
    _notesStreamController.add(_entry);
    return enter;
  }

  Future<Journal> getEntry({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final entries = await db
        .query(journalTable, limit: 1, where: 'id = ?', whereArgs: [id]);
    if (entries.isEmpty) {
      throw CouldNotFindNote();
    } else {
      final entry = Journal.fromRow(entries.first);
      _entry.removeWhere((entry) => entry.id == id);
      _entry.add(entry);
      _notesStreamController.add(_entry);
      return entry;
    }
  }

  Future<List<Journal>> getEntriesOfDay({required String day}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    List<Journal> entries0 = [];
    final entries =
        await db.query(journalTable, where: 'day = ?', whereArgs: [day]);
    if (entries.isEmpty) {
      return [];
    } else {
      for (var element in entries) {
        final entry = Journal.fromRow(element);
        entries0.add(entry);
        _notesStreamController.add(_entry);
      }
      return entries0;
    }
  }

  Future<List<Journal>> getAllEntries() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final notes = await db.query(journalTable);
    // devtools.log(notes.toList().toString());
    return notes.map((noteRow) => Journal.fromRow(noteRow)).toList();
  }

  Future<Journal> updateEntry({
    required int id,
    required String title,
    required String subtitle,
    required String date,
    required String mood,
    required String day,
  }) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    //make sure note exist
    await getEntry(id: id);

    // update db
    final updateCount = await db.update(
      journalTable,
      {
        titleColumn: title,
        subtitleColumn: subtitle,
        dateColumn: date,
        moodColumn: mood,
        dayColumn: day,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
    if (updateCount == 0) {
      throw CouldNotUpdateNote();
    } else {
      final updatedEntry = await getEntry(id: id);
      _entry.removeWhere((entry) => entry.id == updatedEntry.id);
      _entry.add(updatedEntry);
      _notesStreamController.add(_entry);
      return updatedEntry;
    }
  }

  Future<void> deleteEntries({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deleteCount =
        await db.delete(journalTable, where: 'id = ?', whereArgs: [id]);
    if (deleteCount == 0) {
      throw CouldNotDeleteNote();
    } else {
      _entry.removeWhere((entry) => entry.id == id);
      _notesStreamController.add(_entry);
    }
  }

  Future<int> deleteAllEntries() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final numberOfDeletions = await db.delete(journalTable);
    _entry = [];
    _notesStreamController.add(_entry);
    return numberOfDeletions;
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      await db.close();
      _db = null;
    }
  }
}
