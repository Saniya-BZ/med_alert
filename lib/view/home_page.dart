import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'notifications.dart';
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final CollectionReference _cruddetails =
  FirebaseFirestore.instance.collection('cruddetails');
  final TextEditingController _nameController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onNotificationCreatedMethod:
      NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod:
      NotificationController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod:
      NotificationController.onDismissActionReceivedMethod,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _create();
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        title: const Text('Medicines Expiry Alert System'),
      ),
      body: StreamBuilder(
        stream: _cruddetails.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapShot) {
          if (streamSnapShot.hasData) {
            return ListView.builder(
              itemCount: streamSnapShot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                streamSnapShot.data!.docs[index];
                return Card(
                  margin: const EdgeInsets.all(13),
                  child: ListTile(
                    title: Text(documentSnapshot['name']),
                    subtitle: Text(
                      'Expiry Date: ${DateFormat.yMd().format(documentSnapshot['date'].toDate())}',
                    ),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              _update(documentSnapshot);
                            },
                            icon: const Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () {
                              _delete(documentSnapshot.id);
                            },
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ),
                );

              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Future<void> _update(DocumentSnapshot<Object?> documentSnapshot) async {
    if (documentSnapshot != null) {
      _nameController.text = documentSnapshot['name'];
      _selectedDate = documentSnapshot['date'].toDate();
    }
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text('Selected Date: ${DateFormat.yMd().format(_selectedDate)}'),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () {
                      _selectDate(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final String name = _nameController.text;
                  if (name.isNotEmpty) {
                    await _cruddetails.doc(documentSnapshot.id).update({
                      "name": name,
                      "date": _selectedDate,
                    });
                    _nameController.text = '';
                    Navigator.pop(context); // Close the bottom sheet after updating
                  }
                },
                child: const Text("Update"),
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> _create() async {
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text('Selected Date: ${DateFormat.yMd().format(_selectedDate)}'),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () {
                      _selectDate(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final String name = _nameController.text;
                  if (name.isNotEmpty) {
                    await _cruddetails.add({"name": name, "date": _selectedDate});
                    _nameController.text = '';
                    Navigator.pop(context); // Close the bottom sheet after creating
                  }

                  DateTime scheduledDate = DateTime.now().add(const Duration(seconds: 3));

                  await AwesomeNotifications().createNotification(
                    content: NotificationContent(
                      id: 1,
                      channelKey: "basic_channel",
                      title: "Hello World! no world",
                      body: "Yay! I have scheduled notifications working now!",
                    ),
                    schedule: NotificationInterval(
                      interval: 5,
                      repeats: false,
                      //  exact: true,
                      timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
                    ),
                  );
                },
                child: const Text("Create"),
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> _delete(String productId) async {
    await _cruddetails.doc(productId).delete();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("You have deleted")));
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
}