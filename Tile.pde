class Tile {
  Board board;
  Clickable square;
  color col;
  int r, f;
  
  Tile(float x, float y, color col, int r, int f, Board board) {
    PVector pos = new PVector(x, y);
    square = new Clickable(pos, width / 8, height / 8);
    this.col = col;
    this.r = r;
    this.f = f;
    this.board = board;
  }
  
  ChessPiece getPiece() {
    return board.pos.pieces[r][f];
  }
  
  void show() {
    show(-1);
  }
  void show(color c) {
    if(c == -1) { // no color passed
      if(square.isHovered()) {
        int bright = -50;
        c = color(red(col) + bright,
                  green(col) + bright,
                  blue(col) + bright);
      } else {
        c = col;
      }
    }
    pushStyle();
      noStroke();
      fill(c);
      rect(square.center.x,
           square.center.y,
           square.sizeX,
           square.sizeY);
    popStyle();
    ChessPiece piece = board.pos.pieces[r][f];
    if(piece != null) {
      piece.show(square.center.x, square.center.y);
    }
  }
}
