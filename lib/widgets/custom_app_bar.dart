import 'package:flutter/material.dart';

class CustomSliverAppBar extends StatelessWidget {
  final bool isNew;
  final String titleText;
  final String updatedAt;
  final VoidCallback onSettingsPressed;
  final VoidCallback onNewNotePressed;
  final VoidCallback onBackPressed;
  final VoidCallback onSavePressed;
  final bool isEditingMode;
  final bool isDisabled;
  final Brightness theme;

  const CustomSliverAppBar({
    Key? key,
    this.isNew = false,
    required this.titleText,
    required this.updatedAt,
    required this.onSettingsPressed,
    required this.onNewNotePressed,
    required this.onBackPressed,
    required this.onSavePressed,
    this.isEditingMode = false,
    this.isDisabled = false,
    required this.theme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      leading: isEditingMode
          ? TextButton(
              onPressed: onBackPressed,
              child: Text(
                isDisabled ? 'Back' : 'Cancel',
                style: TextStyle(
                  color: Colors.red[400],
                  fontSize: 16,
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: const Icon(
                  Icons.settings,
                  color: Colors.grey,
                  size: 30,
                ),
                onPressed: onSettingsPressed,
              ),
            ),
      leadingWidth: isEditingMode ? 80 : null,
      title: isEditingMode
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isNew ? 'Untitled' : titleText,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  updatedAt,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            )
          : const Text(
              'My Notes',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: isEditingMode
              ? TextButton(
                  onPressed: isDisabled ? null : onSavePressed,
                  child: Text(
                    'Save',
                    style: TextStyle(
                      color: isDisabled ? Colors.grey : Colors.blue,
                      fontSize: 16,
                    ),
                  ),
                )
              : IconButton(
                  icon: const Icon(
                    Icons.add,
                    color: Colors.grey,
                    size: 35,
                  ),
                  onPressed: onNewNotePressed,
                ),
        )
      ],
      backgroundColor: theme == Brightness.light
          ? Colors.white.withAlpha(100)
          : Colors.black.withAlpha(100),
      surfaceTintColor: theme == Brightness.light
          ? Colors.white.withAlpha(200)
          : Colors.black.withAlpha(100),
      elevation: 2,
      pinned: true,
      snap: true,
      floating: true,
    );
  }
}
