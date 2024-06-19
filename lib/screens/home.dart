import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> notes = [
    {
      "id": 1,
      "title": "Note 1",
      "content": "Note 1 description",
      "created_at": DateTime.parse("2024-06-24"),
    },
    {
      "id": 2,
      "title": "Note 2",
      "content": "Note 2 description",
      "created_at": DateTime.parse("2024-07-24"),
    },
    {
      "id": 3,
      "title": "Note 3",
      "content": "Note 3 description",
      "created_at": DateTime.parse("2024-08-24"),
    }
  ];

  List<Map<String, dynamic>> notesCopy = [];

  @override
  void initState() {
    super.initState();
    notesCopy = List.from(notes);
  }

  // Function for snackbar
  void launchSnackBar(BuildContext context, Map<String, dynamic> item) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        'Notes ${item["title"]} deleted',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      action: SnackBarAction(
        label: 'Undo',
        textColor: Colors.white,
        onPressed: () {
          // Add item back to list
          setState(() {
            notes.add(item);
            notesCopy.add(item);
          });
        },
      ),
      backgroundColor: Colors.red,
    ));
  }

  // function for filter notes
  void filterNotes(String value) {
    value = value.toLowerCase();
    setState(() {
      notesCopy = notes.where((item) {
        return item['title'].toLowerCase().contains(value) ||
            item['content'].toLowerCase().contains(value) ||
            DateFormat('yyyy-MM-dd').format(item['created_at']).contains(value);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    Brightness theme = MediaQuery.of(context).platformBrightness;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: const Icon(
                  Icons.settings,
                  color: Colors.grey,
                  size: 30,
                ),
                onPressed: () => {},
              ),
            ),
            title: const Text(
              'My Notes',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                  icon: const Icon(
                    Icons.add,
                    color: Colors.grey,
                    size: 35,
                  ),
                  onPressed: () => {
                    Navigator.pushNamed(context, '/new', arguments: {
                      'isNew': true,
                    }),
                  },
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
                    onChanged: (value) => {
                      filterNotes(value),
                    },
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
                        return Dismissible(
                          key: ValueKey(item['id']),
                          onDismissed: (direction) {
                            setState(() {
                              notes.removeWhere(
                                  (element) => element['id'] == item['id']);
                              notesCopy.removeWhere(
                                  (element) => element['id'] == item['id']);
                            });
                            launchSnackBar(context, item);
                          },
                          background: Container(
                            color: Colors.red,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(Icons.delete, color: Colors.white),
                                  Text('Deleted',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ],
                              ),
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, '/detail',
                                    arguments: item);
                              },
                              child: ListTile(
                                title: Text(item['title']),
                                subtitle: Text(item['content']),
                                trailing: Text(DateFormat('yyyy-MM-dd')
                                    .format(item['created_at'])),
                              ),
                            ),
                          ),
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
