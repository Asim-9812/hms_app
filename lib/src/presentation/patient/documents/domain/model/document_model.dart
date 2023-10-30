


class PatientDocumentModel {
  int? documentID;
  String? userID;
  int? documentTypeID;
  String? folderName;
  int? patientAttachmentID;
  String? patientAttachment;
  String? documentTitle;
  String? documentDescription;
  int? duration;
  String? durationType;
  DateTime? completedDate;
  dynamic attachmentsData;

  PatientDocumentModel({
    this.documentID,
    this.userID,
    this.documentTypeID,
    this.folderName,
    this.patientAttachmentID,
    this.patientAttachment,
    this.documentTitle,
    this.documentDescription,
    this.duration,
    this.durationType,
    this.completedDate,
    this.attachmentsData,
  });

  factory PatientDocumentModel.fromJson(Map<String, dynamic> json) {
    return PatientDocumentModel(
      documentID: json['documentID'],
      userID: json['userID'],
      documentTypeID: json['documentTypeID'],
      folderName: json['folderName'],
      patientAttachmentID: json['patientAttachmentID'],
      patientAttachment: json['patientAttachment'],
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
    data['patientAttachmentID'] = this.patientAttachmentID;
    data['patientAttachment'] = this.patientAttachment;
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
