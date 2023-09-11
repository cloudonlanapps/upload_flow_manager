# Upload Flow Manager

This package aims to simplify the process of uploading files from local devices to server, by providing a single widget.

## Features

A single top level widget that handles the complete upload flow with following steps.
* Pick one or many files using any picker of your choice.  (picker)
* View the selected file, select or deselect items by looking at the preview (avoids accidental upload)  (preview generator)
* Use default http based uploader or implement uploader interface using your favourite uploader. (upload handler)
* Monitor and get status of each upload.

Refer customization to configure any of the steps above.

**This package uses Riverpod for managing states and sqlite3 for presistent state to preserve pending downloads across sessions and even after the application restarts.**

## Getting started

1. Add the package to your `pubspec.yaml` file:

  ```
   flutter pub add upload_flow_manager
  ```

2. Add riverpod

  ```
   flutter pub add flutter_riverpod
  ```

3. Wrap the entire application in a "ProviderScope" widget.
  ```dart
  void main() {
    runApp(
      ProviderScope(
        child: MyApp(),
      ),
    );
  }
  ```
4. Import the package 
   ```dart
   import 'package:upload_flow_manager/upload_flow_manager.dart';
  ```

5. Use the Widget
  ```dart
  // Replace with your upload URL
    Uploader(url: "<Your Upload URL>");   
  ```

For a simple usecase, the above must work without any customization / modification. Adjust the widget size (width, height) to make a clear view of the uploader.

The URL must accept HTTP POST method and accept the file in multipart in a file given in FileField or default to 'file'

## Usage

The Uploader Widget provides parameters for customization.

* To replace gpicker, use pickItems.
* To replace the preview generator, use previewGenerator
* To replace the uploader (which is implemetned using http), extend UploadHandler class and implement, and pass a UploadHandler instance uploadHandler. In this case, you don't need to pass the url.
  * If the requirement is only to use differnt field name for file, you may pass it using fileField.
* To change the language / text used in the interface, override necessary LabeledIcons through uiLabels parameter

```dart
Uploader({
    url: /*<url, required if uploadHandler is null>*/,
    fileField /* default to 'file' */,
    this.uploadHandler /* Extending UploadHandler class with differnt upload functionality */,
    this.pickItems /* Default to image picker */,
    this.previewGenerator /* Default to image preview */,
    this.uiLabels /*Default text internally generated*/,
  })

```

## Pending task

### Library
  - [ ] sqlite3 open.overrideFor should be done in a callback.   

  **On HTTP Uploader**

  - [X] move http implementation as internal and default upload handler
    - [ ] Retry failed cases
    - [ ] Retry all pending when restarted.
    - [ ] Implement background task that runs even after the app is closed. 

  **On UI**

  - [ ] Alternate list based interface along with current grid based 
  - [ ] Allow the application to add auxilary information for upload
  - [ ] Have a callback after every upload completed to update states on other part of the applications
  - [ ] Implement upload files shared through intend (on Mobiles)
  - [ ] Drag and drop fiels to upload
  - [ ] Few text and laber are not configurable yet.
  
### Example
  - [ ] Provide an upload handler implementation using background_downloader.
  - [ ] Along with images, also implement files uploader
  - [ ] Handle non-image previews
  
## Additional Informations

### Manually providing sqlite3 libraries 
on some devices,  the sqlite3 may not be available in default location or you may ship a sqlite3 library with your application. On this situations, sqlite3 provides an option to override the way the sqlite3 package looks for the library.

In this situation, this package provide a pass thru to sqlite3 library.  

Here is an example provided for Linux.

Install packages `path` and `sqlite3`.

Implement the override and pass it to the Uploader.

```dart
import 'package:path/path.dart';
import 'package:sqlite3/open.dart';

sqlite3LibOverrider() {
  final libraryNextToScript =
      File(join('/lib/x86_64-linux-gnu/', 'libsqlite3.so.0'));

  open.overrideFor(OperatingSystem.linux,
      () => DynamicLibrary.open(libraryNextToScript.path));
}
```
 
```dart

  Uploader(
    ...
    sqlite3LibOverrider: sqlite3LibOverrider,
  )

```

### Test Server
If your server is not ready while implementing the app or it can't be used for testing,  you may use the Python Flask based example server provided in this package.
Refer `example/server/README.md` for staring it.
The API to upload a file into this server is `http://127.0.0.1:5000/upload`

