class GameHandler {
  Board board;
  Player p1, p2;
  Player hasTurn;
  
  GameHandler(Board board, Player p1, Player p2) {
    this.board = board;
    this.p1 = p1;
    this.p2 = p2;
    
    this.hasTurn = p1;
    p1.forward = true;
    
    board.fillBoard(p1, p2);
    p1.setBoard(board);
    p2.setBoard(board);
  }
  
  void switchPlayer() {
    if(p1 == hasTurn) hasTurn = p2;
    else hasTurn = p1;
  }
  
  void onLoop() {
    if(p1 == hasTurn) {
      Move m = p1.awaitMove();
      if(m == null) return;
      board.pos = m.applyTo(board.pos);
      p2.opponentMove(m);
    } else {
      Move m = p2.awaitMove();
      if(m == null) return;
      board.pos = m.applyTo(board.pos);
      p1.opponentMove(m);
    }
    switchPlayer();
  }
}
