import 'package:flutter/material.dart';
import 'package:visibility/visibility_detector.dart';
import 'package:visibility_example/pages/page1.dart';
import 'package:visibility_example/pages/pager.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget{
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>  {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(VisibilityDetectorController.instance);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(VisibilityDetectorController.instance);
  }


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      navigatorObservers: [
        VisibilityDetectorController.instance.routeObserver
      ],
      home: Builder(
        builder: (BuildContext context){
          return Scaffold(
            appBar: AppBar(
              title: const Text('visible app'),
            ),
            body: Column(
              children: [
                Container(
                  height: 50,
                  child: Center(
                    child: GestureDetector(onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context){
                            return Page1();
                          }
                      ));
                    },child: Text('Running on: test jump page\n')),
                  ),
                ),
                Container(
                  height: 50,
                  child: Center(
                    child: GestureDetector(onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context){
                            return ViewPager1();
                          }
                      ));
                    },child: Text('Running on: test Pager\n')),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
