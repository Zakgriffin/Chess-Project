class Position implements Comparable {
  ChessPiece[][] pieces;
  float value;
  Move mostRecentMove;
  Player hasTurn, notTurn;
  boolean isCheck;
  Coord turnKingCoord, opponentKingCoord; // faster to store king position than look at all pieces for checks
  
  Position(ChessPiece[][] pieces, Move mostRecentMove) {
    this.pieces = pieces;
    this.mostRecentMove = mostRecentMove;
    if(mostRecentMove != null) this.hasTurn = mostRecentMove.moved.owner;
  }
  Position(Player p1, Player p2) {
    this.pieces = new ChessPiece[8][8];
    hasTurn = p1;
    notTurn = p2;
  }
  
  void findKings() {
    for(int r = 0; r < 8; r++) {
      for(int f = 0; f < 8; f++) {
        ChessPiece maybeKing = pieces[r][f];
        if(maybeKing == null) continue;
        if(maybeKing instanceof King) {
          if(maybeKing.owner == hasTurn) turnKingCoord = new Coord(r, f);
          else opponentKingCoord = new Coord(r, f);
        }
      }
    }
  }
  
  ChessPiece[][] clonePieces() {
    ChessPiece[][] newPieces = new ChessPiece[8][8];
    for(int r = 0; r < 8; r++) {
      for(int f = 0; f < 8; f++) {
        newPieces[r][f] = pieces[r][f];
      }
    }
    return newPieces;
  }
  
  
  int compareTo(Object o) {
    Position p = (Position) o;
    if(value > p.value) return 1;
    return -1;
  }
  
  void evaluate(float base) {
    // evaluates the position for player with turn
    if(mostRecentMove.type == Type.TAKE) {
      value = base + mostRecentMove.taken.pieceValue();
    }
  }
  
  ArrayList<Move> getAllLegalMoves() {
    // returns all legal moves for player with turn
    ArrayList<Move> moves = new ArrayList<Move>();
    for(int r = 0; r < 8; r++) {
      for(int f = 0; f < 8; f++) {
        moves.addAll(getLegalMoves(r, f));
      }
    }
    return moves;
  }
  ArrayList<Move> getLegalMoves(int r, int f) {
    ArrayList<Move> legalMoves = new ArrayList<Move>(); // create list to return
    // returns legal moves for a piece at (r, f) for player with turn
    ChessPiece piece = pieces[r][f];
    if(piece == null) return legalMoves; // no piece on this tile
    if(piece.owner != hasTurn) return legalMoves; // piece of player without current turn
    piece.setTemp(this, r, f); // set temporary details to treat as static method
    
    ArrayList<Move> moves = piece.getMoves(); // get moves for this piece
    return moves;
    /*
    // check checking process
    candidateLoop: for(Move candidate : moves) { // loop over candidates
    if(candidate == null) continue;
      Position testPosition = candidate.applyTo(this); // create new position after candidate move
      if(testPosition.kingIsAttacked(testPosition.opponentKingCoord)) {
        // put king in danger or left in check: candidate move was illegal, try next move
        continue candidateLoop;
      }
      if(testPosition.kingIsAttacked(testPosition.turnKingCoord)) {
        // checking opponent
        candidate.givesCheck = true;
      }
      // candidate move was legal, add to list
      legalMoves.add(candidate);
    }
    return legalMoves;
    */
  }
  
  boolean kingIsAttacked(Coord kingCoord) {
    ArrayList<ChessPiece> straights = new ArrayList<ChessPiece>();
    straights.add(pieceInRay(kingCoord, 0, 1));
    straights.add(pieceInRay(kingCoord, 1, 0));
    straights.add(pieceInRay(kingCoord, 0, -1));
    straights.add(pieceInRay(kingCoord, -1, 0));
    for(ChessPiece piece : straights) {
      if(piece == null || piece.owner == notTurn) continue;
      if(piece instanceof Rook || piece instanceof Queen) {
        //System.out.println(kingCoord.rank + ", " + kingCoord.file);
        //System.out.println(piece);
        return true;
      }
    }
    ArrayList<ChessPiece> diagonals = new ArrayList<ChessPiece>();
    diagonals.add(pieceInRay(kingCoord, 1, 1));
    diagonals.add(pieceInRay(kingCoord, 1, -1));
    diagonals.add(pieceInRay(kingCoord, -1, 1));
    diagonals.add(pieceInRay(kingCoord, -1, -1));
    for(ChessPiece piece : diagonals) {
      if(piece == null || piece.owner == notTurn) continue;
      if(piece instanceof Bishop || piece instanceof Queen) return true;
    }
    ArrayList<ChessPiece> knights = new ArrayList<ChessPiece>();
    knights.add(pieceAt(kingCoord, 1, 2));
    knights.add(pieceAt(kingCoord, 1, -2));
    knights.add(pieceAt(kingCoord, -1, 2));
    knights.add(pieceAt(kingCoord, -1, -2));
    knights.add(pieceAt(kingCoord, 2, 1));
    knights.add(pieceAt(kingCoord, 2, -1));
    knights.add(pieceAt(kingCoord, -2, 1));
    knights.add(pieceAt(kingCoord, -2, -1));
    for(ChessPiece piece : knights) {
      System.out.println(0);
      if(piece == null || piece.owner == notTurn) continue;
      if(piece instanceof Knight) return true;
    }
    ArrayList<ChessPiece> pawns = new ArrayList<ChessPiece>();
    int x = -1;
    if(hasTurn.forward) x = 1;
    pawns.add(pieceAt(kingCoord, 1, x));
    pawns.add(pieceAt(kingCoord, -1, x));
    for(ChessPiece piece : pawns) {
      System.out.println(0);
      if(piece == null || piece.owner == notTurn) continue;
      if(piece instanceof Pawn) return true;
    }
    return false;
  }
  
  ChessPiece pieceInRay(Coord kingCoord, int rChange, int fChange) {
    int r = kingCoord.rank + rChange;
    int f = kingCoord.file + fChange;
    while(inBounds(r, f)) {
      if(pieces[r][f] != null) return pieces[r][f]; // found a piece, return it
      r += rChange;
      f += fChange;
    }
    return null;
  }
  
  ChessPiece pieceAt(Coord kingCoord, int rChange, int fChange) {
    int r2 = kingCoord.rank + rChange;
    int f2 = kingCoord.file + fChange;
    if(!inBounds(r2, f2)) return null;
    return pieces[r2][f2];
  }
  
  boolean inBounds(int r, int f) {
    // returns if (x, y) is within board
    return r >= 0 && r < 8 && f >= 0 && f < 8;
  }
}
