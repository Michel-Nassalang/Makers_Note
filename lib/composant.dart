class Composant {
  int id;
  String titre;
  String note;
  bool isFavorite;
  bool isVocal;

  Composant(this.id, this.titre,  this.note, this.isFavorite, this.isVocal);

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'titre': titre,
      'note': note,
      'isFavorite': isFavorite,

    };
  }

  factory Composant.fromMap(Map<String, dynamic> map) => new Composant(
      map['id'],
      map['titre'],
      map['note'],
      map['isFavorite'] == 1,
      map['isVocal'] == 1
    );
}

class takeArguments {
  final int id;
  final Composant compo;

  takeArguments(this.id, this.compo);
}
