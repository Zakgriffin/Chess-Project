class Engine extends Player {
  LineNode currentPosNode;
  
  Engine(color col) {
    super(col);
    engine = this;
  }
  
  void setBoard(Board board) {
    this.currentPosNode = new LineNode(board.pos, 0);
  }
  
  Move awaitMove() {
    // grow all dead nodes by 1, maybe more if sac-esque situation
    currentPosNode.grow();
    
    // long pause...
    
    /*for(int i = 0; i < 6; i++) {System.out.print(i + ": " + all[i] + ", ");}
    for(int i = 0; i < 6; i++) {all[i] = 0;}
    System.out.println();*/
    
    // update currentPosNode to best move node
    currentPosNode = currentPosNode.children.get(currentPosNode.children.size() - 1);
    // best move is most recently made
    Move best = currentPosNode.pos.mostRecentMove;
    currentLevel++;

    return best;
  }
  
  void opponentMove(Move m) {
    // update currentPosNode, increment currentLevel
    
    for(LineNode node : currentPosNode.children) {
      // get the last move made by the player
      Move candidate = node.pos.mostRecentMove;
      //System.out.println(candidate.to.rank + "," + candidate.to.file);
      if(m.matches(candidate)) {
        currentPosNode = node;
        break;
      }
    }
    currentLevel++;
  }
}

/*

find all potential moves, put in arraylist
evaluate point difference if was a take
sort arraylist
propagate value back up line
look at highest in list
create new LineNode with this position
constructor: branch repeat IF 

*/
