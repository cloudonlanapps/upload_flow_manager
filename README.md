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
```
UploaderView( key: key, 
  picker: (BuildContext context, WidgetRef ref) { ..}   // required
  previewGenerator: (String filepath) {}                // required
  pickerLabel: "Select Files",
  pickerLabelMoreFiles: "Select More Files",
  pickerIconData: IconData(Icons.plus),
  gridDelegate:SliverGridDelegate(...))
```

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder.

```dart
const like = 'sample';
```

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.
