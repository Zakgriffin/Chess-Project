class King extends ChessPiece {
  King(Player p) {
    super(p);
  }
  
  int pieceValue() {return 15;}
  
  ArrayList<Move> getMoves() {
    ArrayList<Move> moves = new ArrayList<Move>();
    moves.add(at(0, 1));
    moves.add(at(0, -1));
    moves.add(at(1, 0));
    moves.add(at(-1, 0));
    moves.add(at(1, 1));
    moves.add(at(1, -1));
    moves.add(at(-1, 1));
    moves.add(at(-1, -1));
    return moves;
  }
  
  void show(float x, float y) {
    pushAll(x, y);
      rect(0, 35, 60, 15);
      triangle(0, -5, 20, 30, -20, 30);
      quad(-10, 30, 10, 30, 22, 10, -22, 10);
      rect(0, -12, 45, 15);
      rect(0, -10, 15, 50);
    popAll();
  }
}
