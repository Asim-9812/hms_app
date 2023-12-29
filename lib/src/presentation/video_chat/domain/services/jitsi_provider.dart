import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';

final jitsiProvider =
Provider((ref) => JitsiProvider(ref));

class JitsiProvider {

  final Ref _ref;
  JitsiProvider(this._ref);

  void createMeeting({
    required String roomName,
    required bool isAudioMuted,
    required bool isVideoMuted,
    String? subject,
    String username = '',
    String email = '',
    bool preJoined = true,
    bool isVideo = true,
    bool isGroup = true,
  }) async {
    var listener = JitsiMeetEventListener(
      // conferenceJoined: (url) {
      //   debugPrint("conferenceJoined: url: $url");
      // },

      // conferenceWillJoin: (url) {
      //   debugPrint("conferenceWillJoin: url: $url");
      // },
      // participantJoined: (email, name, role, participantId) {
      //   debugPrint(
      //     "participantJoined: email: $email, name: $name, role: $role, "
      //         "participantId: $participantId",
      //   );
      //   participants.add(participantId!);
      // },
      // participantLeft: (participantId) {
      //   debugPrint("participantLeft: participantId: $participantId");
      // },
      // audioMutedChanged: (muted) {
      //   debugPrint("audioMutedChanged: isMuted: $muted");
      // },
      // videoMutedChanged: (muted) {
      //   debugPrint("videoMutedChanged: isMuted: $muted");
      // },
      // endpointTextMessageReceived: (senderId, message) {
      //   debugPrint(
      //       "endpointTextMessageReceived: senderId: $senderId, message: $message");
      // },
      // screenShareToggled: (participantId, sharing) {
      //   debugPrint(
      //     "screenShareToggled: participantId: $participantId, "
      //         "isSharing: $sharing",
      //   );
      // },
      // chatMessageReceived: (senderId, message, isPrivate, timestamp) {
      //   debugPrint(
      //     "chatMessageReceived: senderId: $senderId, message: $message, "
      //         "isPrivate: $isPrivate, timestamp: $timestamp",
      //   );
      // },
      // chatToggled: (isOpen) => debugPrint("chatToggled: isOpen: $isOpen"),
      // participantsInfoRetrieved: (participantsInfo) {
      //   debugPrint(
      //       "participantsInfoRetrieved: participantsInfo: $participantsInfo, ");
      // },
      readyToClose: () {
        print("readyToClose");
      },


    );
    try {
      Map<String, Object> featureFlag =  {};
      featureFlag['welcomepage.enabled'] = false;
      featureFlag['prejoinpage.enabled'] = preJoined;
      featureFlag['add-people.enabled'] = isGroup;

      var options = JitsiMeetConferenceOptions(
        room: roomName,
        serverURL: 'https://meet.codewithbisky.com',
        configOverrides: {
          "startWithAudioMuted": isAudioMuted,
          "startWithVideoMuted": isVideoMuted,
          "subject" : subject??roomName,
        },
        userInfo: JitsiMeetUserInfo(
          displayName: username,
          email: email,
          // avatar: 'https://images.unsplash.com/photo-1617854818583-09e7f077a156?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',

        ),
        featureFlags: featureFlag,

      );
      var jitsiMeet = JitsiMeet();
      await jitsiMeet.join( options,listener);

    } catch (error) {
      print("error: $error");
    }
  }
}