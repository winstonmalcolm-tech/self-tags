class Note{
  final String title;
  final String body;
  final String createdDate;

  Note({required this.title, required this.body, required this.createdDate});

  factory Note.empty() {
    return Note(title: "", body: "", createdDate: "");
  }

  factory Note.fromJson(Map<String,dynamic> data) {
    return Note(title: data["title"], body: data["body"], createdDate: data["createdDate"]);
  }

  Map<String, dynamic> toMap() {
    return <String,dynamic>{
      "title": title,
      "body": body,
      "createdDate": createdDate
    };
  }
}