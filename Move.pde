static enum Type {
  MOVE, TAKE, CASTLE, PROMOTE, ENPASSANT
}

class Move {
  ChessPiece moved, piece2;
  Coord from, to, coord2;
  Type type;
  boolean givesCheck;
  
  Move(ChessPiece[][] pieces, int fromR, int fromF, int toR, int toF, Type type) {
    this.moved = pieces[fromR][fromF];
    this.to = new Coord(toR, toF);
    this.from = new Coord(fromR, fromF);
    this.type = type;
    if(type == Type.TAKE) this.piece2 = pieces[toR][toF];
  }
  Move(ChessPiece[][] pieces, int fromR, int fromF, int toR, int toF) {
    this(pieces, fromR, fromF, toR, toF, Type.MOVE);
  }
  Move() {}
  
  Position applyTo(Position old) {
    ChessPiece[][] newPieces = old.clonePieces();
    switch(type) {
      case MOVE: newPieces[to.rank][to.file] = moved;
        break;
      case TAKE: newPieces[to.rank][to.file] = moved;
        break;
      case CASTLE:
        
        break;
      case PROMOTE:
        Queen newQueen = new Queen(old.hasTurn);
        newPieces[to.rank][to.file] = newQueen;
        break;
      case ENPASSANT:
        newPieces[to.rank][to.file] = moved;
        newPieces[coord2.rank][coord2.file] = null;
        break;
    }
    newPieces[from.rank][from.file] = null; // remove piece from tile it came from
    
    Position newPos = new Position(newPieces, this); // create new position
    // flip turns
    newPos.hasTurn = old.notTurn;
    newPos.notTurn = old.hasTurn;
    
    // flip king coords and modify if moved
    if(moved instanceof King) {
      newPos.opponentKingCoord = new Coord(to.rank, to.file);
      newPos.opponentCanCastleKing = false;
    }
    else newPos.opponentKingCoord = old.turnKingCoord;
    newPos.turnKingCoord = old.opponentKingCoord;
    
    return newPos;
  }
  
  boolean matches(Move m) {
    return m.from.matches(this.from) && m.to.matches(this.to);
  }
}
