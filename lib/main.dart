import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/foundation.dart';
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await Permission.location.request();
  await Permission.camera.request();
  await Permission.storage.request();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  InAppWebViewController? webView;
  double webProgress = 0;
  bool isLoading = true;
  int position = 1 ;

  final key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IndexedStack(
          index: position,
          children: <Widget>[
            InAppWebView(
              initialUrlRequest: URLRequest(
                  url: Uri.parse("https://13.245.213.151/login")),
              androidOnGeolocationPermissionsShowPrompt:
                  (InAppWebViewController controller, String origin) async {
                return GeolocationPermissionShowPromptResponse(
                    origin: origin, allow: true, retain: true);
              },
              initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                  javaScriptCanOpenWindowsAutomatically: true,
                  javaScriptEnabled: true,
                  useOnDownloadStart: true,
                  useOnLoadResource: true,
                  useShouldOverrideUrlLoading: true,
                  mediaPlaybackRequiresUserGesture: true,
                  allowFileAccessFromFileURLs: true,
                  allowUniversalAccessFromFileURLs: true,
                  verticalScrollBarEnabled: true,
                  userAgent: 'random',
                ),
                android: AndroidInAppWebViewOptions(
                    useHybridComposition: true,
                    allowContentAccess: true,
                    builtInZoomControls: true,
                    geolocationEnabled: true,
                    thirdPartyCookiesEnabled: true,
                    allowFileAccess: true,
                    supportMultipleWindows: true),
                ios: IOSInAppWebViewOptions(
                  allowsInlineMediaPlayback: true,
                  allowsBackForwardNavigationGestures: true,
                ),
              ),
              onReceivedServerTrustAuthRequest:
                  (controller, request) async {
                // SSL/TLS 인증서 요청을 처리하는 콜백
                // 인증서 검증을 무시하고 계속 진행하기 위해 빈 인증서로 응답합니다.
                return ServerTrustAuthResponse(
                    action: ServerTrustAuthResponseAction.PROCEED);
              },
              onLoadStart: (controller, url) {
                setState(() {
                  position = 1;
                });
              },
              onLoadStop: (controller, url) {
                setState(() {
                  position = 0;
                });
              },
              onWebViewCreated: (controller) {
                webView = controller;
              },
            ),
            Container(
              color : Colors.white,
              child : Center(
                child : CircularProgressIndicator()
              )
            )
            ]));
  }
}
