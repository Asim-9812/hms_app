class MeetingModel {
  DateTime startDate;
  DateTime endDate;
  String roomName;
  String roomUrl;
  String meetingId;

  MeetingModel({
    required this.startDate,
    required this.endDate,
    required this.roomName,
    required this.roomUrl,
    required this.meetingId,
  });

  factory MeetingModel.fromJson(Map<String, dynamic> json) {
    return MeetingModel(
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      roomName: json['roomName'],
      roomUrl: json['roomUrl'],
      meetingId: json['meetingId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'roomName': roomName,
      'roomUrl': roomUrl,
      'meetingId': meetingId,
    };
  }
}



class CreateMeetingModel {
  bool isLocked;
  String roomNamePrefix;
  String roomNamePattern;
  String roomMode;
  DateTime endDate;
  List<String> fields;

  CreateMeetingModel({
    required this.isLocked,
    required this.roomNamePrefix,
    required this.roomNamePattern,
    required this.roomMode,
    required this.endDate,
    required this.fields,
  });

  factory CreateMeetingModel.fromJson(Map<String, dynamic> json) {
    return CreateMeetingModel(
      isLocked: json['isLocked'],
      roomNamePrefix: json['roomNamePrefix'],
      roomNamePattern: json['roomNamePattern'],
      roomMode: json['roomMode'],
      endDate: DateTime.parse(json['endDate']),
      fields: List<String>.from(json['fields']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isLocked': isLocked,
      'roomNamePrefix': roomNamePrefix,
      'roomNamePattern': roomNamePattern,
      'roomMode': roomMode,
      'endDate': endDate.toIso8601String(),
      'fields': fields,
    };
  }
}
