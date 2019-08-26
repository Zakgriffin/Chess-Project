class Rook extends ChessPiece {
  Rook(Player p) {
    super(p);
  }
  
  int pieceValue() {return 5;}
  
  ArrayList<Move> getMoves() {
    ArrayList<Move> moves = new ArrayList<Move>();
    moves.addAll(ray(1, 0));
    moves.addAll(ray(-1, 0));
    moves.addAll(ray(0, 1));
    moves.addAll(ray(0, -1));
    return moves;
  }
  
  void show(float x, float y) {
    pushAll(x, y);
      rect(0, 35, 60, 15);
      rect(0, 5, 30, 52);
      rect(0, -20, 15, 20);
      rect(20, -20, 15, 20);
      rect(-20, -20, 15, 20);
    popAll();
  }
}
