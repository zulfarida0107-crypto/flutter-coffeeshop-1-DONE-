import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/database_helper.dart';
import '../models/desain_pesanan_entity.dart';

class DesainPesananPage extends StatefulWidget {
  const DesainPesananPage({super.key});

  @override
  State<DesainPesananPage> createState() => _DesainPesananPageState();
}

class _DesainPesananPageState extends State<DesainPesananPage> {
  List<DesainPesananEntity> listDesain = [];

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  // Asumsi fungsi di database_helper.dart bernama getAllDesainPesanan()
  void _refreshData() async {
    var data = await DatabaseHelper.getInstance().getAllDesainPesanan();
    setState(() {
      listDesain = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Desain Pesanan (Kue)',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.brown[700], // Tema Pink
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: listDesain.isEmpty
          ? const Center(
              child: Text("Belum ada desain pesanan. Klik + untuk tambah!"),
            )
          : ListView.builder(
              itemCount: listDesain.length,
              itemBuilder: (context, index) {
                var desain = listDesain[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  elevation: 2,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.brown[100],
                      child: const Icon(Icons.cake, color: Colors.brown),
                    ),
                    title: Text(
                      "ID: ${desain.id} - ID Pesanan: ${desain.idPesanan}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(desain.keterangan ?? "Tidak ada keterangan"),

                    // FITUR VIEW DETAIL
                    onTap: () {
                      _showDetailDialog(desain);
                    },

                    // Tombol Edit & Delete
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            _showFormDialog(desain: desain);
                          },
                        ),
                        // Tombol Delete
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text(
                                  "Konfirmasi Hapus",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                content: const Text(
                                  "Apakah anda yakin menghapus data ini?",
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
                                          .deleteDesainPesanan(desain.id);
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
  void _showDetailDialog(DesainPesananEntity desain) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Detail Desain Kue",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "ID: ${desain.id} -  ID Pesanan Terkait: ${desain.idPesanan}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text("Link/URL Desain:", style: TextStyle(fontSize: 16)),
            if (desain.fileDesainUrl != null &&
                desain.fileDesainUrl!.isNotEmpty)
              Builder(
                builder: (context) {
                  String url = desain.fileDesainUrl!;
                  // Deteksi apakah ini path file lokal (dari storage HP) atau link web
                  bool isFile =
                      url.startsWith('/') ||
                      url.startsWith('file://') ||
                      url.startsWith('content://') ||
                      url.startsWith('C:');

                  return InkWell(
                    onTap: () async {
                      if (!isFile) {
                        String launchUriStr = url.startsWith('http')
                            ? url
                            : 'https://$url';
                        final uri = Uri.parse(launchUriStr);
                        try {
                          await launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication,
                          );
                        } catch (e) {
                          debugPrint("Tidak dapat membuka URL: $e");
                        }
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: !isFile
                          ? Text(
                              url,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            )
                          : Image.file(
                              File(url),
                              height: 150,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Text(
                                    "Gagal memuat gambar",
                                    style: TextStyle(color: Colors.red),
                                  ),
                            ),
                    ),
                  );
                },
              )
            else
              const Text("-", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text(
              "Keterangan: ${desain.keterangan ?? '-'}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              "Waktu Upload: ${desain.tanggalUpload ?? '-'}",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
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

  // --- POP-UP FORM UNTUK TAMBAH & EDIT ---
  void _showFormDialog({DesainPesananEntity? desain}) {
    bool isEdit = desain != null;

    TextEditingController idController = TextEditingController(
      text: isEdit ? desain.id.toString() : "",
    );
    TextEditingController idPesananController = TextEditingController(
      text: isEdit ? desain.idPesanan.toString() : "",
    );
    TextEditingController urlController = TextEditingController(
      text: isEdit ? desain.fileDesainUrl : "",
    );
    TextEditingController keteranganController = TextEditingController(
      text: isEdit ? desain.keterangan : "",
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEdit ? "Edit Desain Kue" : "Tambah Desain Kue"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: idController,
                decoration: const InputDecoration(labelText: "ID Desain"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: idPesananController,
                decoration: const InputDecoration(labelText: "ID Pesanan"),
                keyboardType: TextInputType.number,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: urlController,
                      decoration: const InputDecoration(
                        labelText: "Upload / Link URL Gambar",
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.paste, color: Colors.blue),
                    tooltip: "Paste Link",
                    onPressed: () async {
                      ClipboardData? data = await Clipboard.getData(
                        Clipboard.kTextPlain,
                      );
                      if (data != null && data.text != null) {
                        urlController.text = data.text!;
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.upload_file, color: Colors.brown),
                    tooltip: "Upload Gambar",
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image = await picker.pickImage(
                        source: ImageSource.gallery,
                      );
                      if (image != null) {
                        urlController.text = image.path;
                      }
                    },
                  ),
                ],
              ),
              TextField(
                controller: keteranganController,
                decoration: const InputDecoration(
                  labelText: "Keterangan (Misal: Tulisan HBD Budi)",
                ),
                maxLines: 2,
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
              String tanggalSekarang = DateTime.now().toString().substring(
                0,
                16,
              );

              int parsedId = int.tryParse(idController.text) ?? 0;

              if (isEdit) {
                await DatabaseHelper.getInstance().updateDesainPesananWithOldId(
                  desain.id,
                  DesainPesananEntity(
                    id: parsedId,
                    idPesanan: int.tryParse(idPesananController.text) ?? 0,
                    fileDesainUrl: urlController.text,
                    keterangan: keteranganController.text,
                    tanggalUpload: desain.tanggalUpload,
                  ),
                );
              } else {
                await DatabaseHelper.getInstance().createDesainPesanan(
                  DesainPesananEntity(
                    id: parsedId,
                    idPesanan: int.tryParse(idPesananController.text) ?? 0,
                    fileDesainUrl: urlController.text,
                    keterangan: keteranganController.text,
                    tanggalUpload: tanggalSekarang,
                  ),
                );
              }
              Navigator.pop(context);
              _refreshData();
            },
            child: const Text("Simpan", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
