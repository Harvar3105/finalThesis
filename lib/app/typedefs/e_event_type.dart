enum EEventType {
  Declared,
  Accepted, // Event was accepted but not processed yet.
  Canceled, // Ask user if event was processed. Canceled if it was not. Will not count in events counter.
  Processed, // Event was accepted and processed.
  ConterOffered,
  Shadow,
}