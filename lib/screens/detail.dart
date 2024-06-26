import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:my_notes/models/note.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_notes/widgets/custom_app_bar.dart';

class DetailScreen extends StatefulWidget {
  final bool isNew;
  const DetailScreen({super.key, required this.isNew});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool disabled = true;
  var uuid = const Uuid();
  Note note = Note(
    id: '',
    title: 'untitled',
    content: '',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    isPinned: false,
  );
  var box = Hive.box('notes');
  final TextEditingController titleController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        if (!widget.isNew) {
          final arguments = ModalRoute.of(context)!.settings.arguments as Note;
          titleController.text = arguments.title;
          notesController.text = arguments.content;
          note = arguments;
        } else {
          titleController.text = '';
          notesController.text = '';
        }
      });
    });
  }

  void back() {
    if (disabled) {
      Navigator.pop(context);
    } else {
      _showAlert(context);
    }
  }

  void saveNote() {
    if (!disabled) {
      setState(() {
        note.title = titleController.text;
        note.content = notesController.text;
        note.updatedAt = DateTime.now();
        if (widget.isNew) {
          note.createdAt = DateTime.now();
          note.id = uuid.v4();
          box.add(note);
        }
        note.save();
        // disabled = true;
        Navigator.pushReplacementNamed(context, '/home');
      });
    }
  }

  // function to launch alert dialog
  void _showAlert(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Discard changes?'),
          content: const Text('Are you sure you want to discard changes?'),
          actions: [
            CupertinoDialogAction(
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            CupertinoDialogAction(
              child:
                  const Text('Discard', style: TextStyle(color: Colors.blue)),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/home');
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Brightness theme = MediaQuery.of(context).platformBrightness;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            titleText: 'My Notes',
            updatedAt: '',
            onSettingsPressed: () => {},
            onNewNotePressed: () => {},
            onBackPressed: () => {back()},
            onSavePressed: () => {saveNote()},
            theme: theme,
            isEditingMode: true,
            isDisabled: disabled,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Title',
                    ),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    onChanged: (value) {
                      setState(() {
                        if (value != note.title) {
                          disabled = false;
                        } else {
                          disabled = true;
                        }
                      });
                    },
                  ),
                  TextField(
                    controller: notesController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Notes',
                    ),
                    minLines: 1,
                    maxLines: null,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                    onChanged: (value) {
                      setState(() {
                        if (value != note.content) {
                          disabled = false;
                        } else {
                          disabled = true;
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      backgroundColor:
          theme == Brightness.light ? Colors.grey[200] : Colors.black,
    );
  }
}
