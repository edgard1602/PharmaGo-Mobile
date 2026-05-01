enum TypeSignalement {
  horairesIncorrects('Horaires incorrects'),
  telephoneIncorrect('Téléphone incorrect'),
  pharmacieFermee('Pharmacie fermée'),
  adresseIncorrecte('Adresse incorrecte'),
  autre('Autre');

  const TypeSignalement(this.label);
  final String label;
}

class Signalement {
  const Signalement({
    required this.pharmacieId,
    required this.type,
    required this.description,
  });

  final int pharmacieId;
  final TypeSignalement type;
  final String description;

  Map<String, dynamic> toJson() => {
        'pharmacieId': pharmacieId,
        'type': type.name,
        'description': description,
      };
}