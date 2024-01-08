import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';


class WhereByMeetingPage extends StatelessWidget {
  String url;
  WhereByMeetingPage(this.url);


  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      url += '?skipMediaPermissionPrompt';
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: InAppWebViewPage(url),
    );
  }
}

class InAppWebViewPage extends StatefulWidget {

  final String url;
  InAppWebViewPage(this.url);

  @override
  _InAppWebViewPageState createState() => new _InAppWebViewPageState();
}

class _InAppWebViewPageState extends State<InAppWebViewPage> {
  _InAppWebViewPageState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: Column(children: <Widget>[
              Expanded(
                child: Container(
                  child: InAppWebView(
                    initialUrlRequest: URLRequest(url: WebUri(widget.url)),
                    initialOptions: InAppWebViewGroupOptions(
                        crossPlatform: InAppWebViewOptions(
                          mediaPlaybackRequiresUserGesture: false,
                        ),
                        ios: IOSInAppWebViewOptions(
                          allowsInlineMediaPlayback: true,
                        )),
                    androidOnPermissionRequest: (InAppWebViewController controller,
                        String origin, List<String> resources) async {
                      await Permission.camera.request();
                      await Permission.microphone.request();
                      return PermissionRequestResponse(
                          resources: resources,
                          action: PermissionRequestResponseAction.GRANT);
                    },
                  ),
                ),
              ),
            ])));
  }
}