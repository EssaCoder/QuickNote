class NoteRequest {
  NoteRequest({
    this.id,
    required this.title,
    required this.details,
  });

  final String? id;
  final String title;
  final String details;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
        'details': details,
      };

  factory NoteRequest.fromMap(Map<String, dynamic> map) {
    return NoteRequest(
      id: map['id'].toString(),
      title: map['title'].toString(),
      details: map['details'].toString(),
    );
  }
}
