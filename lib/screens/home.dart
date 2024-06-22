import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';
import 'package:my_notes/models/note.dart';
import 'package:my_notes/widgets/custom_app_bar.dart';
import 'package:my_notes/screens/lock.dart';
import 'package:my_notes/widgets/dismissible_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var searchController = TextEditingController();
  var box = Hive.box('notes');
  List<Note> notes = [];
  List<Note> notesCopy = [];

  @override
  void initState() {
    super.initState();
    notes = List<Note>.from(box.values.toList());
    notesCopy = List.from(notes);
  }

  // Function for snackbar
  void launchSnackBar(BuildContext context, Note item) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Note Deleted'),
          content: Text('Are you sure want to delete this note ${item.title}'),
          actions: [
            CupertinoDialogAction(
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                addNote(item);
                Navigator.pop(context);
              },
            ),
            CupertinoDialogAction(
              child: const Text(
                'Proceed',
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  // Function for deleting notes
  void deleteNotes(Note item) {
    final note = box.values.firstWhere((element) => element.id == item.id);
    setState(() {
      notes.removeWhere((element) => element.id == item.id);
      notesCopy.removeWhere((element) => element.id == item.id);
      box.delete(note.key);
    });
  }

  // Function for adding notes
  void addNote(Note item) {
    setState(() {
      notes.add(item);
      notesCopy.add(item);
      box.add(item);
    });
  }

  // function for filter notes
  void filterNotes(String value) {
    value = value.toLowerCase();
    setState(() {
      notesCopy = notes.where((item) {
        return item.title.toLowerCase().contains(value) ||
            item.content.toLowerCase().contains(value) ||
            DateFormat('yyyy-MM-dd').format(item.createdAt).contains(value);
      }).toList();
      notesCopy.sort((a, b) {
        bool aPinned = a.isPinned; // Default to false if isPinned is null
        bool bPinned = b.isPinned; // Default to false if isPinned is null

        // Sort by isPinned in descending order (true comes before false)
        if (aPinned && !bPinned) {
          return -1; // a is pinned and b is not, so a should come before b
        } else if (!aPinned && bPinned) {
          return 1; // b is pinned and a is not, so b should come before a
        } else {
          return b.updatedAt.compareTo(a
              .updatedAt); // Both are either pinned or not pinned, maintain their order
        }
      });
    });
  }

  // function for pinning notes
  void pinNotes(Note item) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(item.isPinned ? 'Note Unpinned' : 'Note Pinned'),
          content: Text(
              'Are you sure want to ${item.isPinned ? 'unpin' : 'pin'} this note ${item.title}?'),
          actions: [
            CupertinoDialogAction(
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                setState(() {
                  notes.add(item);
                  box.add(item);
                  filterNotes("");
                });
                Navigator.pop(context);
              },
            ),
            CupertinoDialogAction(
              child: const Text(
                'Proceed',
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                item.isPinned = !item.isPinned;
                setState(() {
                  notes.add(item);
                  box.add(item);
                  filterNotes("");
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  // function for setting menu
  void launchSettingsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      enableDrag: true,
      isDismissible: true,
      elevation: 1,
      useSafeArea: false,
      scrollControlDisabledMaxHeightRatio: 1,
      builder: (BuildContext context) => const LockScreen(stage: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    Brightness theme = MediaQuery.of(context).platformBrightness;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              setState(() {
                notes = List<Note>.from(box.values.toList());
                notesCopy = List.from(notes);
                filterNotes(searchController.text);
              });
            },
          ),
          CustomSliverAppBar(
            titleText: 'My Notes',
            updatedAt: '',
            onSettingsPressed: () => {launchSettingsMenu(context)},
            onNewNotePressed: () => {
              Navigator.pushNamed(context, '/new', arguments: {
                'isNew': true,
              }),
            },
            onBackPressed: () {},
            onSavePressed: () {},
            theme: theme,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 24.0,
              ),
              child: Column(
                children: [
                  CupertinoSearchTextField(
                    placeholder: 'Search',
                    onChanged: (value) {
                      searchController.text = value;
                      filterNotes(value);
                    },
                    controller: searchController,
                  ),
                  const SizedBox(height: 16.0),
                  Container(
                    decoration: BoxDecoration(
                      color: theme == Brightness.light
                          ? Colors.white
                          : Colors.grey[800],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: notesCopy.map((item) {
                        return DismissibleTile(
                          item: item,
                          deleteNotes: deleteNotes,
                          pinNotes: pinNotes,
                          launchSnackBar: launchSnackBar,
                        );
                      }).toList(),
                    ),
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
