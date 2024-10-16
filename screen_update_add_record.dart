import 'package:anab_notes/model_class.dart';
import 'package:anab_notes/sqflite.dart';
import 'package:flutter/material.dart';
// import 'package:practiced_crud/crud_operations.dart';

// import 'package:practiced_crud/model_class.dart';

class ScreenAddUpdateRecord extends StatefulWidget {
  final ModelStudent? modelStudent;

  ScreenAddUpdateRecord({super.key, this.modelStudent});

  @override
  State<ScreenAddUpdateRecord> createState() => _ScreenAddUpdateRecordState();
}

class _ScreenAddUpdateRecordState extends State<ScreenAddUpdateRecord> {
  DataStudent dataStudent = DataStudent();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.modelStudent != null) {
      _nameController.text = widget.modelStudent!.name;
      _phoneController.text = widget.modelStudent!.phoneNumber;
      _cityController.text = widget.modelStudent!.city;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
        Text(widget.modelStudent != null ? "Update Record" : "Add Record"),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            TextFormField(
              controller: _cityController,
              decoration: InputDecoration(labelText: 'City'),
            ),
            ElevatedButton(
              onPressed: () async {
                await dataStudent.initializeDatabase();

                var model = ModelStudent(
                  id: widget.modelStudent?.id, // ID for update or null for new
                  name: _nameController.text,
                  phoneNumber: _phoneController.text,
                  city: _cityController.text,
                );

                bool result;
                if (widget.modelStudent != null) {
                  // Update record
                  result = await dataStudent.updateRecord(model);
                } else {
                  // Add new record
                  result = await dataStudent.addRecord(model);
                }

                // Clear fields after adding/updating
                _nameController.clear();
                _phoneController.clear();
                _cityController.clear();

                // Navigate back to the previous screen with result
                Navigator.pop(context, result);
              },
              child: Text(widget.modelStudent != null ? "Update" : "Add"),
            ),
          ],
        ),
      ),
    );
  }
}
