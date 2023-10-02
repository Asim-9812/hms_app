class NoticeModel {
  final int noticeID;
  final int noticeType;
  final String type;
  final String description;
  final DateTime entryDate;
  final bool isActive;
  final String language;
  final dynamic flag;

  NoticeModel({
    required this.noticeID,
    required this.noticeType,
    required this.type,
    required this.description,
    required this.entryDate,
    required this.isActive,
    required this.language,
    this.flag,
  });

  factory NoticeModel.fromJson(Map<String, dynamic> json) {
    return NoticeModel(
      noticeID: json['noticeID'],
      noticeType: json['noticeType'],
      type: json['type'],
      description: json['description'],
      entryDate: DateTime.parse(json['entryDate']),
      isActive: json['isActive'],
      language: json['language'],
      flag: json['flag'],
    );
  }
}
