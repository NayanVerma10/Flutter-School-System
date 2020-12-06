import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

void notificationsInit(){
  AwesomeNotifications().initialize('resource://drawable/logo', [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: Color(0xFFF3EBFA),
        ledColor: Colors.white,
        vibrationPattern: lowVibrationPattern,
      ),
      NotificationChannel(
          channelKey: 'badge_channel',
          channelName: 'Badge indicator notifications',
          channelDescription:
              'Notification channel to activate badge indicator',
          channelShowBadge: true,
          defaultColor: Color(0xFF000000),
          ledColor: Colors.yellow),
      NotificationChannel(
          icon: 'resource://drawable/notification',
          channelKey: 'schedule',
          channelName: 'Scheduled Notifications',
          channelDescription: 'Notifications with schedule time',
          defaultColor: Color(0xFF9D50DD),
          ledColor: Colors.white),
      NotificationChannel(
          channelKey: 'updated_channel',
          channelName: 'Channel to update',
          channelDescription: 'Notifications with not updated channel',
          defaultColor: Color(0xFF9D50DD),
          ledColor: Colors.white),
      NotificationChannel(
          channelKey: 'low_intensity',
          channelName: 'Low intensity notifications',
          channelDescription:
              'Notification channel for notifications with low intensity',
          defaultColor: Colors.green,
          ledColor: Colors.green,
          vibrationPattern: lowVibrationPattern),
      NotificationChannel(
          channelKey: 'medium_intensity',
          channelName: 'Medium intensity notifications',
          channelDescription:
              'Notification channel for notifications with medium intensity',
          defaultColor: Colors.yellow,
          ledColor: Colors.yellow,
          vibrationPattern: mediumVibrationPattern),
      NotificationChannel(
          channelKey: 'high_intensity',
          channelName: 'High intensity notifications',
          channelDescription:
              'Notification channel for notifications with high intensity',
          defaultColor: Colors.red,
          ledColor: Colors.red,
          vibrationPattern: highVibrationPattern),
      NotificationChannel(
          icon: 'resource://drawable/notification',
          channelKey: "custom_sound",
          channelName: "Custom sound notifications",
          channelDescription: "Notifications with custom sound",
          playSound: true,
          // soundSource: 'resource://raw/res_morph_power_rangers',
          defaultColor: Colors.red,
          ledColor: Colors.red,
          vibrationPattern: lowVibrationPattern),
      NotificationChannel(
          channelKey: "silenced",
          channelName: "Silenced notifications",
          channelDescription: "The most quiet notifications",
          playSound: false,
          enableVibration: false,
          enableLights: false),
      NotificationChannel(
        icon: 'resource://drawable/logo',
        channelKey: 'media_player',
        channelName: 'Media player controller',
        channelDescription: 'Media player controller',
        defaultPrivacy: NotificationPrivacy.Public,
        enableVibration: false,
        enableLights: false,
        playSound: false,
        locked: true,
      ),
      NotificationChannel(
          channelKey: 'big_picture',
          channelName: 'Big pictures',
          channelDescription: 'Notifications with big and beautiful images',
          defaultColor: Color(0xFF9D50DD),
          ledColor: Color(0xFF9D50DD),
          vibrationPattern: lowVibrationPattern),
      NotificationChannel(
          channelKey: 'big_text',
          channelName: 'Big text notifications',
          channelDescription: 'Notifications with a expandable body text',
          defaultColor: Colors.blueGrey,
          ledColor: Colors.blueGrey,
          vibrationPattern: lowVibrationPattern),
      NotificationChannel(
          channelKey: 'inbox',
          channelName: 'Inbox notifications',
          channelDescription: 'Notifications with inbox layout',
          defaultColor: Color(0xFF9D50DD),
          ledColor: Color(0xFF9D50DD),
          vibrationPattern: mediumVibrationPattern),
      NotificationChannel(
        channelKey: 'scheduled',
        channelName: 'Scheduled notifications',
        channelDescription: 'Notifications with schedule functionality',
        defaultColor: Color(0xFF9D50DD),
        ledColor: Color(0xFF9D50DD),
        vibrationPattern: lowVibrationPattern,
        importance: NotificationImportance.High,
      ),
      NotificationChannel(
          icon: 'resource://drawable/logo',
          channelKey: 'progress_bar',
          channelName: 'Progress bar notifications',
          channelDescription: 'Notifications with a progress bar layout',
          defaultColor: Colors.deepPurple,
          ledColor: Colors.deepPurple,
          vibrationPattern: lowVibrationPattern,
          onlyAlertOnce: true),
      NotificationChannel(
          channelKey: 'grouped',
          channelName: 'Grouped notifications',
          channelDescription: 'Notifications with group functionality',
          groupKey: 'grouped',
          setAsGroupSummary: true,
          defaultColor: Colors.lightGreen,
          ledColor: Colors.lightGreen,
          vibrationPattern: lowVibrationPattern,
          importance: NotificationImportance.High)
    ]);
}