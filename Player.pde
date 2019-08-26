abstract class Player {
  boolean forward;
  color col;
  
  Player(color col) {
    this.col = col;
  }
  
  abstract void setBoard(Board board);
  abstract Move awaitMove();
  abstract void opponentMove(Move m);
}
