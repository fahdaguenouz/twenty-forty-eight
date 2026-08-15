class Tile {
  final String id;
  final int value;
  final int x;
  final int y;
  final bool isMerged;
  final bool isNew; 

  Tile({
    required this.id,
    required this.value,
    required this.x,
    required this.y,
    this.isMerged = false,
    this.isNew = false,
  });

  Tile copyWith({
    String? id,
    int? value,
    int? x,
    int? y,
    bool? isMerged,
    bool? isNew,
  }) {
    return Tile(
      id: id ?? this.id,
      value: value ?? this.value,
      x: x ?? this.x,
      y: y ?? this.y,
