import 'package:flutter/material.dart';
import 'package:shopping_list_app/models/shopping_item.dart'; // Import the ShoppingItem model
import 'package:supabase_flutter/supabase_flutter.dart'; // For interacting with Supabase
import 'package:shopping_list_app/theme.dart'; // Import theme for consistent styling

class AddItemScreen extends StatefulWidget {
  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  String _priority = 'Low';

  // Function to add shopping item without image
  Future<void> _addItem() async {
    final quantity = int.tryParse(_quantityController.text) ?? 0; // Default to 0 if parsing fails

    // Fetch the current user's ID
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      _showErrorMessage('User not authenticated');
      return;
    }

    // Create a new shopping item with the user_id
    final newItem = ShoppingItem(
      id: '',  // Auto-generated by Supabase
      name: _nameController.text,
      quantity: quantity,  // Ensure quantity is an int
      priority: _priority,
      isPurchased: false,
      userId: userId, // Include user_id for each item
    );

    try {
      // Insert the new item into the database
      final response = await Supabase.instance.client.from('shopping_items').insert({
        'name': newItem.name,
        'quantity': newItem.quantity, // Ensure this is an int
        'priority': newItem.priority,
        'is_purchased': newItem.isPurchased,
        'user_id': newItem.userId, // Include user_id in the insert
      }).select();  // Use select() to get the inserted data back

      // Check if the response contains error data
      if (response != null && response.error == null) {
        print('Item added successfully');
        Navigator.pop(context, newItem); // Return to the previous screen
        _showSuccessMessage('Item added successfully! 🎉');
      } else {
        // Log the error message from Supabase response
        print('Error adding item: ${response?.error?.message ?? "Unknown error"}');
        _showErrorMessage('Error adding item: ${response?.error?.message ?? "Unknown error"}');
      }
    } catch (e) {
      // Handle any other unexpected errors
      print('Unexpected error: $e');
      _showErrorMessage('Unexpected error: $e');
    }
  }
  
  // Show success message for actions (add, delete, move to purchased, etc.)
  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white), // Success icon
            const SizedBox(width: 10),
            Expanded(child: Text(message, style: const TextStyle(color: Colors.white))),
          ],
        ),
        backgroundColor: Colors.green, // Success color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Rounded corners
        ),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Show error message for actions
  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white), // Error icon
            const SizedBox(width: 10),
            Expanded(child: Text(message, style: const TextStyle(color: Colors.white))),
          ],
        ),
        backgroundColor: Colors.redAccent, // Error color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Rounded corners
        ),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        duration: const Duration(seconds: 3),
      ),
    );
  }

@override
Widget build(BuildContext context) {
  // Check if the keyboard is open using MediaQuery
  final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

  return Scaffold(
    body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryColor, AppColors.secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Back Icon
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context); // Navigate back to the previous screen
                  },
                  iconSize: 30.0,
                ),
              ),
              const SizedBox(height: 20),

              // Shopping Cart Icon in the middle
              Center(
                child: Icon(
                  Icons.shopping_cart,
                  size: 100,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 20),

              // Add Item Title
              const Text(
                'Add Item',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Naturally',
                ),
              ),
              const SizedBox(height: 20),

              // Container with a fixed height of 600
              Container(
                height: 600, // Fixed height for the content
                child: Column(
                  children: [
                    // Item Name TextField with transparent background
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: "Item Name",
                          labelStyle: const TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: const Color.fromARGB(78, 150, 135, 135), // Transparent background
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20), // Angled curve
                            borderSide: const BorderSide(color: AppColors.primaryColor),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.primaryColor),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),

                    // Quantity TextField with transparent background
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _quantityController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Quantity",
                          labelStyle: const TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: const Color.fromARGB(78, 150, 135, 135), // Transparent background
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20), // Angled curve
                            borderSide: const BorderSide(color: AppColors.primaryColor),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.primaryColor),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),

                    // Priority Dropdown
                    DropdownButton<String>(
                      value: _priority,
                      items: ['Low', 'Medium', 'High']
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _priority = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16.0),

                    // Add Item Button
                    ElevatedButton(
                      onPressed: _addItem,
                      child: const Text('Add Item'),
                      style: ButtonStyles.elevatedButtonStyle(),
                    ),
                    // Add a small space to ensure the UI adjusts when keyboard opens
                    if (keyboardVisible) const SizedBox(height: 50),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}


}


extension on PostgrestList {
  get error => null;
}
