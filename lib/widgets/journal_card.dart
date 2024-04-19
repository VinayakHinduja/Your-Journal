import 'dart:ui';

import 'package:flutter/material.dart';

import '../helpers/constants.dart';

class JournalCard extends StatelessWidget {
  final String time;
  final String title;
  final String subtitle;
  final Emoji mood;
  final void Function() onTap;
  final bool calendar;

  const JournalCard({
    super.key,
    required this.time,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.mood,
  }) : calendar = false;

  const JournalCard.cal({
    super.key,
    required this.time,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.mood,
  }) : calendar = true;

  @override
  Widget build(BuildContext context) {
    DateTime date = Constants.getDate(context: context, time: time);
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: InkWell(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(125, 13, 72, 161),
              borderRadius: BorderRadius.circular(15),
            ),
            // padding: EdgeInsets.all(8),
            margin: const EdgeInsets.only(top: 10, left: 15, right: 15),
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!calendar)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            date.day.toString(),
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            Constants.getMonth(date).toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      EmojiText(mood: mood),
                    ],
                  ),
                if (!calendar) const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (calendar) const SizedBox(height: 5),
                        SizedBox(
                          width: 300,
                          child: Text(
                            subtitle,
                            maxLines: 1,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    if (calendar) EmojiText(mood: mood),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
