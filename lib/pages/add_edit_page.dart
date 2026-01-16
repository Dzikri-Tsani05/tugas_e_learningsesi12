import 'package:flutter/material.dart';
import '../models/item.dart';
import '../services/storage_service.dart';

class AddEditPage extends StatefulWidget {
  final Item? item;
  final int? index;

  const AddEditPage({super.key, this.item, this.index});

  @override
  State<AddEditPage> createState() => _AddEditPageState();
}

class _AddEditPageState extends State<AddEditPage> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final StorageService storage = StorageService();

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      titleController.text = widget.item!.title;
      descController.text = widget.item!.description;
    }
  }

  void save() async {
    if (titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Judul tidak boleh kosong')),
      );
      return;
    }
    final items = await storage.getItems();
    final newItem = Item(
      title: titleController.text,
      description: descController.text,
    );

    if (widget.index != null) {
      items[widget.index!] = newItem;
    } else {
      items.add(newItem);
    }

    await storage.saveItems(items);
    if (mounted) {
      Navigator.pop(context);
    }
  }

  void delete() async {
    if (widget.index != null) {
      final items = await storage.getItems();
      items.removeAt(widget.index!);
      await storage.saveItems(items);
    }
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah / Edit Data')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Judul',
                prefixIcon: Icon(Icons.title),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: descController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Deskripsi',
                prefixIcon: Icon(Icons.description),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: save,
                icon: Icon(Icons.save),
                label: Text('Simpan'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            if (widget.item != null) ...[
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: delete,
                  icon: Icon(Icons.delete),
                  label: Text('Hapus'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
