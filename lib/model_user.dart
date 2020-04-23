class User{
  final String namaUser;
  final String nipUser;
  final String jabatan;
  final String bidangUnitKerja; 

  User({
    this.namaUser,
    this.nipUser,
    this.jabatan,
    this.bidangUnitKerja
  });

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      namaUser: json['nama_user'],
      nipUser: json['nip_user'],
      jabatan: json['jabatan'],
      bidangUnitKerja: json['bidang_unit_kerja'], 
    );
  }
}