import 'package:flutter/material.dart';
import 'package:shopping_list_app/auth/supabase_service.dart';
import 'package:shopping_list_app/models/shopping_item.dart';
import 'package:shopping_list_app/screens/add_item_screen.dart';
import 'package:shopping_list_app/theme.dart'; // Import theme for consistent styling
import 'package:shopping_list_app/screens/login_screen.dart'; // Import LoginPage

class ShoppingListScreen extends StatefulWidget {
  final String userId;  // Expecting the userId to be passed

  const ShoppingListScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _ShoppingListScreenState createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  final List<ShoppingItem> _items = [];
  final List<ShoppingItem> _purchasedItems = [];
  bool _isPurchasedVisible = false;

  // Fetch items from Supabase for the specific user
  void _fetchItems() async {
    final items = await _supabaseService.fetchShoppingItemsByUser(widget.userId);  // Use userId for filtering
    
    setState(() {
      _items.clear();
      _purchasedItems.clear();
      _items.addAll(items.where((item) => !item.isPurchased));
      _purchasedItems.addAll(items.where((item) => item.isPurchased));
    });
  }

// Add an item
void _addItem(ShoppingItem item) {
  // Directly use the _addItem function instead of calling _supabaseService.addShoppingItem(item)
  _fetchItems();
}

// Mark an item as purchased
// Mark an item as purchased
void _togglePurchase(ShoppingItem item) {
  // Update the purchase status in the database
  _supabaseService.updateShoppingItem(item).then((_) {
    // Once the update is successful, update the UI immediately
    setState(() {
      item.isPurchased = !item.isPurchased;  // Toggle the purchase status

      // Move the item between active and purchased lists
      if (item.isPurchased) {
        _items.remove(item); // Remove from active items
        _purchasedItems.add(item); // Add to purchased items
      } else {
        _purchasedItems.remove(item); // Remove from purchased items
        _items.add(item); // Add to active items
      }
    });

    // Show a success message
    _showSuccessMessage('Item moved to purchased! 🎉');
  }).catchError((e) {
    // If there is an error, show an error message
    _showErrorMessage('Error toggling item purchase status');
  });
}

// Show error message for toggling purchase status
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


  // Delete an item
  void _deleteItem(ShoppingItem item) {
    _supabaseService.deleteShoppingItem(item.id);
    _fetchItems();
    _showSuccessMessage('Item deleted! 😔');
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

// Edit an item
void _editItem(ShoppingItem item) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return EditItemModal(
        item: item,
        onSave: (updatedItem) {
          _supabaseService.updateShoppingItem(updatedItem);
          
          // Update the item in the UI directly
          setState(() {
            int index = _items.indexWhere((element) => element.id == updatedItem.id);
            if (index != -1) {
              _items[index] = updatedItem;  // Update the item in the list
            }
          });
          
          Navigator.pop(context); // Close the modal
          _showSuccessMessage('Item updated successfully! ✏️');
        },
      );
    },
  );
}



  @override
  void initState() {
    super.initState();
    _fetchItems(); // Fetch items on initial load
  }

  @override
  Widget build(BuildContext context) {
    // Grouping items by priority
    final groupedItems = {
      'Low': _items.where((item) => item.priority == 'Low').toList(),
      'Medium': _items.where((item) => item.priority == 'Medium').toList(),
      'High': _items.where((item) => item.priority == 'High').toList(),
    };

    // Grouping purchased items by priority
    final groupedPurchasedItems = {
      'Low': _purchasedItems.where((item) => item.priority == 'Low').toList(),
      'Medium': _purchasedItems.where((item) => item.priority == 'Medium').toList(),
      'High': _purchasedItems.where((item) => item.priority == 'High').toList(),
    };

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
          child: Column(
            children: [
              // Left-side Logout Icon
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(Icons.logout, color: Colors.white),
                      onPressed: () {
                        // Navigate to LoginPage on logout
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                        );
                      },
                      iconSize: 30.0,
                    ),
                  ),
                  const SizedBox(height: 20),

              // Shopping Cart Icon
              Icon(
                Icons.shopping_cart,
                size: 100,
                color: Colors.white.withOpacity(0.8),
              ),
              const SizedBox(height: 20),
               // "Your Items" Title
                const Text(
                  'QaderSho',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
              // Purchased Items Toggle Icon
              IconButton(
                icon: Icon(
                  _isPurchasedVisible ? Icons.expand_less : Icons.expand_more,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _isPurchasedVisible = !_isPurchasedVisible;
                  });
                },
              ),
              if (_isPurchasedVisible) ...[
                const Divider(color: Colors.white, thickness: 1),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Purchased Items',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: groupedPurchasedItems.entries.map((entry) {
                      final priority = entry.key;
                      final items = entry.value;
                      if (items.isEmpty) return SizedBox.shrink();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              priority,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          ...items.map((item) {
                            return // Updated Card for Purchased Items (blue background)
                              Card(
                                margin: const EdgeInsets.symmetric(vertical: 8.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                elevation: 5.0,
                                color: const Color.fromARGB(142, 124, 139, 91),  // Blue background color for the purchased item
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(16.0),
                                  title: Text(
                                    item.name,
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),  // White text color
                                  ),
                                  subtitle: Text(
                                    'Quantity: ${item.quantity}, Priority: ${item.priority}',
                                    style: const TextStyle(color: Colors.white),  // White text color
                                  ),
                                ),
                              );
                          }).toList(),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],

             // Active Items List (Grouped by Priority)
                Expanded(
                  child: ListView(
                    children: groupedItems.entries.map((entry) {
                      final priority = entry.key;
                      final items = entry.value;
                      if (items.isEmpty) return SizedBox.shrink();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              priority,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          ...items.map((item) {
                            return Dismissible(
                              key: Key(item.id),
                              direction: DismissDirection.endToStart,
                              confirmDismiss: (_) async {
                                return await _showDeleteConfirmationDialog(item);
                              },
                              onDismissed: (_) => _deleteItem(item),
                              child: Card(
                                margin: const EdgeInsets.symmetric(vertical: 8.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                elevation: 5.0,
                                color: const Color.fromARGB(149, 156, 143, 132),  // Blue background color for the active item
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(16.0),
                                  title: Text(
                                    item.name,
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                  subtitle: Text(
                                    'Quantity: ${item.quantity}, Priority: ${item.priority}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(
                                      item.isPurchased ? Icons.check_box : Icons.check_box_outline_blank,
                                      color: Colors.white,
                                    ),
                                    onPressed: () => _togglePurchase(item),
                                  ),
                                  onLongPress: () => _editItem(item), // Edit when long pressed
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      );
                    }).toList(),
                  ),
                ),

            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newItem = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddItemScreen()),
          );
          if (newItem != null) {
            _addItem(newItem);
          }
        },
        child: const Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 57, 94, 134),
      ),
    );
  }

  // Delete confirmation dialog
  Future<bool> _showDeleteConfirmationDialog(ShoppingItem item) async {
    return await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Are you sure?'),
        content: Text('Do you want to delete "${item.name}"?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    ) ?? false;
  }
}

class EditItemModal extends StatelessWidget {
  final ShoppingItem item;
  final Function(ShoppingItem) onSave;
  final TextEditingController _nameController;
  final TextEditingController _quantityController;
  String _priority;

  EditItemModal({
    Key? key,
    required this.item,
    required this.onSave,
  })  : _nameController = TextEditingController(text: item.name),
        _quantityController = TextEditingController(text: item.quantity.toString()),
        _priority = item.priority,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: "Item Name"),
          ),
          const SizedBox(height: 16.0),
          TextField(
            controller: _quantityController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: "Quantity"),
          ),
          const SizedBox(height: 16.0),
          DropdownButton<String>(
            value: _priority,
            items: ['Low', 'Medium', 'High']
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (value) {
              _priority = value!;
            },
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              final updatedItem = ShoppingItem(
                id: item.id,
                name: _nameController.text,
                quantity: int.tryParse(_quantityController.text) ?? 0,
                priority: _priority,
                isPurchased: item.isPurchased,
                userId: '',
              );
              onSave(updatedItem);
            },
            child: const Text("Save Changes"),
            style: ButtonStyles.elevatedButtonStyle(),
          ),
        ],
      ),
    );
  }
}
