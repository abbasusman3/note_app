import 'package:anab_notes/crud.dart';
import 'package:anab_notes/screen_update_add_record.dart';
import 'package:flutter/material.dart';
// import 'package:anab_notes/anab_notes.dart'; // Assuming this is your database operations class
import 'model_class.dart';
// import 'screen_add_update_record.dart';

class ScreenDashboard extends StatefulWidget {
  const ScreenDashboard({super.key});

  @override
  State<ScreenDashboard> createState() => _ScreenDashboardState();
}

class _ScreenDashboardState extends State<ScreenDashboard> {
  DataStudent dataStudent = DataStudent(); // DataStudent class instance
  List<ModelStudent> list = []; // List to hold student records

  @override
  void initState() {
    super.initState();
    _fetchAllRecords(); // Fetch the records when the screen is initialized
  }

  // Fetch all records from the database
  void _fetchAllRecords() async {
    List<ModelStudent> records = await dataStudent.getAllRecords();
    setState(() {
      list = records; // Update the list with the fetched records
    });
  }

  // Delete a student record
  void _deleteRecord(int id) async {
    bool result = await dataStudent.deleteRecord(id);
    if (result) {
      // Show a confirmation message and refresh the list
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Record deleted successfully")),
      );
      _fetchAllRecords(); // Refresh the list after deletion
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to delete record")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Dashboard"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to the Add/Update screen and wait for the result
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ScreenAddUpdateRecord(),
            ),
          );
          _fetchAllRecords(); // Refresh the list after adding/updating a record
        },
        child: const Icon(Icons.add),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, int index) {
            return ListTile(
              onTap: () async {
                // Navigate to the Add/Update screen to edit the record
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ScreenAddUpdateRecord(
                      modelStudent: list[index],
                    ),
                  ),
                );
                _fetchAllRecords(); // Refresh the list after updating a record
              },
              title: Text(list[index].name),
              subtitle: Text(list[index].phoneNumber),
              trailing: GestureDetector(
                onTap: () {
                  // Ask for confirmation before deleting a record
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Delete Record"),
                      content: const Text("Are you sure you want to delete this record?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Close the dialog
                          },
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            _deleteRecord(list[index].id!); // Delete the record
                            Navigator.pop(context); // Close the dialog
                          },
                          child: const Text("Delete"),
                        ),
                      ],
                    ),
                  );
                },
                child: const Icon(Icons.delete, color: Colors.red),
              ),
            );
          },
        ),
      ),
    );
  }
}
