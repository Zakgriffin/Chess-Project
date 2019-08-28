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
    int f2 = ref(file);
    int r2 = ref(rank);
    Move lastMove = pos.mostRecentMove;
    if(lastMove != null) {
      ChessPiece lastMoved = lastMove.moved;
      if(lastMoved instanceof Pawn // opponent just moved pawn
          && r2 == 3 // this pawn is on 4th rank
          && ref(lastMove.to.rank) == 3 // opponent pawn on 4th rank
          && Math.abs(ref(lastMove.to.file) - f2) == 1) { // pawns are 1 file away
        Move move = new Move();
        move.moved = this;
        move.from = new Coord(rank, file);
        move.to = new Coord(rank == 3 ? 2 : 5, lastMove.to.file);
        move.type = Type.ENPASSANT;
        move.coord2 = lastMove.to;
        moves.add(move);
      }
    }
    
    for(Move m : moves) {
      if(m == null) continue;
      if(m.to.rank == 7) m.type = Type.PROMOTE;
    }
    
    return moves;
  }
  
  int ref(int x) {
    return x < 4 ? x : 7 - x;
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
