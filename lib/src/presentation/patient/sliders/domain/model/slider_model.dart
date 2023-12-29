class SlidersModel {
  final int? sliderId;
  final String? title;
  final String? shortInfo;
  final String? description;
  final String? url;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String? imagePath;
  final int? categoryId;
  final String? category;
  final bool? isActive;
  final String? entryDate;
  final String? remarks;
  final String? flag;

  SlidersModel({
    this.sliderId,
    this.title,
    this.shortInfo,
    this.description,
    this.url,
    this.fromDate,
    this.toDate,
    this.imagePath,
    this.categoryId,
    this.category,
    this.isActive,
    this.entryDate,
    this.remarks,
    this.flag,
  });

  factory SlidersModel.fromJson(Map<String, dynamic>? json) {
    return SlidersModel(
      sliderId: json?['sliderId'],
      title: json?['title'],
      shortInfo: json?['shortInfo'],
      description: json?['description'],
      url: json?['url'],
      fromDate: DateTime.parse(json?['fromDate']),
      toDate: DateTime.parse(json?['toDate']),
      imagePath: json?['imagePath'],
      categoryId: json?['categoryId'],
      category: json?['category'],
      isActive: json?['isActive'],
      entryDate: json?['entryDate'],
      remarks: json?['remarks'],
      flag: json?['flag'],
    );
  }
}
