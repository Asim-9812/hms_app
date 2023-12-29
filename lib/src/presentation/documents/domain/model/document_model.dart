
class DocumentTypeModel {
  int documentTypeId;
  String documentType;
  bool isActive;
  String remarks;
  DateTime entryDate;
  dynamic flag;

  DocumentTypeModel({
    required this.documentTypeId,
    required this.documentType,
    required this.isActive,
    required this.remarks,
    required this.entryDate,
    this.flag,
  });

  factory DocumentTypeModel.fromJson(Map<String, dynamic> json) {
    return DocumentTypeModel(
      documentTypeId: json['documentTypeId'],
      documentType: json['documentType'],
      isActive: json['isActive'],
      remarks: json['remarks'],
      entryDate: DateTime.parse(json['entryDate']),
      flag: json['flag'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['documentTypeId'] = this.documentTypeId;
    data['documentType'] = this.documentType;
    data['isActive'] = this.isActive;
    data['remarks'] = this.remarks;
    data['entryDate'] = this.entryDate.toIso8601String();
    data['flag'] = this.flag;
    return data;
  }
}



class DoctorFolderModel {
  int? userID;
  String folderName;
  int? flag;

  DoctorFolderModel({
    this.userID,
    required this.folderName,
    this.flag,
  });

  factory DoctorFolderModel.fromJson(Map<String, dynamic> json) {
    return DoctorFolderModel(
      userID: json['userID'],
      folderName: json['folderName'],
      flag: json['flag'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['userID'] = this.userID;
    data['folderName'] = this.folderName;
    data['flag'] = this.flag;
    return data;
  }
}


class DocumentModel {
  int? documentID;
  String? userID;
  int? documentTypeID;
  String? folderName;
  int? doctorAttachmentID;
  String? doctorAttachment;
  String? documentTitle;
  String? documentDescription;
  int? duration;
  String? durationType;
  DateTime? completedDate;
  dynamic attachmentsData;

  DocumentModel({
    this.documentID,
    this.userID,
    this.documentTypeID,
    this.folderName,
    this.doctorAttachmentID,
    this.doctorAttachment,
    this.documentTitle,
    this.documentDescription,
    this.duration,
    this.durationType,
    this.completedDate,
    this.attachmentsData,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      documentID: json['documentID'],
      userID: json['userID'],
      documentTypeID: json['documentTypeID'],
      folderName: json['folderName'],
      doctorAttachmentID: json['doctorAttachmentID'],
      doctorAttachment: json['doctorAttachment'],
      documentTitle: json['documentTitle'],
      documentDescription: json['documentDescription'],
      duration: json['duration'],
      durationType: json['durationType'],
      completedDate: json['completedDate'] != null
          ? DateTime.parse(json['completedDate'])
          : null,
      attachmentsData: json['attachmentsData'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['documentID'] = this.documentID;
    data['userID'] = this.userID;
    data['documentTypeID'] = this.documentTypeID;
    data['folderName'] = this.folderName;
    data['doctorAttachmentID'] = this.doctorAttachmentID;
    data['doctorAttachment'] = this.doctorAttachment;
    data['documentTitle'] = this.documentTitle;
    data['documentDescription'] = this.documentDescription;
    data['duration'] = this.duration;
    data['durationType'] = this.durationType;
    data['completedDate'] =
    this.completedDate != null ? this.completedDate!.toIso8601String() : null;
    data['attachmentsData'] = this.attachmentsData;
    return data;
  }
}

