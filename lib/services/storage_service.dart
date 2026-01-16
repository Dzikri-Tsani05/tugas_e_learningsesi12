import '../models/item.dart';

class StorageService {
  static List<Item> _items = [];

  Future<List<Item>> getItems() async {
    return _items;
  }

  Future<void> saveItems(List<Item> items) async {
    _items = List.from(items);
  }
}
