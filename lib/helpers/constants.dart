import 'package:flutter/material.dart';

enum Emoji { netural, happy, veryHappy, sad, angry, crying }

class Constants {
  static Emoji returnEmoji(String emoji) {
    if (emoji == Emoji.netural.name) return Emoji.netural;
    if (emoji == Emoji.happy.name) return Emoji.happy;
    if (emoji == Emoji.veryHappy.name) return Emoji.veryHappy;
    if (emoji == Emoji.sad.name) return Emoji.sad;
    if (emoji == Emoji.angry.name) return Emoji.angry;
    if (emoji == Emoji.crying.name) return Emoji.crying;
    return Emoji.netural;
  }

  static String returnStringEmoji(Emoji emoji) {
    switch (emoji) {
      case Emoji.netural:
        return '😐';
      case Emoji.happy:
        return '🙂';
      case Emoji.veryHappy:
        return '😊';
      case Emoji.sad:
        return '🙁';
      case Emoji.angry:
        return '😡';
      case Emoji.crying:
        return '😭';
    }
  }

  static String getMonth(DateTime date) {
    switch (date.month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sept';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
    }
    return 'NA';
  }

  static String getWeekDay(DateTime date) {
    switch (date.weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
    }
    return 'NA';
  }

  static String getFormatedTime(
      {required BuildContext context, required String time}) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(date).format(context);
  }

  static DateTime getDate(
      {required BuildContext context, required String time}) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return date;
  }

  static String getString({required DateTime time}) {
    final DateTime now = DateTime.now();

    // current
    if (now.day == time.day &&
        now.month == time.month &&
        now.year == time.year) {
      return 'How\'s your mood today ?';
    }
    // past
    if (now.compareTo(time) >= 1) {
      return 'How was your mood ?';
    }
    // future
    if (now.compareTo(time) <= -1) {
      return 'What\'s your expected mood for the day ?';
    }
    // default
    return 'How\'s your mood ?';
  }
}

class EmojiText extends StatelessWidget {
  final Emoji mood;
  const EmojiText({super.key, required this.mood});

  @override
  Widget build(BuildContext context) {
    return Text(
      Constants.returnStringEmoji(mood),
      style: const TextStyle(fontSize: 25),
    );
  }
}

class DateText extends StatelessWidget {
  final Future Function()? showDatePicker;
  final DateTime selectedDate;
  final bool view;

  const DateText({
    super.key,
    required this.selectedDate,
    required this.showDatePicker,
  }) : view = false;

  const DateText.view({super.key, required this.selectedDate})
      : view = true,
        showDatePicker = null;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: showDatePicker,
      borderRadius: BorderRadius.circular(5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${selectedDate.day}',
            style: const TextStyle(color: Colors.white, fontSize: 24),
          ),
          const SizedBox(width: 5),
          Text(
            Constants.getMonth(selectedDate),
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(width: 5),
          Text(
            '${selectedDate.year}',
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
          if (!view) const SizedBox(width: 7),
          if (!view)
            const Icon(
              Icons.arrow_drop_down_outlined,
              color: Colors.white,
            ),
        ],
      ),
    );
  }
}

class TitleTextField extends StatelessWidget {
  final TextEditingController titleController;
  final bool view;

  const TitleTextField({super.key, required this.titleController})
      : view = false;

  const TitleTextField.view({super.key, required this.titleController})
      : view = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: view ? true : false,
      controller: titleController,
      textCapitalization: TextCapitalization.words,
      style: const TextStyle(fontSize: 26, color: Colors.white),
      decoration: const InputDecoration(
        hintText: 'Title',
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white),
      ),
    );
  }
}

class ContentTextField extends StatelessWidget {
  final TextEditingController contentControl;
  final bool view;

  const ContentTextField({super.key, required this.contentControl})
      : view = false;

  const ContentTextField.view({super.key, required this.contentControl})
      : view = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: null,
      minLines: null,
      expands: view ? false : true,
      readOnly: view ? true : false,
      controller: contentControl,
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.multiline,
      style: const TextStyle(fontSize: 18, color: Colors.white),
      decoration: const InputDecoration(
        isDense: true,
        hintText: 'Write more here...',
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white),
      ),
    );
  }
}

class SaveUpdateButton extends StatelessWidget {
  final String text;
  final void Function() onTap;

  const SaveUpdateButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class FirstEntry extends StatelessWidget {
  const FirstEntry({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Tap to start your first entry.',
          style: TextStyle(
            color: Colors.lightBlue,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Colors.lightBlue,
        ),
        Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Colors.lightBlue.shade200,
        ),
        Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Colors.lightBlue.shade100,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class BottomButtons extends StatelessWidget {
  final IconData icon;
  final String toolTip;
  final void Function()? onPressed;
  const BottomButtons({
    super.key,
    required this.icon,
    required this.toolTip,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: toolTip,
      onPressed: onPressed,
      alignment: Alignment.center,
      color: Colors.white,
      icon: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(51, 255, 255, 255),
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(10),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}
