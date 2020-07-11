import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:jitsi_meet/jitsi_meeting_listener.dart';
import 'package:jitsi_meet/room_name_constraint.dart';
import 'package:jitsi_meet/room_name_constraint_type.dart';
import 'package:jitsi_meet/feature_flag/feature_flag_enum.dart';

class MyApp extends StatefulWidget {
  final String className, schoolCode, teachersId, classNumber, section, subject;
  MyApp(
      {Key key,
      this.className,
      this.schoolCode,
      this.teachersId,
      this.classNumber,
      this.section,
      this.subject})
      : super(key: key);
  @override
  _MyAppState createState() => _MyAppState(
      className, schoolCode, teachersId, classNumber, section, subject);
}

class _MyAppState extends State<MyApp> {
  final String className, schoolCode, teachersId, classNumber, section, subject;
  final serverText = TextEditingController();
  dynamic roomText;
  dynamic subjectText;
  dynamic nameText;
  dynamic emailText;
  dynamic iosAppBarRGBAColor;
  var isAudioOnly = true;
  var isAudioMuted = true;
  var isVideoMuted = true;
  _MyAppState(this.className, this.schoolCode, this.teachersId,
      this.classNumber, this.section, this.subject);

  loadData() async{
    String name,email;
    Firestore.instance.collection('School')
        .document(schoolCode).collection('Teachers').document(teachersId).get()
        .then((value) {
          name=value.data['first name']+' '+value.data['last name'];
          email=value.data['email'];
          return true;
        }).then((value) {
          setState(() {
            roomText = TextEditingController(text: "$schoolCode-$classNumber-$section-$subject");
            subjectText = TextEditingController(text: "");
            nameText = TextEditingController(text: name);
            emailText = TextEditingController(text: email);
            iosAppBarRGBAColor =
                TextEditingController(text: "#0080FF80"); //transparent blue

    
          });
        });
        

  }

  @override
  void initState() {
    loadData();
    super.initState();
    JitsiMeet.addListener(JitsiMeetingListener(
        onConferenceWillJoin: _onConferenceWillJoin,
        onConferenceJoined: _onConferenceJoined,
        onConferenceTerminated: _onConferenceTerminated,
        onError: _onError));
  }

  @override
  void dispose() {
    super.dispose();
    JitsiMeet.removeAllListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 24.0,
              ),
              TextField(
                controller: serverText,
                enabled: false,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Server URL",
                    hintText: "Hint: Leave empty for meet.jitsi.si"),
              ),
              SizedBox(
                height: 16.0,
              ),
              TextField(
                controller: roomText,
                enabled: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Room",
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              TextField(
                controller: subjectText,
                enabled: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Subject",
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              TextField(
                controller: nameText,
                enabled: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Display Name",
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              TextField(
                controller: emailText,
                enabled: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Email",
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              CheckboxListTile(
                title: Text("Audio Only"),
                value: isAudioOnly,
                onChanged: _onAudioOnlyChanged,
              ),
              SizedBox(
                height: 16.0,
              ),
              CheckboxListTile(
                title: Text("Audio Muted"),
                value: isAudioMuted,
                onChanged: _onAudioMutedChanged,
              ),
              SizedBox(
                height: 16.0,
              ),
              CheckboxListTile(
                title: Text("Video Muted"),
                value: isVideoMuted,
                onChanged: _onVideoMutedChanged,
              ),
              Divider(
                height: 48.0,
                thickness: 2.0,
              ),
              SizedBox(
                height: 64.0,
                width: double.maxFinite,
                child: RaisedButton(
                  onPressed: () {
                    _joinMeeting();
                  },
                  child: Text(
                    "Join Meeting",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onAudioOnlyChanged(bool value) {
    setState(() {
      isAudioOnly = value;
    });
  }

  _onAudioMutedChanged(bool value) {
    setState(() {
      isAudioMuted = value;
    });
  }

  _onVideoMutedChanged(bool value) {
    setState(() {
      isVideoMuted = value;
    });
  }

  _joinMeeting() async {
    String serverUrl =
        serverText.text?.trim()?.isEmpty ?? "" ? null : serverText.text;

    try {
      // Enable or disable any feature flag here
      // If feature flag are not provided, default values will be used
      // Full list of feature flags (and defaults) available in the README
      Map<FeatureFlagEnum, bool> featureFlags = {
        FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
      };

      // Here is an example, disabling features for each platform
      if (Platform.isAndroid) {
        // Disable ConnectionService usage on Android to avoid issues (see README)
        featureFlags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
      } else if (Platform.isIOS) {
        // Disable PIP on iOS as it looks weird
        featureFlags[FeatureFlagEnum.PIP_ENABLED] = false;
      }

      // Define meetings options here
      var options = JitsiMeetingOptions()
        ..room = roomText.text
        ..serverURL = serverUrl
        ..subject = subjectText.text
        ..userDisplayName = nameText.text
        ..userEmail = emailText.text
        ..iosAppBarRGBAColor = iosAppBarRGBAColor.text
        ..audioOnly = isAudioOnly
        ..audioMuted = isAudioMuted
        ..videoMuted = isVideoMuted
        ..featureFlags.addAll(featureFlags);

      debugPrint("JitsiMeetingOptions: $options");
      await JitsiMeet.joinMeeting(
        options,
        listener: JitsiMeetingListener(onConferenceWillJoin: ({message}) {
          debugPrint("${options.room} will join with message: $message");
        }, onConferenceJoined: ({message}) {
          debugPrint("${options.room} joined with message: $message");
        }, onConferenceTerminated: ({message}) {
          debugPrint("${options.room} terminated with message: $message");
        }),
        // by default, plugin default constraints are used
        //roomNameConstraints: new Map(), // to disable all constraints
        //roomNameConstraints: customContraints, // to use your own constraint(s)
      );
    } catch (error) {
      debugPrint("error: $error");
    }
  }

  static final Map<RoomNameConstraintType, RoomNameConstraint>
      customContraints = {
    RoomNameConstraintType.MAX_LENGTH: new RoomNameConstraint((value) {
      return value.trim().length <= 50;
    }, "Maximum room name length should be 30."),
    RoomNameConstraintType.FORBIDDEN_CHARS: new RoomNameConstraint((value) {
      return RegExp(r"[$€£]+", caseSensitive: false, multiLine: false)
              .hasMatch(value) ==
          false;
    }, "Currencies characters aren't allowed in room names."),
  };

  void _onConferenceWillJoin({message}) {
    debugPrint("_onConferenceWillJoin broadcasted with message: $message");
  }

  void _onConferenceJoined({message}) {
    debugPrint("_onConferenceJoined broadcasted with message: $message");
  }

  void _onConferenceTerminated({message}) {
    debugPrint("_onConferenceTerminated broadcasted with message: $message");
  }

  _onError(error) {
    debugPrint("_onError broadcasted: $error");
  }
}
