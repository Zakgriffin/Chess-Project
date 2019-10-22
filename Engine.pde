import java.util.Collections;

class Engine extends Player {
  LineNode currentPosNode;
  
  final int bredth = 12;
  final int searchCeiling = 3;
  int currentLevel = 0;
  float currentValue = 0;
  
  Engine(color col) {
    super(col);
  }
  
  void setBoard(Board board) {
    this.currentPosNode = new LineNode(board.pos, 0, this);
    currentPosNode.getRecursiveAverage();
  }
  
  Move awaitMove() {
    // grow all dead nodes by 1, maybe more if sac-esque situation
    currentPosNode.getRecursiveAverage();
    
    if(currentPosNode.level == 1) {
      currentPosNode.printAll();
      output.flush(); // Writes the remaining data to the file
      output.close(); // Finishes the file
    }
    
    // long pause...
    
    // update currentPosNode to best move node
    Collections.sort(currentPosNode.children);
    
    currentPosNode = currentPosNode.children.get(0);
    System.out.println(currentPosNode.value);
    // best move is most recently made
    Move best = currentPosNode.pos.mostRecentMove;
    currentLevel++;
    currentValue = currentPosNode.value;

    return best;
  }
  
  void opponentMove(Move m) {
    // update currentPosNode, increment currentLevel
    
    for(LineNode node : currentPosNode.children) {
      // get the last move made by the player
      Move candidate = node.pos.mostRecentMove;
      if(m.matches(candidate)) {
        currentPosNode = node;
        break;
      }
    }
    currentLevel++;
    currentValue = currentPosNode.value;
  }
}
