class Position {
  ChessPiece[][] pieces;
  Move mostRecentMove;
  Player hasTurn, notTurn;
  int value;
  
  boolean turnCanCastleKing, turnCanCastleQueen;
  boolean opponentCanCastleKing, opponentCanCastleQueen;
  
  Position(Position old, Move mostRecentMove, ChessPiece[][] pieces) {
    this.pieces = pieces;
    this.mostRecentMove = mostRecentMove;
    
    this.hasTurn = old.notTurn;
    this.notTurn = old.hasTurn;
  }
  Position(Player p1, Player p2) {
    // initial contructor
    this.pieces = new ChessPiece[8][8];
    hasTurn = p1;
    notTurn = p2;
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
  
  void evaluateDif(int oldPosValue) {
    // evaluates the position for player with turn
    if(mostRecentMove == null) return;
    if(mostRecentMove.type == Type.TAKE) {
      this.value = oldPosValue + mostRecentMove.piece2.pieceValue();
    } else {
      this.value = oldPosValue;
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
    return piece.getMoves(); // get moves for this piece
  }
  
  boolean inBounds(int r, int f) {
    // returns if (x, y) is within board
    return r >= 0 && r < 8 && f >= 0 && f < 8;
  }
}
