class GraphicalPlayer extends Player {
  Tile[][] spaces;
  Tile selected;
  Board board;
  
  GraphicalPlayer(color col) {
    super(col);
  }
  
  void setBoard(Board board) {
    this.spaces = board.spaces;
    this.board = board;
  }
  
  void opponentMove(Move m) {}
  
  Move awaitMove() {
    // find hovered space and setting selected space if clicked
    Tile hovered = null;
    boolean tryMove = false;
    Coord coord = null;
    outer: for(int r = 0; r < 8; r++) {
      for(int f = 0; f < 8; f++) {
        Tile s = spaces[r][f];
        if(s.square.isHovered()) {
          // found hovered square
          ChessPiece piece = board.pos.pieces[r][f];
          if(piece != null && piece.owner == this) {
            // piece on same team
            hovered = s;
            if(s.square.isClicked()) {
              if(s == selected) selected = null; // unselected
              else selected = s; // selected new square
            }
          } else if(selected != null && s.square.isClicked()) {
            // trying to move
            tryMove = true;
          }
          coord = new Coord(r, f);
          break outer; // stop searching
        }
      }
    }
    if(coord == null) return null;
    
    // setting showMove to which ever should be show
    Tile showMove = null;
    if(selected != null) {
      showMove = selected;
    } else if(hovered != null)  {
      showMove = hovered;
    }
    
    // show potential moves
    if(showMove != null && showMove.getPiece() != null) {
      ArrayList<Move> moves = board.pos.getLegalMoves(showMove.r, showMove.f);
        for(Move m : moves) {
          if(m == null) continue;
          PVector v = spaces[m.to.rank][m.to.file].square.center;
          if(tryMove && m.to.matches(coord)) {
            selected = null;
            return m;
          }
          pushStyle();
            noStroke();
            if(m.type == Type.TAKE) fill(255, 255, 0); // yellow
            else fill(0, 255, 0); // green
            circle(v.x, v.y, 15);
          popStyle();
      }
    }
    
    // color background square of selected
    if(selected != null) {
      selected.show(color(0, 0, 255));
    }
    return null;
  }
}
