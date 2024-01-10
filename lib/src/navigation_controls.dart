// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'title.dart';

class NavigationControls extends StatefulWidget {
  const NavigationControls({required this.controller, super.key});

  final WebViewController controller;

  @override
  State<NavigationControls> createState() => _NavigationControlsState();
}

class _NavigationControlsState extends State<NavigationControls> {

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        if (canGoBack)
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () async {
            final messenger = ScaffoldMessenger.of(context);
            if (await widget.controller.canGoBack()) {
              await widget.controller.goBack();
            } else {
              messenger.showSnackBar(
                const SnackBar(content: Text('No back history item')),
              );
              return;
            }
          },
        ),
        if (canGoForward)
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () async {
            final messenger = ScaffoldMessenger.of(context);
            if (await widget.controller.canGoForward()) {
              await widget.controller.goForward();
            } else {
              messenger.showSnackBar(
                const SnackBar(content: Text('No forward history item')),
              );
              return;
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.replay),
          onPressed: () {
            widget.controller.reload();
          },
        ),
      ],
    );
  }
}

