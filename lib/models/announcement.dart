class Announcement {
  final int? id;
  final String title;
  final String content;
  final String date;

  Announcement({
    this.id,
    required this.title,
    required this.content,
    required this.date,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'content': content,
    'date': date,
  };

  factory Announcement.fromMap(Map<String, dynamic> map) => Announcement(
    id: map['id'],
    title: map['title'],
    content: map['content'],
    date: map['date'],
  );
}