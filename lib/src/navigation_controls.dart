// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../main.dart';

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
