const createJournalTable = '''CREATE TABLE IF NOT EXISTS "journal" (
	"id"	INTEGER NOT NULL UNIQUE,
	"title"	TEXT NOT NULL,
	"subtitle"	TEXT,
	"date"	TEXT NOT NULL,
	"mood"	TEXT NOT NULL,
  "day"	TEXT NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT)
);''';

const dbName = 'journal.db';
const journalTable = 'journal';
const idColumn = 'id';
const titleColumn = 'title';
const subtitleColumn = 'subtitle';
const dateColumn = 'date';
const moodColumn = 'mood';
const dayColumn = 'day';
