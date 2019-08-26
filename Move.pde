static enum Type {
  MOVE, TAKE, CASTLE, PROMOTE, ENPASSANT
}

class Move {
  ChessPiece moved, taken;
  Coord from, to;
  Type type;
  boolean givesCheck;
  
  Move(ChessPiece[][] pieces, int fromR, int fromF, int toR, int toF, Type type) {
    this.moved = pieces[fromR][fromF];
    this.to = new Coord(toR, toF);
    this.from = new Coord(fromR, fromF);
    this.type = type;
    if(type == Type.TAKE) this.taken = pieces[toR][toF];
  }
  Move(ChessPiece[][] pieces, int fromR, int fromF, int toR, int toF) {
    this(pieces, fromR, fromF, toR, toF, Type.MOVE);
  }
  
  Position applyTo(Position old) {
    ChessPiece[][] newBoard = old.clonePieces();
    if(type == Type.MOVE || type == Type.TAKE) {
      newBoard[to.rank][to.file] = moved;
      newBoard[from.rank][from.file] = null;
    } else if(type == Type.CASTLE) {
      // TODO
    } else if(type == Type.ENPASSANT) {
      newBoard[to.rank][to.file] = moved;
      newBoard[from.rank][from.file] = null;
    } else if(type == Type.PROMOTE) {
      Queen newQueen = new Queen(old.hasTurn);
      newBoard[to.rank][to.file] = newQueen;
      newBoard[from.rank][from.file] = null;
    }
    Position newPos = new Position(newBoard, this);
    if(moved instanceof King) {
      newPos.turnKingCoord = new Coord(to.rank, to.file);
    } else {
      newPos.turnKingCoord = old.opponentKingCoord;
    }
    newPos.opponentKingCoord = old.turnKingCoord;
    newPos.hasTurn = old.notTurn;
    newPos.notTurn = old.hasTurn;
    return newPos;
  }
  
  boolean matches(Move m) {
    return m.from.matches(this.from) && m.to.matches(this.to);
  }
  
  boolean isLegal(Position pos) {
    if(this.moved instanceof Knight) return true;
    int rankChange = to.rank - from.rank;
    int fileChange = to.file - from.file;
    int max = max(rankChange, fileChange);
    rankChange /= max;
    fileChange /= max;
    
    int r = from.rank + rankChange;
    int f = from.file + fileChange;
    
    while(!to.isAt(r, f)) {
      if(pos.pieces[r][f] != null) return false;
      r += rankChange;
      f += fileChange;
    }
    return true;
  }
}
