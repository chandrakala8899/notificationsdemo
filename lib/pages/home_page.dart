
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:http/http.dart' as http;
// import 'package:googleapis_auth/auth_io.dart' as auth;

class HomePage extends StatefulWidget {


  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? fcmToken = 'Waiting for token...';

  late FirebaseMessaging messaging;
  late FlutterLocalNotificationsPlugin localNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    //requestPermission();
    FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        fcmToken = token;
      });
      //print("FCM Token: $fcmToken");

      messaging = FirebaseMessaging.instance;

    // Initialize the local notifications plugin
    localNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _initializeNotifications();

    // Request Permission
    messaging.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Notification received: ${message.notification?.title}");

      // Show local notification when the app is in the foreground
      _showNotification(message.notification);
    });       
    });
    // Listen to token refresh
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      print("Refreshed Token: $newToken");
    });
  }
//  Future<void> requestPERMISSIONS() async {
// await Permission.camera.request();
// await Permission.location.request();
// await Permission.microphone.request(); 
//  }


  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('app_icon'); // notification icon

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
    );
    await localNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _showNotification(RemoteNotification? notification) async {
    if (notification != null) {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails('your_channel_id', 'your_channel_name',
              channelDescription: 'Your channel description',
              importance: Importance.max,
              priority: Priority.high,
              ticker: 'ticker');
      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await localNotificationsPlugin.show(
        0,
        notification.title,
        notification.body,
        platformChannelSpecifics,
        payload: 'item x', // Add any payload data here if needed
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase Token & WebView"),
        actions: [
          IconButton(
            icon: Icon(Icons.web),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WebViewScreen(fcmToken: fcmToken)),
              );
            },
          ),
        ],
      ),
      body:fcmToken==null?Center(child: CircularProgressIndicator()): Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WebViewScreen(fcmToken: fcmToken)),
                );
              },
              child: Text("Open WebView"),
            ),
          ],
        ),
      ),
    );
  }
}

class WebViewScreen extends StatefulWidget {
  final String? fcmToken;
  
  WebViewScreen({this.fcmToken});
  
  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late InAppWebViewController _webViewController;
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("In-App WebView")),
      body: InAppWebView(
        initialUrlRequest: URLRequest( url: WebUri.uri(
                Uri.parse("https://plumbee.in/dev/cont4/do_handyplum.php"))),
        onWebViewCreated: (controller) {
          _webViewController = controller;
          
          // Pass FCM token to JS context
          _webViewController.addJavaScriptHandler(
            handlerName: 'getDeviceToken',
            callback: (args) {
              // Get the token and print inside the WebView
              print("Token inside WebView: ${widget.fcmToken}");
              return {'device_token': widget.fcmToken};              
            }
          );
        },
        // onLoadStart: (InAppWebViewController controller, Uri? url) {
        //   print("Loading: $url");
        // },
        // onLoadStop: (InAppWebViewController controller, Uri? url) async {
        //   print("Loaded: $url");
        //   // You can also inject the token into the JS context here
        //   await _webViewController.evaluateJavascript(
        //       source: """
        //       window.deviceToken = '${widget.fcmToken}';  // Set the token in JS
        //       console.log('Token set in JavaScript: ${widget.fcmToken}');
        //       """
        //   );
        // },
      ),
    );
  }
}