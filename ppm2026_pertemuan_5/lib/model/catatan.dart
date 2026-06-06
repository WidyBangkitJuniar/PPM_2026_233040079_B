// MODEL CATATAN
class Catatan {
  // ID DATABASE
  final int? id;

  final String judul;
  final String isi;
  final String kategori;
  final DateTime dibuatPada;

  // CONSTRUCTOR
  Catatan({
    this.id,
    required this.judul,
    required this.isi,
    required this.kategori,
    required this.dibuatPada,
  });

  // OBJECT -> MAP
  Map<String, Object?> toMap() => {
    if (id != null) 'id': id,

    'judul': judul,

    'isi': isi,

    'kategori': kategori,

    'dibuat_pada': dibuatPada.millisecondsSinceEpoch,
  };

  // MAP -> OBJECT
  static Catatan fromMap(Map<String, Object?> map) {
    return Catatan(
      id: map['id'] as int?,

      judul: map['judul'] as String,

      isi: map['isi'] as String,

      kategori: map['kategori'] as String,

      dibuatPada: DateTime.fromMillisecondsSinceEpoch(
        map['dibuat_pada'] as int,
      ),
    );
  }

  // COPY WITH
  Catatan copyWith({String? judul, String? isi, String? kategori}) {
    return Catatan(
      id: id,

      judul: judul ?? this.judul,

      isi: isi ?? this.isi,

      kategori: kategori ?? this.kategori,

      dibuatPada: dibuatPada,
    );
  }
}
