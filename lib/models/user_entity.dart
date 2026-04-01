class UserEntity {
  final int? id; // Diubah jadi nullable
  final String username;
  final String password;
  final String namaLengkap;
  final String role;

  UserEntity({
    this.id, // Tidak wajib diisi (required dihapus)
    required this.username,
    required this.password,
    required this.namaLengkap,
    required this.role,
  });

  factory UserEntity.fromMap(Map<String, dynamic> map) {
    return UserEntity(
      id: map[COL_ID_KEY],
      username: map[COL_USERNAME_KEY],
      password: map[COL_PASSWORD_KEY],
      namaLengkap: map[COL_NAMA_LENGKAP_KEY],
      role: map[COL_ROLE_KEY],
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      COL_USERNAME_KEY: username,
      COL_PASSWORD_KEY: password,
      COL_NAMA_LENGKAP_KEY: namaLengkap,
      COL_ROLE_KEY: role,
    };

    // Hanya masukkan ID ke map jika ID tidak null (untuk keperluan Update)
    if (id != null) {
      map[COL_ID_KEY] = id;
    }
    return map;
  }

  static String TABLE_NAME = "user";
  static String COL_ID_KEY = "id";
  static String COL_USERNAME_KEY = "username";
  static String COL_PASSWORD_KEY = "password";
  static String COL_NAMA_LENGKAP_KEY = "nama_lengkap";
  static String COL_ROLE_KEY = "role";
}
