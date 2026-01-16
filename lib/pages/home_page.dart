import 'package:flutter/material.dart';
import '../models/item.dart';
import '../services/storage_service.dart';
import 'add_edit_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final StorageService storage = StorageService();
  List<Item> items = [];

  Future<void> loadData() async {
    items = await storage.getItems();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await loadData();
    if (items.isEmpty) {
      // Add dummy data
      items.addAll([
        Item(title: 'Belajar Flutter', description: 'Mempelajari dasar-dasar Flutter untuk pengembangan aplikasi mobile dan web.'),
        Item(title: 'Proyek CRUD', description: 'Membuat aplikasi CRUD sederhana dengan penyimpanan lokal dan UI yang menarik.'),
        Item(title: 'UI Design', description: 'Merancang antarmuka pengguna yang responsif dan intuitif.'),
        Item(title: 'Database Integration', description: 'Mengintegrasikan database untuk penyimpanan data yang persistent.'),
        Item(title: 'Testing Apps', description: 'Melakukan testing unit dan integrasi untuk memastikan kualitas aplikasi.'),
      ]);
      await storage.saveItems(items);
      setState(() {});
    }
  }

  void deleteItem(int index) async {
    items.removeAt(index);
    await storage.saveItems(items);
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Show about dialog
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddEditPage()),
          );
          loadData();
        },
      ),
      body: items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.note, size: 100, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Tidak ada catatan. Tambahkan catatan baru!',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(items[index].title + index.toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    deleteItem(index);
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      title: Text(
                        items[index].title,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        items[index].description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddEditPage(
                              item: items[index],
                              index: index,
                            ),
                          ),
                        );
                        loadData();
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
