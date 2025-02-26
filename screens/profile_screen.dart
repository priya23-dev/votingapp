import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              // Navigate to Edit Profile Page (Implement separately)
              Navigator.pushNamed(context, '/editProfile');
            },
            child: const Text(
              "Edit",
              style: TextStyle(color: Colors.deepPurple, fontSize: 16),
            ),
          )
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(user?.uid).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;

          return Column(
            children: [
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(userData['profileImage'] ?? ''),
              ),
              const SizedBox(height: 10),
              Text(
                userData['name'] ?? 'User Name',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                userData['role'] ?? 'Voter',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 30),

              // Profile Options
              ListTile(
                leading: const Icon(Icons.help_outline),
                title: const Text("Support"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text("Settings"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.account_circle),
                title: const Text("Change Account"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text("Logout", style: TextStyle(color: Colors.red)),
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3, // Set index for Profile page
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/home');
              break;
            case 1:
              Navigator.pushNamed(context, '/chart');
              break;
            case 2:
              Navigator.pushNamed(context, '/favorites');
              break;
            case 3:
              break; // Already on Profile
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Chart"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favorites"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
