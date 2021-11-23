import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
// ignore_for_file: prefer_const_constructors


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List todoList = [];
  String  _userToDo = "";

  // void  initFirebase() async {
  //   WidgetsFlutterBinding.ensureInitialized();
  //   await Firebase.initializeApp();
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //initFirebase();
    //todoList.addAll(['Заказать лампу', 'Постирать вещи', 'Купить картошку']);
  }

  void  _menuOpen() {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(title: Text('Меню')),
            body: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                  },
                  child: Text('На главную')),
                Padding(padding: EdgeInsets.only(left: 14),)
              ]
            )
          );
      })
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        title: Text('TO DO'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: _menuOpen,
              icon: Icon(Icons.menu)
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('tasks').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return Text('Нет задач');
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  key: Key(snapshot.data!.docs[index].id),
                  child: Card(
                    child: ListTile(
                      title: Text(snapshot.data!.docs[index].get('name')),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          color: Colors.deepOrangeAccent,
                        ),
                        onPressed: () {
                          setState(() {
                            todoList.removeAt(index);
                          });
                        },
                      ),
                    ),
                  ),
                  onDismissed: (direction) {
                  //if (direction == DismissDirection.endToStart)
                    setState(() {
                      todoList.removeAt(index);
                    });
                  },
                );
              }
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrangeAccent,
        onPressed: () {
          _userToDo = "";
          showDialog(context: context, builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Добавить задачу'),
              content: TextField(
                onChanged: (String value) {
                  if (value != "") {
                    _userToDo = value;
                  }
                },
              ),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      if (_userToDo != "") {
                        FirebaseFirestore.instance.collection('tasks').add({'name': _userToDo});
                      }
                      if (_userToDo != "") {
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text('Добавить'))
              ],
            );
          });
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
