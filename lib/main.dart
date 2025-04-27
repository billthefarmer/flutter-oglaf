// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: const WebViewApp(),
    ),
  );
}

class WebViewApp extends StatefulWidget {
  const WebViewApp({super.key});

  @override
  State<WebViewApp> createState() => WebViewAppState();
}

class WebViewAppState extends State<WebViewApp> {
  late final WebViewController controller;

  String title = 'Oglaf';

  var canGoBack = true;
  var canGoForward = true;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..loadRequest(
        Uri.parse('https://oglaf.com'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (await controller.canGoBack()) {
          await controller.goBack();
        } else {
          await SystemNavigator.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: [
            NavigationControls(controller: controller, state: this),
          ],
        ),
        body: WebViewStack(controller: controller, state: this),
      ),
    );
  }
}

class NavigationControls extends StatelessWidget {
  const NavigationControls(
      {required this.controller, required this.state, super.key});

  final WebViewController controller;
  final WebViewAppState state;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: state.canGoBack
              ? () async {
                  await controller.goBack();
                }
              : null,
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: state.canGoForward
              ? () async {
                  await controller.goForward();
                }
              : null,
        ),
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            controller.reload();
          },
        ),
      ],
    );
  }
}

class WebViewStack extends StatefulWidget {
  const WebViewStack(
      {required this.controller, required this.state, super.key});

  final WebViewController controller;
  final WebViewAppState state;

  @override
  State<WebViewStack> createState() => _WebViewStackState();
}

class _WebViewStackState extends State<WebViewStack> {

  var loadingPercentage = 0;

  @override
  void initState() {
    super.initState();
    widget.controller
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              loadingPercentage = 0;
            });
          },
          onProgress: (progress) {
            setState(() {
              loadingPercentage = progress;
            });
          },
          onPageFinished: (url) {
            setState(() {
              loadingPercentage = 100;
            });
            final value = widget.controller.getTitle();
            value.then((v) => widget.state.setState(() {
                  widget.state.title = v ?? 'Oglaf';
                }));

            final back = widget.controller.canGoBack();
            back.then((v) => widget.state.setState(() {
                  widget.state.canGoBack = v;
                }));

            final forward = widget.controller.canGoForward();
            forward.then((v) => widget.state.setState(() {
                  widget.state.canGoForward = v;
                }));
            widget.controller.runJavaScript('''
              let image = document.getElementById("strip");
              if (image != null)
              image.addEventListener("click", (event) => {
              SnackBar.postMessage(image.getAttribute("title"));
          });
              ''');
          },
          onNavigationRequest: (navigation) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'SnackBar',
        onMessageReceived: (message) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(message.message,
                  style: const TextStyle(color: Colors.white)),
              backgroundColor: Colors.black));
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(
          controller: widget.controller,
        ),
        if (loadingPercentage < 100)
          LinearProgressIndicator(
            value: loadingPercentage / 100.0,
          ),
      ],
    );
  }
}
