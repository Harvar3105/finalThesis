enum ESortingOrder {
  none,
  ascending,
  descending,
}

extension ESortingExtension on ESortingOrder {
  static const values = ESortingOrder.values;

  ESortingOrder next() {
    final currentIndex = index;
    final nextIndex = (currentIndex + 1) % ESortingOrder.values.length;
    return ESortingOrder.values[nextIndex];
  }

  ESortingOrder previous() {
    final currentIndex = index;
    final previousIndex = (currentIndex - 1 + ESortingOrder.values.length) % ESortingOrder.values.length;
    return ESortingOrder.values[previousIndex];
  }
}