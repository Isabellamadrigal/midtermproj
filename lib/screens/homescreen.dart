import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: 2,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[200],
        centerTitle: true,
        title: const Text('TO DO LIST'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: Container(
          decoration: const BoxDecoration(
            
            image: DecorationImage(
              
              image: AssetImage("assets/images/bg.jpg",
              
              ),
              fit: BoxFit.fill
              //alignment: Alignment.bottomCenter,
             // opacity: 0.5,
            ),
          ),
          padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.025,
            horizontal: 12.0,
          ),
          child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TabBar(
              controller: tabController,
              tabs: const [
                Tab(
                  child: Text(
                    'On-Going',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Finished',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('todo')
                        .doc(widget.userId)
                        .collection('list')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: Center(
                            child: Text('Empty'),
                          ),
                        );
                      }
                      if (snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Center(
                            child: Text('Empty'),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final todo = snapshot.data!.docs[index];

                          if (todo['status'] == 'done') {
                            return Container();
                          }

                          return ListTile(
                            title: Text(todo['todo']),
                            onLongPress: () {
                              showTodoUpdateDialog(todo.id);
                            },
                            leading: Checkbox(
                              value: todo['status'] == 'done' ? true : false,
                              onChanged: (value) {
                                if (value!) {
                                  FirebaseFirestore.instance
                                      .collection('todo')
                                      .doc(widget.userId)
                                      .collection('list')
                                      .doc(todo.id)
                                      .update({
                                    'status': 'done',
                                  });
                                } else {
                                  FirebaseFirestore.instance
                                      .collection('todo')
                                      .doc(widget.userId)
                                      .collection('list')
                                      .doc(todo.id)
                                      .update({
                                    'status': 'on-going',
                                  });
                                }
                              },
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete,
                              color: Colors.red,),
                              onPressed: () {
                                FirebaseFirestore.instance
                                    .collection('todo')
                                    .doc(widget.userId)
                                    .collection('list')
                                    .doc(todo.id)
                                    .delete();
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('todo')
                        .doc(widget.userId)
                        .collection('list')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: Center(
                            child: Text('Empty'),
                          ),
                        );
                      }

                      if (snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Center(
                            child: Text('Empty'),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final todo = snapshot.data!.docs[index];

                          if (todo['status'] == 'on-going') {
                            return Container();
                          }

                          return ListTile(
                            title: Text(todo['todo']),
                            onLongPress: () {
                              showTodoUpdateDialog(todo.id);
                            },
                            leading: Checkbox(
                              value: todo['status'] == 'done' ? true : false,
                              onChanged: (value) {
                                if (value!) {
                                  FirebaseFirestore.instance
                                      .collection('todo')
                                      .doc(widget.userId)
                                      .collection('list')
                                      .doc(todo.id)
                                      .update({
                                    'status': 'done',
                                  });
                                } else {
                                  FirebaseFirestore.instance
                                      .collection('todo')
                                      .doc(widget.userId)
                                      .collection('list')
                                      .doc(todo.id)
                                      .update({
                                    'status': 'on-going',
                                  });
                                }
                              },
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete,
                              color: Colors.red,),
                              onPressed: () {
                                FirebaseFirestore.instance
                                    .collection('todo')
                                    .doc(widget.userId)
                                    .collection('list')
                                    .doc(todo.id)
                                    .delete();
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[200],
        onPressed: () {
          showAddTodoDialog(widget.userId);
        },
        child: Text('Add'),
      ),
    );
  }

  // Show add todo dialog
  void showAddTodoDialog(String userId) {
    showDialog(
      context: context,
      builder: (context) {
        final todoController = TextEditingController();
        return AlertDialog(
          title: const Text('Add'),
          content: TextField(
            controller: todoController,
            decoration: const InputDecoration(
              hintText: 'Enter',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('todo')
                    .doc(widget.userId)
                    .collection('list')
                    .add({
                  'todo': todoController.text,
                  'status': 'on-going',
                });
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void showTodoUpdateDialog(String docId) async {
    final todoController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Todo'),
          content: TextField(
            controller: todoController,
            decoration: const InputDecoration(
              hintText: 'Enter todo',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await FirebaseFirestore.instance
                    .collection('todo')
                    .doc(widget.userId)
                    .collection('list')
                    .doc(docId)
                    .update({
                  'todo': todoController.text,
                });
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void updateStatus(String userId, String docId) async {
    await FirebaseFirestore.instance
        .collection('todo')
        .doc(userId)
        .collection('list')
        .doc(docId)
        .update({
      'status': 'completed',
    });
  }
}