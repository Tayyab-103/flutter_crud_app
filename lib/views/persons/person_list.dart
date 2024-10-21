import 'package:crud_api/models/person_model.dart';
import 'package:crud_api/providers/item_provider.dart';
import 'package:crud_api/views/persons/add_person.dart';
import 'package:crud_api/views/persons/edit_screen.dart';
import 'package:flutter/material.dart';

class PersonList extends StatefulWidget {
  const PersonList({super.key});

  @override
  State<PersonList> createState() => _PersonListState();
}

class _PersonListState extends State<PersonList> {
  final ItemProvider provider = ItemProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Persons List'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddPerson(),
                  ));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    borderRadius: BorderRadius.circular(20)),
                child: Center(
                  child: Text("Add Peoples"),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<PersonModel>(
              future: provider.fetchPersons(), // Call the fetch method
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child:
                          CircularProgressIndicator()); // Show loading indicator
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text(
                          'Error: ${snapshot.error}')); // Show error message
                } else if (!snapshot.hasData ||
                    snapshot.data!.record == null ||
                    snapshot.data!.record!.isEmpty) {
                  return const Center(
                      child:
                          Text('No persons found')); // Handle empty data case
                }

                // If data is available, display it in a ListView
                final persons = snapshot.data!.record!;
                return ListView.builder(
                  itemCount: persons.length,
                  itemBuilder: (context, index) {
                    final person = persons[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        height: 350,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Name: ${person.name}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  "African Number: ${person.idNumber}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "Email: ${person.email}",
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              "Sur Name: ${person.surname}",
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              "Birth Date: ${person.birthDate}",
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              "Mobile: ${person.mobile}",
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              "Language: ${person.language}",
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              "Interested: ${person.interests!.join(', ')}",
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditPersonScreen(person: person),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 10),
                                    decoration: BoxDecoration(
                                        color: Colors.greenAccent,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: const Center(
                                      child: Text("Edit"),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    await provider.deleteItem(person.id!);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 10),
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: const Center(
                                      child: Text("Delete"),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
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
    );
  }
}
