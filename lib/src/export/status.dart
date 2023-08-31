enum UploadStatus {
  enqueued,
  running,
  complete,
  notFound,
  failed,
  canceled,
  waitingToRetry,
  paused;

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
