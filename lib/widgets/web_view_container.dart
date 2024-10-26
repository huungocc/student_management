import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../managers/manager.dart';

class WebViewContainer extends StatefulWidget {
  const WebViewContainer({super.key});

  @override
  State<WebViewContainer> createState() => _WebViewContainerState();
}

class _WebViewContainerState extends State<WebViewContainer> {
  final controller = WebViewController()
  ..setJavaScriptMode(JavaScriptMode.unrestricted)
  ..loadRequest(Uri.parse('https://console.firebase.google.com/u/2/project/utc-manager/authentication/users'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Firebase Authentication',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, fontFamily: Fonts.display_font, color: Colors.black),
          ),
          centerTitle: true,
        )
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
