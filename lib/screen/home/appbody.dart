import 'package:flutter/material.dart';

import 'homepage.dart';

class AddUserScreen extends StatelessWidget {
  const AddUserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    final nameController = TextEditingController();
    final ageController = TextEditingController();
    final sexController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add User'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            decoration: decoration('Name'),
            controller: nameController,
          ),
          const SizedBox(height: 24),
          TextField(
            decoration: decoration('age'),
            controller: ageController,
          ),
          const SizedBox(height: 24),
          TextField(
            decoration: decoration('sex'),
            controller: sexController,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              createUser(
                name: nameController.text,
                age: int.parse(ageController.text),
                sex: sexController.text,
              );
            },
            child: const Text('create'),
          )
        ],
      ),
    );
  }

  InputDecoration decoration(String label) => InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      );
}
