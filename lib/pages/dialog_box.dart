import "package:flutter/material.dart";
import '../databases/database_helper.dart';

class DialogBox extends StatefulWidget {
  final TextEditingController taskInputController;
  final VoidCallback onSave;
  final VoidCallback onCancel;
  final String? dialogTitle;
  final String dialogType;

  const DialogBox({
    super.key,
    required this.taskInputController,
    required this.onSave,
    required this.onCancel,
    this.dialogTitle,
    this.dialogType = 'CATEGORY',
  });

  @override
  State<DialogBox> createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _categories = [];
  int? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[300],
      content: SizedBox(
        height: widget.dialogType == 'CATEGORY' ? 155 : 220,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              widget.dialogTitle ?? "Add New Category",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              textAlign: TextAlign.center,
            ),
            _buildBody(context),
            const SizedBox(height: 10),
            _buildButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (widget.dialogType == 'CATEGORY') {
      return TextField(
        autofocus: true,
        maxLength: 25,
        controller: widget.taskInputController,
        decoration: const InputDecoration(
          border: UnderlineInputBorder(),
          hintText: "Enter Category name",
          hintStyle: TextStyle(color: Colors.grey),
        ),
      );
    } else {
      return FutureBuilder(
        future: _loadCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                DropdownButtonFormField<int>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: _categories.map((category) {
                    return DropdownMenuItem<int>(
                      value: category['categoryId'],
                      child: Text(category['categoryName']),
                    );
                  }).toList(),
                  onChanged: (int? newValue) {
                    setState(() {
                      _selectedCategory = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a category.';
                    }
                    return null;
                  },
                ),
                TextField(
                  autofocus: true,
                  maxLength: 25,
                  controller: widget.taskInputController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText: "Enter SubCategory name",
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      );
    }
  }

  Widget _buildButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: widget.onCancel,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade300,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
          ),
          child: const Text('Cancel'),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: widget.onSave,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade500,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
          ),
          child: const Text('Save'),
        ),
      ],
    );
  }

  Future<void> _loadCategories() async {
    final categories = await _dbHelper.getCategories();
    setState(() {
      _categories = categories;
    });
  }
}
