class Comentario {

  String id;
  String comentario;
  String uid;
  String? photoUrl;
  int date;
  List<String> likes;
  String displayName;

  Comentario({
    required this.id,
    required this.comentario,
    required this.uid,
    this.photoUrl,
    required this.date,
    required this.likes,
    required this.displayName,
  });

  factory Comentario.fromJson(Map<String, dynamic> json) => Comentario(
    id: json["id"],
      comentario: json["comentario"],
      uid: json["uid"],
      photoUrl: json["photoURL"] == null ? null : json["photoURL"],
      date: json["date"],
      likes: List<String>.from(json["likes"].map((x) => x)),
      displayName: json["displayName"],
  );

  Map<String, dynamic> toJson() => {
      "id": id,
      "comentario": comentario,
      "uid": uid,
      "photoURL": photoUrl == null ? null : photoUrl,
      "date": date,
      "likes": List<dynamic>.from(likes.map((x) => x)),
      "displayName": displayName,
  };
}

class Respuestas {
  Respuestas({
    required this.respuesta1,
    required this.respuesta2,
    required this.respuesta3,
    required this.respuesta4,
  });

  String respuesta1;
  String respuesta2;
  String respuesta3;
  String respuesta4;

  factory Respuestas.fromJson(Map<String, dynamic> json) => Respuestas(
    respuesta1: json["respuesta1"],
    respuesta2: json["respuesta2"],
    respuesta3: json["respuesta3"],
    respuesta4: json["respuesta4"],
  );

  Map<String, dynamic> toJson() => {
    "respuesta1": respuesta1,
    "respuesta2": respuesta2,
    "respuesta3": respuesta3,
    "respuesta4": respuesta4,
  };
}
