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
