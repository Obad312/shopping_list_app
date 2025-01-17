class ShoppingItem {
  String id; // UUID for the item
  String name;
  int quantity;
  String priority; // Low, Medium, High
  bool isPurchased;
  String userId; // Added user_id field

  ShoppingItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.priority,
    this.isPurchased = false,
    required this.userId, // Ensure user_id is passed to the constructor
  });
}
