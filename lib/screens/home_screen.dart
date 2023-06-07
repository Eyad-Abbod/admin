import 'package:aldeerh_admin/admin/dashboard.dart';
import 'package:aldeerh_admin/screens/news_notification.dart';
import 'package:aldeerh_admin/utilities/app_theme.dart';
import 'package:aldeerh_admin/utilities/crud.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;

    // if (result.notification.additionalData!['news_id'].toString() == 'ok'){}

    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    await OneSignal.shared.setAppId("f8a2e3d8-b154-481e-b839-30705c8cab30");

    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      debugPrint("Accepted permission: $accepted");
    });

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      debugPrint(result.notification.additionalData?['news_id'].toString());

      Get.to(() => NewsFromNotifications(
          newsID: result.notification.additionalData!['news_id'].toString()));
    });

    // OneSignal.shared.setNotificationWillShowInForegroundHandler(
    //     (OSNotificationReceivedEvent event) {
    //   debugPrint('FOREGROUND HANDLER CALLED WITH: $event');

    //   /// Display Notification, send null to not display
    //   event.complete(null);

    //   if (mounted) {
    //   setState(() {});
    // }
    // });
  }

  // Future<void> initPlatformState1() async {
  //   if (!mounted) return;

  //   OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  //   await OneSignal.shared.setAppId("64632726-24fb-4888-9337-6b26b1f894a0");

  //   OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
  //     debugPrint("Accepted permission: $accepted");
  //   });

  //   OneSignal.shared
  //       .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
  //     debugPrint(result.notification.additionalData?['news_id'].toString());

  //     Get.to(() => NewsFromNotifications(
  //         newsID: result.notification.additionalData!['news_id'].toString()));
  //   });

  //   // OneSignal.shared.setNotificationWillShowInForegroundHandler(
  //   //     (OSNotificationReceivedEvent event) {
  //   //   debugPrint('FOREGROUND HANDLER CALLED WITH: $event');

  //   //   /// Display Notification, send null to not display
  //   //   event.complete(null);

  //   //   if (mounted) {
  //   //   setState(() {});
  //   // }
  //   // });
  // }

  final Curd curd = Curd();

  List<String> seenList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IconButton(
          onPressed: () {
            Get.to(() => const DashboardScreen());
          },
          icon: const Icon(Icons.admin_panel_settings),
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppTheme.appTheme.primaryColor,
        title: const Text("Admin"),
      ),
    );
  }
}
