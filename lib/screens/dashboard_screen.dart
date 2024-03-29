import 'package:ahsan_online_bazar/screens/product_list_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        centerTitle: true,
        title: const Text(
          'Dashboard',
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: categories.snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          print(snapshot.toString());
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }

          if (snapshot.hasData) {
            // List<Map<String, dynamic>> listOfCategories =
            //     snapshot.data as List<Map<String, dynamic>>;

            List listOfCategories = snapshot.data?.docs
                .map((e) => e.data() as Map<String, dynamic>?)
                .toList();

            print('**************************');
            print(listOfCategories.length);

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                  itemCount: listOfCategories.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> category = listOfCategories[index];
                    return InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return ProductListScreen(category: category);
                        }));
                      },
                      child: Card(
                        color: Colors.orangeAccent,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 100,
                                height: 100,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      category['image'],
                                      fit: BoxFit.cover,
                                    )),
                              ),
                              const Gap(16),
                              Text(
                                category['title'],
                                style: const TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
