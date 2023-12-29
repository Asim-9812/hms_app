


class Department {
  final int departmentId;
  final int departmentTypeID;
  final String departmentName;
  final String departmentIcon;
  final bool isActive;
  final String remarks;
  final DateTime entryDate;
  final String flag;

  Department({
    required this.departmentId,
    required this.departmentTypeID,
    required this.departmentName,
    required this.departmentIcon,
    required this.isActive,
    required this.remarks,
    required this.entryDate,
    required this.flag,
  });

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      departmentId: json['departmentId'],
      departmentTypeID: json['departmentTypeID'],
      departmentName: json['departmentName'],
      departmentIcon: json['departmentIcon'],
      isActive: json['isActive'],
      remarks: json['remarks'],
      entryDate: DateTime.parse(json['entryDate']),
      flag: json['flag'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'departmentId': departmentId,
      'departmentTypeID': departmentTypeID,
      'departmentName': departmentName,
      'departmentIcon': departmentIcon,
      'isActive': isActive,
      'remarks': remarks,
      'entryDate': entryDate.toIso8601String(),
      'flag': flag,
    };
  }
}
