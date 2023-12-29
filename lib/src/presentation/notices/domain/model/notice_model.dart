class NoticeModel {
  final int? noticeID;
  final int? noticeType;
  final String? type;
  final String? description;
  final String? entryDate;
  final bool? isActive;
  final DateTime? validDate;
  final DateTime? toDate;
  final String? remarks;
  final String? code;
  final String? userID;
  final String? createdBy;
  final String? language;
  final dynamic? flag;

  NoticeModel({
    this.noticeID,
    this.noticeType,
    this.type,
    this.description,
    this.entryDate,
    this.isActive,
    this.validDate,
    this.toDate,
    this.remarks,
    this.code,
    this.userID,
    this.createdBy,
    this.language,
    this.flag,
  });

  factory NoticeModel.fromJson(Map<String, dynamic>? json) {
    return NoticeModel(
      noticeID: json?['noticeID'],
      noticeType: json?['noticeType'],
      type: json?['type'],
      description: json?['description'],
      entryDate: json?['entryDate'],
      isActive: json?['isActive'],
      validDate: DateTime.parse(json?['validDate']),
      toDate:DateTime.parse(json?['toDate']),
      remarks: json?['remarks'],
      code: json?['code'],
      userID: json?['userID'],
      createdBy: json?['createdBy'],
      language: json?['language'],
      flag: json?['flag'],
    );
  }
}
