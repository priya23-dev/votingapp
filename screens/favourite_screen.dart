import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('favorites').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/no_favourite.png', // Add your empty state image here
                    height: 200,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "No favorites to show",
                    style: TextStyle(fontSize: 16, color: Colors.deepPurple),
                  ),
                ],
              ),
            );
          }

          var favorites = snapshot.data!.docs;
          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              var candidate = favorites[index].data();
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(candidate['imageUrl']),
                  ),
                  title: Text(candidate['name']),
                  subtitle: Text(candidate['party']),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection('favorites')
                          .doc(favorites[index].id)
                          .delete();
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, // Set index for Favorites page
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
              break; // Already on Favorites
            case 3:
              Navigator.pushNamed(context, '/profile');
              break;
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
