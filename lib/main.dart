import 'package:flutter/material.dart';
import './weather_screen.dart';

void main() {
  runApp(const MyApp());
}
//* How Flutter UI is rendered on different platforms
// . It paints the UI on a canvas provided by the platform i.e. it does't translate into Native UI.
// . The canvas is a rectangular area on the screen.
// . It is painted/renedered by its own rendering engine.i.e. Skia graphics which is not changint to Impeller.

// *  Flutter Behind The Scenes, 3 Trees & BuildContext
// . Widget Tree: It is a tree of widgets that are used to render the UI.
// . Element Tree:It is a reflection of widget tree and is responsible for managing the lifecycle of the widgets.

// - So whenever we make any changes to the widget tree, flutter performs a process called Reconciliation or diffing to identify the changes and these changes are only rebuilt using render object tree.
// - Reconciliation is the process of comparing the current widget tree with the previous widget tree and determining the difference between them .
// - This process is also called diffing.

// . Render Object Tree: It is a tree of render objects that are responsible for painting the UI on the canvas.
// . Render Object is a widget it has three types:
// 1.Leaf Render Object: It is a render object that does not have any child.
// Eg: Container, Text, Image, etc.
// 2.Single Child Render Object: It is a render object that has only one child.
// Eg: Center, Align, ,etc.
// 3.Multi Child Render Object: It is a render object that has multiple children.
// Eg: Column,Row, Stack, ListView, etc.

// . BuildContext is a element and element is a reflection of widget.
// . BuildContext is used to locate the widget in the widget tree with the help of element tree.

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      debugShowCheckedModeBanner: false,

      // . copyWith() is a method that returns a copy of the current theme with the specified changes.
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        // scaffoldBackgroundColor: Colors.blueGrey.shade800,
        appBarTheme: const AppBarTheme(
          // backgroundColor: Colors.blueGrey.shade700,
          centerTitle: true,
        ),
      ),
      home: const WeatherScreen(),
    );
  }
}
