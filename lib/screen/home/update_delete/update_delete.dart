import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePageUD extends StatelessWidget {
  const HomePageUD({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const id = 'GVCjG5SS1AdWGhjaye0Q';
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUD OPERATION'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // update
            ElevatedButton(
              onPressed: () {
                final docUser = FirebaseFirestore.instance
                    .collection('users')
                    .doc('GVCjG5SS1AdWGhjaye0Q');

                docUser.update({'name': 'emma', 'age': '34'});
              },
              child: const Text('Update'),
            ),
            // delete
            ElevatedButton(
              onPressed: () {
                 final docUser = FirebaseFirestore.instance
                    .collection('users')
                    .doc('GVCjG5SS1AdWGhjaye0Q'); 

                    docUser.delete();
              },
              child: const Text('delete'),
            )
          ],
        ),
      ),
    );
  }
}
