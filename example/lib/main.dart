import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:upload_flow_manager/upload_flow_manager.dart';
import 'dart:ffi';
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqlite3/open.dart';

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
                          sqlite3LibOverrider: sqlite3LibOverrider,
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

sqlite3LibOverrider() {
  final libraryNextToScript =
      File(join('/lib/x86_64-linux-gnu/', 'libsqlite3.so.0'));

  open.overrideFor(OperatingSystem.linux,
      () => DynamicLibrary.open(libraryNextToScript.path));
}
