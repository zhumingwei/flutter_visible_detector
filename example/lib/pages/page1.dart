

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:visibility/visibility_detector.dart';
class Page1 extends StatefulWidget {
  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> with RouteAware2{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('visible app'),
      ),
      body: VisibilityDetector(
        key: ValueKey("page1"),
        onVisibilityChanged: (VisibilityInfo visibilityInfo){
          debugPrint("page1 ${visibilityInfo}");
        },
        child: GestureDetector(
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context){
                  return Page2();
                }
            ));
          },
          child: Center(
            child: Text('Running on: page1 \n'),
          ),
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ModalRoute route = mounted ? ModalRoute.of(context) : null;
    if (route != null && route.isActive) {
      VisibilityDetectorController.instance.routeObserver.subscribe(this, route);
    }
  }

  @override
  void didPopNext(Route route) {
    super.didPopNext(route);
    // debugPrint("page1 didPopNext");
  }

  @override
  void didPop() {
    super.didPop();
    // debugPrint("page1 didPop");
  }

  @override
  void didPushNext(Route route) {
    super.didPushNext(route);
    // debugPrint("page1 didPushNext");
  }

  @override
  void didPush() {
    super.didPush();
    // debugPrint("page1 didPush");
  }

  @override
  void dispose() {
    super.dispose();
    VisibilityDetectorController.instance.routeObserver.unsubscribe(this);
  }
}

class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('visible app'),
      ),
      body: VisibilityDetector(
        key: ValueKey("page2"),
        onVisibilityChanged: (VisibilityInfo visibilityInfo){
          debugPrint("page2 ${visibilityInfo}");
        },
        child: GestureDetector(
          onTap: () async{
            await showDialog(
                context: context,
                builder: (c) {
                  return Dialog(
                    backgroundColor: Colors.transparent,
                    child: Text(
                        "dialog"
                    ),
                  );
                }
            );


          },
          child: Center(

            child: Text('Running on: page2 \n'),
          ),
        ),
      ),
    );
  }
}
