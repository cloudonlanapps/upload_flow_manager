import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:upload_flow_manager/upload_flow_manager.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Files Uploader Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
          appBar: AppBar(title: const Text("Files Uploader Demo")),
          body: Column(
            children: [
              const Expanded(
                child: Center(
                  child: Text("Your Other widget"),
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    const Expanded(
                      child: Center(
                        child: Text("Your Other widget"),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(border: Border.all()),
                        child: Uploader(
                          url: "http://127.0.0.1:5000/upload",
                          fileField: "file",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Expanded(
                child: Center(
                  child: Text("Your Other widget"),
                ),
              ),
            ],
          )),
    );
  }
}
