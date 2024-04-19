import 'package:flutter/material.dart';

import '../helpers/constants.dart';

class PopUp extends StatelessWidget {
  final void Function(Emoji, BuildContext) onTap;
  final DateTime selectedDate;

  const PopUp({
    super.key,
    required this.onTap,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          color: const Color.fromARGB(255, 4, 27, 46),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      Constants.getString(time: selectedDate),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Buttons(
                        onPressed: () => onTap(Emoji.netural, context),
                        text: '😐',
                        description: 'Neutral',
                      ),
                      Buttons(
                        onPressed: () => onTap(Emoji.happy, context),
                        text: '🙂',
                        description: 'Happy',
                      ),
                      Buttons(
                        onPressed: () => onTap(Emoji.veryHappy, context),
                        text: '😊',
                        description: 'Very Happy',
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Buttons(
                        onPressed: () => onTap(Emoji.sad, context),
                        text: '🙁',
                        description: 'Sad',
                      ),
                      Buttons(
                        onPressed: () => onTap(Emoji.angry, context),
                        text: '😡',
                        description: 'Angry',
                      ),
                      Buttons(
                        onPressed: () => onTap(Emoji.crying, context),
                        text: '😭',
                        description: 'Crying',
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 45),
            ],
          ),
        )
      ],
    );
  }
}

class Buttons extends StatelessWidget {
  final Function() onPressed;
  final String text;
  final String description;
  const Buttons({
    super.key,
    required this.onPressed,
    required this.text,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton(
          onPressed: onPressed,
          child: Text(
            text,
            style: const TextStyle(fontSize: 30),
          ),
        ),
        Text(
          description,
          textAlign: TextAlign.center,
          softWrap: true,
          style: TextStyle(
            color: Colors.white,
            fontSize: description == 'Very Happy' ? 12 : 14,
          ),
        ),
      ],
    );
  }
}
