import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kecapp/LoginSignup/Widget/utils.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Uint8List? _image;
  String name = "Name not available"; // Default value
  String email = "Email not available"; // Default value
  late TextEditingController nameController;
  late TextEditingController emailController;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    fetchUserData(); // Fetch user data when the widget initializes
    nameController = TextEditingController();
    emailController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }


  void selectImage() async{
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
    
  }

  Future<void> fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

        if (snapshot.exists) {
          setState(() {
            name = snapshot['name'] ?? "Name not available"; // Fetch name
            email = snapshot['email'] ?? "Email not available"; // Fetch email
            nameController.text = name; // Initialize controller with fetched data
            emailController.text = email; // Initialize controller with fetched data
          });
        }
      } catch (e) {
        print("Error fetching user data: $e");
      }
    }
  }

  void _toggleEdit() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  Future<void> _saveChanges() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'name': nameController.text,
          'email': emailController.text,
        });

        setState(() {
          name = nameController.text;
          email = emailController.text;
          isEditing = false; // Exit edit mode
        });
      } catch (e) {
        print("Error updating user data: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _toggleEdit,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [

              const SizedBox(height: 20),
              //profile,
              Stack(
                children: [
                  const CircleAvatar(
                    radius: 64,
                    backgroundImage: NetworkImage('https://tse4.mm.bing.net/th?id=OIP.S171c9HYsokHyCPs9brbPwHaGP&pid=Api&P=0&h=180'),
                  ),
                  Positioned(bottom: -10,left: 80,child: IconButton(onPressed: selectImage, icon: const Icon(Icons.add_a_photo)),),
                  
                ],
              ),
              const SizedBox(height: 20),
              // User information
              isEditing
                  ? Column(
                      children: [
                        TextField(
                          controller: nameController,
                          decoration: const InputDecoration(labelText: 'Name'),
                        ),
                        TextField(
                          controller: emailController,
                          decoration: const InputDecoration(labelText: 'Email'),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Text(
                          name.isNotEmpty ? name : 'Name not available',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          email.isNotEmpty ? email : 'Email not available',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
              const SizedBox(height: 20),
              if (isEditing)
                ElevatedButton(
                  onPressed: _saveChanges,
                  child: const Text('Save Changes'),
                ),
              const SizedBox(height: 20),
              // Account details
              _buildProfileOption(Icons.logout, 'Log Out', _logout),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable method to build profile options
  Widget _buildProfileOption(IconData icon, String title, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent),
        title: Text(
          title,
          style: const TextStyle(fontSize: 18),
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }

  

  void _logout() {
    // Implement logout functionality
    FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed('/login'); // Replace with your login route
    print("User logged out");
  }
}
