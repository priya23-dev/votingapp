import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 1:
        Navigator.pushNamed(context, '/chart');
        break;
      case 2:
        Navigator.pushNamed(context, '/favorites');
        break;
      case 3:
        Navigator.pushNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Votely"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Remaining time for the election",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [Text("124", style: TextStyle(color: Colors.white, fontSize: 24)), Text("Days", style: TextStyle(color: Colors.white))],
                  ),
                  Column(
                    children: [Text("4", style: TextStyle(color: Colors.white, fontSize: 24)), Text("Hours", style: TextStyle(color: Colors.white))],
                  ),
                  Column(
                    children: [Text("30", style: TextStyle(color: Colors.white, fontSize: 24)), Text("Minutes", style: TextStyle(color: Colors.white))],
                  ),
                  Column(
                    children: [Text("29", style: TextStyle(color: Colors.white, fontSize: 24)), Text("Seconds", style: TextStyle(color: Colors.white))],
                  ),
                ],
              ),
            ),
            const Text(
              "Presidential candidates",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: "Search candidates...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder(
                stream: _firestore.collection('candidate').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  var candidates = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: candidates.length,
                    itemBuilder: (context, index) {
                      var candidate = candidates[index].data();

                      // Handle missing or invalid image
                      String imageUrl = candidate['imageUrl'] ?? "";

// Validate if the URL is a proper network image
                      bool isValidUrl = Uri.tryParse(imageUrl)?.hasAbsolutePath ?? false;

                      if (!isValidUrl) {
                        imageUrl = "https://via.placeholder.com/150"; // Placeholder image if URL is invalid
                      }


                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 3,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(10),
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(imageUrl),
                          ),
                          title: Text(candidate['name'] ?? "Unknown Candidate", style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Academic Level: ${candidate['academicLevel'] ?? 'N/A'}", style: const TextStyle(fontSize: 14)),
                              Text("Section: ${candidate['section'] ?? 'N/A'}", style: const TextStyle(fontSize: 14)),
                              Text("Votes: ${candidate['votes'] ?? '0'}", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          trailing: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/candidateProfile', arguments: candidate);
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                            child: const Text("View Profile", style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
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
