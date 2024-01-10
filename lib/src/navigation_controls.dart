// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'title.dart';

class NavigationControls extends StatelessWidget {
  const NavigationControls({required this.controller, super.key});

  final WebViewController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        if (canGoBack)
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () async {
            if (await controller.canGoBack())
              await controller.goBack();
          },
        ),
        if (canGoForward)
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () async {
            if (await controller.canGoForward())
              await controller.goForward();
          },
        ),
        IconButton(
          icon: const Icon(Icons.replay),
          onPressed: () {
            controller.reload();
          },
        ),
      ],
    );
  }
}

