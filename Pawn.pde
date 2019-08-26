class Pawn extends ChessPiece {
  Pawn(Player p) {
    super(p);
  }
  
  int pieceValue() {return 1;}
  
  ArrayList<Move> getMoves() {
    ArrayList<Move> moves = new ArrayList<Move>();
    // moving forward
    ChessPiece ahead = pieceAt(0, 1);
    if(ahead == null) {
      moves.add(at(0, 1));
    }
    
    // moving ahead by 2 on first move
    ChessPiece ahead2 = pieceAt(0, 2);
    if((rank == 1 || rank == 6) && ahead == null && ahead2 == null) moves.add(at(0, 2));
    
    // taking diagonally
    if(pieceAt(1, 1) != null) moves.add(at(1, 1));
    if(pieceAt(-1, 1) != null) moves.add(at(-1, 1));
    
    // en passant
    Move lastMove = pos.mostRecentMove;
    if(rank == 3 || rank == 4) {
      if(lastMove.moved instanceof Pawn) {
        Move fish = null;
        if(rank == 3) {
          if(lastMove.from.rank == 1 && lastMove.to.rank == 3) fish = at(2, lastMove.from.file);
        } else {
          if(lastMove.from.rank == 6 && lastMove.to.rank == 4) fish = at(2, lastMove.from.file);
        }
        if(fish != null) {
          fish.type = Type.ENPASSANT;
          fish.taken = lastMove.moved;
          moves.add(fish);
        }
      }
    }
    
    for(Move m : moves) {
      if(m == null) continue;
      if(m.to.rank == 7) m.type = Type.PROMOTE;
    }
    
    return moves;
  }
  
  void show(float x, float y) {
    pushAll(x, y);
      rect(0, 35, 60, 15);
      circle(0, -15, 30);
      bezier(0, -15, 5, -10, 40, 40, -5, 30);
      bezier(0, -15, -5, -10, -40, 40, 5, 30);
    popAll();
  }
}
