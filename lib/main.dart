// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'src/navigation_controls.dart';
import 'src/web_view_stack.dart';

void main() {
  runApp(MaterialApp(
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
