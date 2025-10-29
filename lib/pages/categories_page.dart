import 'package:expenses_tracker/databases/database_helper.dart';
import 'package:expenses_tracker/utils/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../databases/category.dart';
import 'dialog_box.dart';
import '../utils/widgets/app_bars.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});
  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  var _categoryNamecontroller = TextEditingController();

  List<Category> _categories = [];
  var _selectedCategory;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    final categories = await _dbHelper.getCategoriesList();
    setState(() {
      _categories = categories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MinimalAppBar(title: 'Categories'),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewCategory,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: Container(
          color: Colors.grey[200],
          child: Container(
            child: _buildCategoryRows(context, _categories),
          )),
    );
  }

  Widget _buildCategoryRows(BuildContext context, categories) {
    return ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25, top: 10),
              child: Container(
                height: 35,
                decoration: BoxDecoration(
                    // color: Colors.black,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.grey.shade300)),
                // child: _buildCategoryCard(categories[index]),
                child: Slidable(
                  endActionPane:
                      ActionPane(motion: const StretchMotion(), children: [
                    CustomSlidableAction(
                      onPressed: (context) {
                        _editCategory(context, categories[index]);
                        setState(() {
                          _selectedCategory = categories[index];
                        });
                      },
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        bottomLeft: Radius.circular(5),
                      ),
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                    CustomSlidableAction(
                      onPressed: (context) {
                        _confirmDelete(context, categories[index]);
                      },
                      backgroundColor: Theme.of(context).colorScheme.error,
                      foregroundColor: Theme.of(context).colorScheme.onError,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(5),
                        bottomRight: Radius.circular(5),
                      ),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 15,
                      ),
                    )
                  ]),
                  child: _buildCategoryCard(categories[index]),
                ),
              ));
        });
  }

  Widget _buildCategoryCard(category) {
    return Row(
      children: [
        SizedBox(width: 10),
        Icon(Icons.category, size: 15),
        SizedBox(width: 10),
        Text(category.categoryName)
      ],
    );
  }

  void _confirmDelete(BuildContext context, category) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete? '),
          content: Text(
              'Are you sure you want to delete this category? This will delete all related transactions & subcategories and cannot be undone'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                _deleteCategory(context, category.categoryId);
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteCategory(BuildContext context, int categoryId) async {
    await _dbHelper.deleteCategory(categoryId);
    if (!mounted) return;
    _fetchCategories();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Category deleted successfully!'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _editCategory(BuildContext context, category) {
    _categoryNamecontroller.text = category.categoryName;
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          dialogTitle: 'Edit Category',
          dialogType: 'CATEGORY',
          taskInputController: _categoryNamecontroller, //.text.toString(),
          // fieldValue: category.categoryName,
          onSave: editCategory,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    ); // Add your logic to add a new category here
  }

  void _addNewCategory() {
    _categoryNamecontroller.text = '';
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          dialogTitle: 'Add New Category',
          taskInputController: _categoryNamecontroller,
          onSave: saveNewCategory,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    ); // Add your logic to add a new category here
  }

  void saveNewCategory() async {
    await _dbHelper.addCategory(_categoryNamecontroller.text
        .replaceAll(RegExp('[^A-Za-z0-9]'), '')
        .trim()
        .capitalize());
    if (!mounted) return;
    _fetchCategories();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Category added successfully!'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
    Navigator.of(context).pop();
  }

  void editCategory() async {
    await _dbHelper.updateCategory(
        _selectedCategory.categoryId,
        _categoryNamecontroller.text
            .replaceAll(RegExp('[^A-Za-z0-9]'), '')
            .trim()
            .capitalize());
    if (!mounted) return;
    _fetchCategories();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Category updated successfully!'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
    Navigator.of(context).pop();
  }
}
