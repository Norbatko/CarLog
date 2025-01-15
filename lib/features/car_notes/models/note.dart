class Note {
  final String id;
  final String userId;
  final String title;
  final String content;
  final String userName;
  final DateTime createdAt;
  final String? replyNoteId;
  final String? replyNoteContent;

  Note({
    this.id = '',
    required this.userId,
    this.title = '',
    this.content = '',
    this.userName = '',
    DateTime? createdAt,
    this.replyNoteId,
    this.replyNoteContent,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Note.fromMap(String id, Map<String, dynamic> data) {
    return Note(
      id: id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      userName: data['userName'] ?? '',
      createdAt: DateTime.parse(data['createdAt'] ?? ''),
      replyNoteId: data['replyNoteId'],
      replyNoteContent: data['replyNoteContent'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'content': content,
      'userName': userName,
      'createdAt': createdAt.toIso8601String(),
      'replyNoteId': replyNoteId,
      'replyNoteContent': replyNoteContent,
    };
  }

  Note copyWith({
    String? id,
    String? userId,
    String? title,
    String? content,
    String? userName,
    DateTime? createdAt,
    String? replyNoteId,
    String? replyNoteContent,
  }) {
    return Note(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      content: content ?? this.content,
      userName: userName ?? this.userName,
      createdAt: createdAt ?? this.createdAt,
      replyNoteId: replyNoteId ?? this.replyNoteId,
      replyNoteContent: replyNoteContent ?? this.replyNoteContent,
    );
  }
}
