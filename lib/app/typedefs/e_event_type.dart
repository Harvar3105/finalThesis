enum EEventType {
  declared,
  accepted, // Event was accepted but not processed yet.
  canceled, // Ask user if event was processed. Canceled if it was not. Will not count in events counter.
  processed, // Event was accepted and processed.
  conterOffered,
  shadow,
}