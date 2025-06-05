import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool isEditing = false;

  // Initial values (normally you'd fetch this from a backend or local storage)
  String username = 'danielmasi';
  String name = 'Daniel Masi';

  // Controllers
  late TextEditingController usernameController;
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current data
    usernameController = TextEditingController(text: username);
    nameController = TextEditingController(text: name);
  }

  @override
  void dispose() {
    usernameController.dispose();
    nameController.dispose();
    super.dispose();
  }

  void toggleEdit() {
    setState(() {
      if (isEditing) {
        // Save new values when exiting edit mode
        username = usernameController.text;
        name = nameController.text;
      }
      isEditing = !isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        actions: [
          TextButton(
            onPressed: toggleEdit,
            child: Text(
              isEditing ? 'Save' : 'Edit',
              style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            isEditing
                ? TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(labelText: 'Username'),
                  )
                : ListTile(
                    title: const Text('Username'),
                    subtitle: Text(username),
                  ),
            const SizedBox(height: 10),
            isEditing
                ? TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  )
                : ListTile(
                    title: const Text('Name'),
                    subtitle: Text(name),
                  ),
          ],
        ),
      ),
    );
  }
}
