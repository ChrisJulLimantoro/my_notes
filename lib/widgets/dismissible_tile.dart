import 'package:flutter/material.dart';
import 'package:my_notes/models/note.dart';
import 'package:my_notes/widgets/custom_tile.dart';
import 'package:my_notes/widgets/dismissible_bg.dart';

class DismissibleTile extends StatelessWidget {
  final Note item;
  final Function(Note item) deleteNotes;
  final Function(Note item) pinNotes;
  final Function(BuildContext context, Note item) launchSnackBar;
  const DismissibleTile(
      {super.key,
      required this.item,
      required this.deleteNotes,
      required this.pinNotes,
      required this.launchSnackBar});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(item.id),
      onDismissed: (direction) {
        deleteNotes(item);
        if (direction == DismissDirection.endToStart) {
          launchSnackBar(context, item);
        } else {
          pinNotes(item);
        }
      },
      background: DismissibleBg(
        isSecondary: false,
        isPinned: item.isPinned,
      ),
      secondaryBackground: DismissibleBg(
        isSecondary: true,
        isPinned: item.isPinned,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/detail', arguments: item);
          },
          child: CustomTile(item: item),
        ),
      ),
    );
  }
}
