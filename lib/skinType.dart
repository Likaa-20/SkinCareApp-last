

class skinType {
  int Sid;
  String description;

  skinType(this.Sid, this.description);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is skinType && runtimeType == other.runtimeType && Sid == other.Sid;

  @override
  int get hashCode => Sid.hashCode;

  @override
  String toString() {
    return '$description';
  }
}





