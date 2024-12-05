import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();

//   String accessToken = await _HomePageState.getAccessToken();
//   print("Firebase Access Token: $accessToken");
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Firebase and WebView',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: HomePage(),
//     );
//   }
// }

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
    FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        fcmToken = token;
      });
      print("FCM Token: $fcmToken");

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text('FCM Token:'),
            // Text(fcmToken ?? 'Fetching token...'),
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
static Future<String> getAccessToken() async{
    final serviceAccountJson = {
  "type": "service_account",
  "project_id": "pushnotifications-57afa",
  "private_key_id": "868a0a71d095f7d4f1d0feded8053ff4e3309bb7",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDNVFgoqnjuhtii\nNGm375+n+yyl7gE4WZEnRuhp/Im/X1lhkfRibT7+DFpj/aEXshLUWcgJ/eYVasRE\n05GESg7sXzm0uUH6Y0NYCNRlaO+ACwIZ2H4muHsl5VyH38FSgNPHERe74paWJg28\nLGI3Wk19TdUSLO3oPRQhq2t8Qd+jCnPXHWtpRvHNB4rN1FLcH230Vwz+XBvQsK18\n7M7GVtjgzYobZ5zpi2AkW2CLukzwlN7Jg+Qm09lQZfoLZnR4nY5nsZ5d7SgYelkO\nfgj/ShV/weoZOz76TI/sx8HPMyc11uhn6TyXNiLc3G7B9Qvv0/9olfRxZgangzVG\nZ5E86AotAgMBAAECggEAMuTMWj4Q7gyR/ziPGLamI/Cz2ygQeNtoiWv/uR+NtBfp\n82+GO+xYsAc3U2//ITy0ApsDZIigol/dqLKpL7lclBWxW7yMoEfA3j4ICV/Wd24j\nFe1trWLOMXE1u38Ib877Ty0LLTiney2Q+3qj2JUDPoMPhGsLCCS1i/ftkzXPvR0t\nEVpUtyw/gdmfZY08XYq/R2KGcPx+wuNQCb7ci5RxW+nAuWPI/1afoCVqs0ZG3ITz\nENugGp20Yv1FkBYh0h8sbnDC8oCmclKZKcbw8Of3dEq6qMwcY2JS4zYBkcl2eoix\ncVe8LDd6dTHYjaZPeA5/J2c+VCnEU6tJX4EUUDgcKQKBgQDx+0CoKD5YIJKNFUIM\nBtvdaBRfAaf62Nd80Ov8jLVfLkboZ0NnOHys1/AXWyuug2gQWYx7g2v5iJS+F/wo\naQUbt09oy5GhdRtLMFvtlS73jt9v0lX2hU73t9h4qee9eDzn+vor9ILJoGDSQQQQ\n0A5vMgCtXTQyPK/FD6HsDspVJQKBgQDZOYSsoZ6mmkvQ0tYZQqPyuh2Xsv1sBTMM\nLhZF53YZOXHKpfo+gdANpZ/ns+uN0Lfs4DO4fMxWI3zFTupQ+U7NqpXGnwfPCZIJ\nP4tlc2G9trrBvNS5jvp+WVUwimULpige2TjPmuSyS0Gn9foVhvUD/Ml8JnRRpIX4\n5A43YCdGaQKBgDnW9ah8HhLQjlccurHHPeyZQS1IZw+Fn1RdV9sBAyViGV7Zt/nH\nPb3Oy7u5diJ7lHc8AGFRk5CMvgkGEKbUG315foitB/1Q0ZpST9blLtnLk8rVuuh3\nCt4ZWqvU6OiYAe7tRbkV8+Ef7aS0F7WxFZIsoI7P1XcgnF79EpYrHt/lAoGBAJi+\nZDeLceaOio8tIdUjUetEybg46RAC2/FNmuXOqvFzvjsT2NIJL8XY14byscjHof0T\nberk/j33uC15nzQPCkV+FNFUVAZWIXUVVKyipHDlQ48le6N7EVK0+D0oo4K8dGu0\nrMj2jqd8WY+EXDS08Ca8ouUEmTgravUnT4PKvfM5AoGAV99hWBujlP//lzI7R3FE\nEIfOVQiUaAupa/qpHq81iiU6RMTsFEMj3rLoHgvhKRKJhFzqKXPPDk5WGUjN8gY3\nDYqbQNwVTleWGGZllxVphEYiduWE0CgmjNArI8BrgFo4yts3wbx7oT+BT3QKoKbW\njlZQmdIKBb6+HOlM1bs+9VU=\n-----END PRIVATE KEY-----\n",
  "client_email": "firebase-adminsdk-1w3dn@pushnotifications-57afa.iam.gserviceaccount.com",
  "client_id": "103900683721719145943",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-1w3dn%40pushnotifications-57afa.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
};

List<String> scopes = [
  'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
];

http.Client client = await auth.clientViaServiceAccount(
  auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
  scopes,
); 

auth.AccessCredentials credentials = await auth.obtainAccessCredentialsViaServiceAccount(
   auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
   scopes,
   client
);

client.close();
return credentials.accessToken.data;
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
                Uri.parse("https://7453-175-101-13-226.ngrok-free.app"))),
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

//   static Future<String> getAccessToken() async{
//     final serviceAccountJson = {
//    "type": "service_account",
//   "project_id": "inappwebview-6c6d1",
//   "private_key_id": "bf4bb2ba32b711e7d815b8230d1a6b23888bed22",
//   "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEuwIBADANBgkqhkiG9w0BAQEFAASCBKUwggShAgEAAoIBAQC8eBgnQvN9W3tA\nE+FnHeJ+Fdh6fICsoilCakaHP3zisVhf9wYpxI/KCixCrLJCtaNYCrzGoothhFMw\n7ZUdGk74uv2UIxgHW7UQfiG1e/4/NS2rLBJvJ4SDeCnnlX28+OI+8egeIcrA/QRs\nbB0PUNl0IR9QJySnFHZWhWMWP8F6iK4PyJHsJY+Q6Nct6gPdPiy7dfIg8UYGkOTD\nO+y+ESa7RrDkFOp4Hux0Y3m8ycMR74rk0WQ4fmHHyuqdSsR141vDo1OT7opuMYLt\n68l1M278qy1XQZL7ibRpFE0sO6IswDub/SpU5dvUnnw1Efo8j5A6Ph3qt2GjkLFI\n4ynV5i3RAgMBAAECgf9KDJAbh51ODjjJXwZGEuJ/0kAmipmuj7LQ+sXl3cvzmuUI\nz3BceMkGA3k1uSSmO+IxyrDhBSbo6aobTz2HHGRq1bf2vCh0u6jTEhEB0qB9Cn0n\nA+nk7QyORb2Gf/XR3vewQ4YvpeyZEXrrc+RMYDe6qPOPSnyG05irOz1Ile7ZdVZr\nEolc9UhJwcO/06B/Kk2i7oGgv3yc9pgIwwdlfj9vdletKAze2kc5QelSRWC4VFx4\nWQqVlLYrbw6klUDdUDCel17sFdSGSGDOlVRfd6oqeTY7E4ttTR58XRQWKqsl7GVy\nzbCjUI34aFAmm85jVyc3PBb8NuEKWjRlr3UXbAECgYEA/tIFy3ui3P4qTjvch1YR\n+KFWsbqdBEZliCvoMbOe/1vzwAvqSoH9sZHZnm4HXPZVEVfvujGngH9cQ3RYNPvB\nNYTOsOBF6rQE/e7COzcPUSEVeArDTtEwjEmziqmt+YhhD2U0vDrHUakd9xB56yPe\nsqn84ewjypoTec1ngnAF8wECgYEAvVdxBWJQRccINcm77qk2eA2lkbFmatOY6aQ1\nPYBQsx0KHvDFufsLAWy7/eQI8bCaeuicfd8UDxgg32HbSCJePwUPn3xp1mFxRjM5\nU9DKungvJxlH567gW1sFZRo25fwoVr9J4WtXGoSt0tV4JFCF6shSRdPOr6DCy/Ni\nkotMytECgYBcXS5CiocHCY22G9acq6MJ9xkghN7jLM0ipZ+dXFk2gFMC+o6rASE+\n2voBhipfFN7S0YgQem0Xk5KS1LogQlzPFFuDG1fccfIZRRDcO+Hua0qH34bZq9Oo\nFhLhIQ3xk/ByjyGlVLzoqZ817Z/zjmXrZthF3709c8m5ba2mRwqxAQKBgQCSbVxH\nmKeRvwG3b0L6qDwqjgs8aCBXfzqjfc16uZAvZMbd9MBFO0Ngn7GnAMJ1/2kIonnb\n0jhWEAfkGW6XE5UlUYmqgnHrTEJo0taD3lXZ7XYx25hDMXfqzrKWZLaOF/suUxMU\n1IlxRaiUA2i9VNSsJK2TuOD/6+iaB6h0wmvp8QKBgAnju5/4lgOGh3Dw0tgzqCCv\nORMNfqbj/qrjdkqn6gVEHOhNStSIuRA8kbrTIUPs+2JTkmdjsjqSVJBPP2oIXKEI\ntDCskE2v/Pp8LgrAsQODUYIPRQ0Blsl+W9Qo2VcBZc7b5DfxQDPIzEmpf3qo9MTC\nZM9qnoQjTNiKNt2d8P9C\n-----END PRIVATE KEY-----\n",
//   "client_email": "firebase-adminsdk-n997q@inappwebview-6c6d1.iam.gserviceaccount.com",
//   "client_id": "104443859748426786614",
//   "auth_uri": "https://accounts.google.com/o/oauth2/auth",
//   "token_uri": "https://oauth2.googleapis.com/token",
//   "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
//   "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-n997q%40inappwebview-6c6d1.iam.gserviceaccount.com",
//   "universe_domain": "googleapis.com"
// };

// List<String> scopes = [
//   'https://www.googleapis.com/auth/userinfo.email',
//       'https://www.googleapis.com/auth/firebase.database',
//       'https://www.googleapis.com/auth/firebase.messaging',
// ];

// http.Client client = await auth.clientViaServiceAccount(
//   auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
//   scopes,
// ); 

// auth.AccessCredentials credentials = await auth.obtainAccessCredentialsViaServiceAccount(
//    auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
//    scopes,
//    client
// );

// client.close();
// return credentials.accessToken.data;
//   }

}