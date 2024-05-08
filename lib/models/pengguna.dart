import 'package:hive/hive.dart';
part 'pengguna.g.dart';

@HiveType(typeId: 0)
class Pengguna extends HiveObject {
  @HiveField(0)
  String? id;
  @HiveField(1)
  final String namaLengkap;
  @HiveField(2)
  final String email;
  @HiveField(3)
  final String nomorHandphone;
  @HiveField(4)
  final String alamatRumah;
  @HiveField(5)
  final String username;
  @HiveField(6)
  final String password;

  Pengguna({
    required this.namaLengkap,
    required this.email,
    required this.nomorHandphone,
    required this.alamatRumah,
    required this.username,
    required this.password,
  });
}