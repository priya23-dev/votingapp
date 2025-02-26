import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';


class ChartScreen extends StatelessWidget {
  const ChartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Election Results"),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('candidates').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var candidates = snapshot.data!.docs;
          int totalVotes = candidates.fold(0, (sum, doc) => sum + (doc['votes'] as int));

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Total Votes Counted
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      const Text("Total votes counted", style: TextStyle(color: Colors.white, fontSize: 16)),
                      Text(
                        NumberFormat.decimalPattern().format(totalVotes),
                        style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // List of Candidates with Progress Bars
                Expanded(
                  child: ListView.builder(
                    itemCount: candidates.length,
                    itemBuilder: (context, index) {
                      var candidate = candidates[index].data();
                      int votes = candidate['votes'];
                      double percentage = totalVotes > 0 ? (votes / totalVotes) * 100 : 0;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.purple[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              candidate['name'],
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            LinearProgressIndicator(
                              value: percentage / 100,
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                              minHeight: 8,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "${percentage.toStringAsFixed(1)}% - Votes: ${NumberFormat.decimalPattern().format(votes)}",
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // Set index for Chart page
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/home');
              break;
            case 1:
              break; // Already on Chart
            case 2:
              Navigator.pushNamed(context, '/favorites');
              break;
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
