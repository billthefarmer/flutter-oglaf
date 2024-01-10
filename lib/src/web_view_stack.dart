// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'title.dart';

class WebViewStack extends StatefulWidget {
  WebViewStack({required this.controller, required this.state, super.key});

  final WebViewController controller;
  final State state;

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
                  title = v ?? 'Oglaf';
            }));

            final back = widget.controller.canGoBack();
            back.then((v) => widget.state.setState(() {
                  canGoBack = v;
            }));

            final forward = widget.controller.canGoForward();
            forward.then((v) => widget.state.setState(() {
                  canGoForward = v;
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
          ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message.message,
                style: TextStyle(color: Colors.white)),
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
