class Bishop extends ChessPiece {
  Bishop(Player p) {
    super(p);
  }
  
  int pieceValue() {return 3;}
  
  ArrayList<Move> getMoves() {
    ArrayList<Move> moves = new ArrayList<Move>();
    moves.addAll(ray(1, 1));
    moves.addAll(ray(-1, 1));
    moves.addAll(ray(1, -1));
    moves.addAll(ray(-1, -1));
    return moves;
  }
  
  void show(float x, float y) {
    pushAll(x, y);
      rect(0, 35, 60, 15);
      ellipse(0, -8, 25, 40);
      triangle(0, -10, 20, 30, -20, 30);
      circle(0, -32, 15);
      ellipse(0, 3, 40, 10);
      //rotate(0.4);
      //fill(0);
      //rect(2, -17, 4, 20);
    popAll();
  }
}
