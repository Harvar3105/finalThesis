enum ERole {
  none,
  coach,
  athlete,
}

extension ERoleExtension on ERole {
  static const values = ERole.values;

  ERole next() {
    final currentIndex = index;
    final nextIndex = (currentIndex + 1) % ERole.values.length;
    return ERole.values[nextIndex];
  }

  ERole previous() {
    final currentIndex = index;
    final previousIndex = (currentIndex - 1 + ERole.values.length) % ERole.values.length;
    return ERole.values[previousIndex];
  }
}