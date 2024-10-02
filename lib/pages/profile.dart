import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Edit profile functionality here
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Profile picture
              const Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(
                    'https://tse3.mm.bing.net/th?id=OIP.uNoZ-45m7zOUZk7TeUtSTwHaFj&pid=Api&P=0&h=180',
                  ), // Replace with user's profile picture
                ),
              ),
              const SizedBox(height: 20),

              // User information
              const Text(
                'John Doe',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'johndoe@example.com',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),

              // Account details
              _buildProfileOption(Icons.person, 'Account Details'),
              _buildProfileOption(Icons.notifications, 'Notifications'),
              _buildProfileOption(Icons.lock, 'Privacy Settings'),
              _buildProfileOption(Icons.help, 'Help & Support'),
              _buildProfileOption(Icons.settings, 'Settings'),
              _buildProfileOption(Icons.logout, 'Log Out'),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable method to build profile options
  Widget _buildProfileOption(IconData icon, String title) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent),
        title: Text(
          title,
          style: const TextStyle(fontSize: 18),
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          // Define action for each option here
        },
      ),
    );
  }
}
