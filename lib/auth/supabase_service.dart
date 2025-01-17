import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shopping_list_app/models/shopping_item.dart';

class SupabaseService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Fetch shopping items from Supabase based on user_id
  Future<List<ShoppingItem>> fetchShoppingItemsByUser(String userId) async {
    final response = await _supabase.from('shopping_items')
        .select()
        .eq('user_id', userId); // Filter by user_id

    // If the query fails, return an empty list or handle the error
    if (response == null) {
      print('Error fetching items: No data returned');
      return [];
    }

    List<ShoppingItem> items = [];
    // Convert the response data (List<Map<String, dynamic>>) to ShoppingItem objects
    for (var item in response) {
      items.add(ShoppingItem(
        id: item['id'],
        name: item['name'],
        quantity: item['quantity'],
        priority: item['priority'],
        isPurchased: item['is_purchased'], 
        userId: '',
      ));
    }
    return items;
  }


  // Update shopping item for the specific user
  Future<void> updateShoppingItem(ShoppingItem item) async {
    final response = await _supabase.from('shopping_items').update({
      'name': item.name,
      'quantity': item.quantity,
      'priority': item.priority,
      'is_purchased': item.isPurchased,
    }).eq('id', item.id);

    // Check if the update was successful
    if (response == null) {
      print('Error updating item: No response received');
    } else {
      print('Item updated successfully');
    }
  }

  // Delete shopping item for the specific user
  Future<void> deleteShoppingItem(String itemId) async {
    final response = await _supabase.from('shopping_items').delete().eq('id', itemId);

    // Check if the deletion was successful
    if (response == null) {
      print('Error deleting item: No response received');
    } else {
      print('Item deleted successfully');
    }
  }
}
