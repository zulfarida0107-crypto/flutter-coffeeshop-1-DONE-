import 'package:flutter/material.dart';
import '../data/database_helper.dart';
import '../models/menu_produk_entity.dart';

class MenuProdukPage extends StatefulWidget {
  const MenuProdukPage({super.key});

  @override
  State<MenuProdukPage> createState() => _MenuProdukPageState();
}

class _MenuProdukPageState extends State<MenuProdukPage> {
  List<MenuProdukEntity> listMenu = [];

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() async {
    var data = await DatabaseHelper.getInstance().getAllMenuProduk();
    setState(() {
      listMenu = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Menu Produk',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.brown[800],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: listMenu.isEmpty
          ? const Center(child: Text("Belum ada menu. Klik + untuk tambah!"))
          : ListView.builder(
              itemCount: listMenu.length,
              itemBuilder: (context, index) {
                var menu = listMenu[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  elevation: 2,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.brown[100],
                      child: const Icon(Icons.coffee, color: Colors.brown),
                    ),
                    title: Text(
                      "ID: ${menu.id} - ${menu.namaProduk}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _buildKategoriBadge(menu.kategori),
                            const SizedBox(width: 8),
                            Text("Rp ${menu.harga.toInt()}"),
                          ],
                        ),
                        if (menu.deskripsi != null &&
                            menu.deskripsi!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            menu.deskripsi!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                    onTap: () => _showDetailDialog(menu),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showFormDialog(menu: menu),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmDelete(menu),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.brown,
        onPressed: () => _showFormDialog(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // --- LOGIK KONFIRMASI HAPUS ---
  void _confirmDelete(MenuProdukEntity menu) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Konfirmasi Hapus",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text("Apakah anda yakin menghapus menu?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("tidak", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await DatabaseHelper.getInstance().deleteMenuProduk(menu.id);
              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Data berhasil dihapus permanen"),
                    backgroundColor: Colors.brown,
                  ),
                );
              }
              _refreshData();
            },
            child: const Text("ya", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // --- POP-UP UNTUK VIEW DETAIL ---
  void _showDetailDialog(MenuProdukEntity menu) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Detail Produk",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "ID: ${menu.id}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Nama: ${menu.namaProduk}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              "Harga: Rp ${menu.harga.toInt()}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            if (menu.deskripsi != null && menu.deskripsi!.isNotEmpty) ...[
              Text(
                "Deskripsi: ${menu.deskripsi}",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
            ],
            Row(
              children: [
                const Text("Kategori: ", style: TextStyle(fontSize: 16)),
                _buildKategoriBadge(menu.kategori),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tutup", style: TextStyle(color: Colors.brown)),
          ),
        ],
      ),
    );
  }

  Widget _buildKategoriBadge(String kategori) {
    Color bgColor;
    String lowerKategori = kategori.toLowerCase();
    if (lowerKategori == 'kopi') {
      bgColor = Colors.brown[400]!;
    } else if (lowerKategori == 'non-kopi') {
      bgColor = const Color(0xFF6DA4DE);
    } else if (lowerKategori == 'pastry') {
      bgColor = const Color(0xFFE692CF);
    } else if (lowerKategori == 'kue custom') {
      bgColor = const Color(0xFFAC92ED);
    } else {
      bgColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        kategori,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // --- POP-UP FORM UNTUK TAMBAH & EDIT ---
  void _showFormDialog({MenuProdukEntity? menu}) {
    bool isEdit = menu != null;

    TextEditingController idController = TextEditingController(
      text: isEdit ? menu.id.toString() : "",
    );
    TextEditingController namaController = TextEditingController(
      text: isEdit ? menu.namaProduk : "",
    );
    TextEditingController hargaController = TextEditingController(
      text: isEdit ? menu.harga.toInt().toString() : "",
    );
    TextEditingController deskripsiController = TextEditingController(
      text: isEdit ? (menu.deskripsi ?? "") : "",
    );

    // Perbaikan logika penentuan kategori awal
    List<String> kategoriList = ['Kopi', 'Non-Kopi', 'Pastry', 'Kue Custom'];
    String selectedKategori = (isEdit && kategoriList.contains(menu.kategori))
        ? menu.kategori
        : 'Kopi';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEdit ? "Edit Menu Produk" : "Tambah Menu Baru"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: idController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "ID Produk"),
                enabled:
                    !isEdit, // ID biasanya tidak boleh diedit jika Primary Key
              ),
              TextField(
                controller: namaController,
                decoration: const InputDecoration(labelText: "Nama Produk"),
              ),
              TextField(
                controller: deskripsiController,
                decoration: const InputDecoration(labelText: "Deskripsi"),
                maxLines: 2,
              ),
              TextField(
                controller: hargaController,
                decoration: const InputDecoration(
                  labelText: "Harga (Contoh: 15000)",
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 15),
              StatefulBuilder(
                builder: (context, setStateSB) {
                  return DropdownButtonFormField<String>(
                    initialValue:
                        selectedKategori, // Perbaikan: value bukan Value
                    decoration: const InputDecoration(
                      labelText: "Kategori",
                      border:
                          OutlineInputBorder(), // Perbaikan: border di dalam decoration
                    ),
                    items: kategoriList.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setStateSB(() => selectedKategori = value);
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
            onPressed: () async {
              int parsedId = int.tryParse(idController.text) ?? 0;
              double parsedHarga = double.tryParse(hargaController.text) ?? 0.0;

              MenuProdukEntity data = MenuProdukEntity(
                id: parsedId,
                namaProduk: namaController.text,
                harga: parsedHarga,
                deskripsi: deskripsiController.text,
                kategori: selectedKategori,
              );

              if (isEdit) {
                await DatabaseHelper.getInstance().updateMenuProduk(data);
              } else {
                await DatabaseHelper.getInstance().createMenuProduk(data);
              }

              if (mounted) {
                Navigator.pop(context);
                _refreshData();
              }
            },
            child: const Text("Simpan", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
