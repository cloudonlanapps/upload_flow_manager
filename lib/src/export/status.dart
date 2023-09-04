enum UploadStatus {
  // Unsupported for future
  // based on background downloader
  canceled,
  waitingToRetry,
  paused,
  notFound, // File not found when trying to upload // TODO

  // Currently implemented using http
  enqueued, // Waiting in the queue
  running, // Uploading in progress
  complete, // Upload successfully completed
  failed; // Upload Failed

  bool get isFinalState {
    switch (this) {
      case UploadStatus.complete:
      case UploadStatus.notFound:
      case UploadStatus.failed:
      case UploadStatus.canceled:
        return true;

      case UploadStatus.enqueued:
      case UploadStatus.running:
      case UploadStatus.waitingToRetry:
      case UploadStatus.paused:
        return false;
    }
  }
}
