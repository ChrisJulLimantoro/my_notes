import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:my_notes/models/note.dart';

class CustomTile extends StatelessWidget {
  final Note item;
  CustomTile({Key? key, required this.item}) : super(key: key);

  String getTime(DateTime createdAt) {
    Duration diff = DateTime.now().difference(createdAt);

    if (diff.inDays >= 1) {
      return '${diff.inDays}d ago';
    } else if (diff.inHours >= 1) {
      return '${diff.inHours}h ago';
    } else if (diff.inMinutes >= 1) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inSeconds >= 1) {
      return '${diff.inSeconds}s ago';
    } else {
      return 'just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile(
      padding: EdgeInsets.only(
        top: 16.0,
        left: item.isPinned ? 8.0 : 16.0,
        bottom: 16.0,
        right: 16.0,
      ),
      leading: item.isPinned
          ? const Icon(
              Icons.push_pin,
              size: 16,
              color: Colors.black,
            )
          : null,
      leadingToTitle: 8.0,
      leadingSize: 30,
      title: Text(
        item.title,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        item.content,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text('last modified ${getTime(item.updatedAt)}',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          )),
    );
  }
}
