import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visibility/visibility_detector.dart';

class ViewPager1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget child = PageView(
      children: [
        VisibilityDetector(
          key: ValueKey("page view 1"),
          onVisibilityChanged: (info) {
            debugPrint("viewPage1 ${info}");
          },
          child: Center(
            child: Text("page1"),
          ),
        ),
        VisibilityDetector(
          key: ValueKey("page view 2"),
          onVisibilityChanged: (info) {
            debugPrint("viewPage2 ${info}");
          },
          child: Center(
            child: Text("page2"),
          ),
        ),
      ],
    );

    return MaterialApp(
      home: Builder(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('visible app'),
            ),
            body: child,
          );
        },
      ),
    );
  }
}
