import 'package:flutter/material.dart';
import '../data/database_helper.dart';
import '../models/user_entity.dart';

class ManajemenUserPage extends StatefulWidget {
  const ManajemenUserPage({super.key});

  @override
  State<ManajemenUserPage> createState() => _ManajemenUserPageState();
}

class _ManajemenUserPageState extends State<ManajemenUserPage> {
  List<UserEntity> listUser = [];

  @override
  void initState() {
    super.initState();
    _refreshData(); // Ambil data pas halaman dibuka
  }

  // Fungsi buat ambil data terbaru dari database
  void _refreshData() async {
    var data = await DatabaseHelper.getInstance().getAllUser();
    setState(() {
      listUser = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manajemen User',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.brown[800],
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [],
      ),
      body: listUser.isEmpty
          ? const Center(child: Text("Belum ada user. Klik + untuk tambah!"))
          : ListView.builder(
              itemCount: listUser.length,
              itemBuilder: (context, index) {
                var user = listUser[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  elevation: 2,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.brown[100],
                      child: const Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text(
                      "ID: ${user.id} - ${user.namaLengkap}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Row(
                      children: [
                        _buildRoleBadge(user.role),
                        const SizedBox(width: 8),
                        Text(user.username),
                      ],
                    ),
                    onTap: () {
                      _showDetailDialog(user);
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            _showFormDialog(user: user);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text(
                                  "Konfirmasi Akses",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                content: const Text(
                                  "Apakah anda yakin menghapus akses?",
                                  style: TextStyle(fontSize: 16),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text(
                                      "tidak",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    onPressed: () async {
                                      await DatabaseHelper.getInstance()
                                          .deleteUser(user.id!);
                                      if (context.mounted) {
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "Data berhasil dihapus permanen",
                                            ),
                                            backgroundColor: Colors.brown,
                                          ),
                                        );
                                      }
                                      _refreshData();
                                    },
                                    child: const Text(
                                      "ya",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.brown,
        onPressed: () {
          _showFormDialog();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // --- POP-UP UNTUK VIEW DETAIL ---
  void _showDetailDialog(UserEntity user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Detail User",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "ID: ${user.id}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Nama: ${user.namaLengkap}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              "Username: ${user.username}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              "Password: ${user.password}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text("Role: ", style: TextStyle(fontSize: 16)),
                _buildRoleBadge(user.role),
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

  Widget _buildRoleBadge(String role) {
    Color bgColor;
    if (role.toLowerCase() == 'admin') {
      bgColor = Colors.lightBlue;
    } else if (role.toLowerCase() == 'karyawan') {
      bgColor = const Color(0xFFF37372);
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
        role,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // --- POP-UP FORM UNTUK TAMBAH & EDIT (ID OTOMATIS) ---
  void _showFormDialog({UserEntity? user}) {
    bool isEdit = user != null;

    // Controller ID dihapus karena sekarang otomatis
    TextEditingController namaController = TextEditingController(
      text: isEdit ? user.namaLengkap : "",
    );
    TextEditingController usernameController = TextEditingController(
      text: isEdit ? user.username : "",
    );
    TextEditingController passwordController = TextEditingController(
      text: isEdit ? user.password : "",
    );
    String selectedRole =
        (isEdit && (user.role == 'Admin' || user.role == 'Karyawan'))
        ? user.role
        : 'Admin';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEdit ? "Edit User" : "Tambah User Baru"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // TextField ID Dihapus agar user tidak bisa ketik manual
              TextField(
                controller: namaController,
                decoration: const InputDecoration(labelText: "Nama Lengkap"),
              ),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: "Username"),
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
              ),
              StatefulBuilder(
                builder: (context, setStateSB) {
                  return DropdownButtonFormField<String>(
                    initialValue: selectedRole,
                    decoration: const InputDecoration(labelText: "Role"),
                    items: const [
                      DropdownMenuItem(value: 'Admin', child: Text('Admin')),
                      DropdownMenuItem(
                        value: 'Karyawan',
                        child: Text('Karyawan'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setStateSB(() {
                          selectedRole = value;
                        });
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
              // Membuat objek UserEntity (ID dikirim null jika Tambah Baru)
              UserEntity userBaru = UserEntity(
                id: isEdit ? user.id : null,
                username: usernameController.text,
                password: passwordController.text,
                namaLengkap: namaController.text,
                role: selectedRole,
              );

              if (isEdit) {
                await DatabaseHelper.getInstance().updateUser(userBaru);
              } else {
                await DatabaseHelper.getInstance().createUser(userBaru);
              }

              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isEdit ? "Data diperbarui" : "User berhasil ditambah",
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              }

              _refreshData(); // Simsalabim! Data langsung muncul di list
            },
            child: const Text("Simpan", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
