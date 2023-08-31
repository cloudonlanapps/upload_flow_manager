# Upload Flow Manager

Uploading files from a local device to server involves multiple steps. This package streamlines those steps and provide a single widget.

## Features

A single top level widget that handles the complete upload flow with following steps.
* Pick one or many files using any picker of your choice. 
* View the selected file, select or deselect items by looking at the preview (avoids accidental upload)
* Use default http based uploader or implement uploader interface usign your favourite uploader.
* Monitor and get status of

## Getting started

Must include riverpod package and wrap the app with ProviderScope()

## Usage

### Implememnt picker
Implement  gPickImages()

```dart
Future<List<String>> gPickImages(
  BuildContext context,
  WidgetRef ref,
)
{

}
```
Refer `example/lib/image_picker.dart` for a example implementation using image_picker.

### Implement previewGenerator

This module is kept as part of the application so that many kind of files can be handled. You may either return a icon or a image that represents the file selected. 

### Caling widget

Now call the widget as below with a UploadConfig widget. 
```dart
  Uploader(
        config: UploadConfig(
            previewGenerator: (String filepath) {
              return Image.file(File(filepath));
            },
            uploadManager: UploadManagerUsingHttp(
                url: "http://127.0.0.1:5000/upload",
                fileField: "file"),
            picker: gPickImages),
      ),
    )
```

## Customization

### Example Server
 To test the package, a Python flask based server is provided in example/server.
 Refer `example/server/README.md` for staring it.

## Additional information

### Implementation details
This package uses Riverpod for managing states and sqlite3 for presistent state.
This helps to preserve pending downloads across sessions and even after the application restarts.

### Pending task
#### Library
  1. sqlite3 open.overrideFor should be done in a callback.
  2. move http implementation as internal and default upload handler
  3. Alternate list based interface along with current grid based
  4. Retry failed cases
  5. Retry all pending when restarted.
  6. Implement background task that runs even after the app is closed. 
  7. Allow the application to add auxilary information for upload
  8. Have a callback after every upload completed to update states on other part of the applications

### Example
  1. Provide an upload handler implementation using background_downloader.
  2. Along with images, also implement files uploader
  3. Handle non-image previews
  
