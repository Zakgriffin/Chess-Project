class LineNode implements Comparable {
  Engine engine;
  Position pos;
  int level;
  ArrayList<LineNode> children;
  float value;
  
  LineNode(Position pos, int level, Engine engine) {
    this.engine = engine;
    this.pos = pos;
    this.level = level;
    if(level < engine.currentLevel + engine.searchCeiling
        ) {//&& Math.abs(engine.currentValue - pos.value) <= engine.bredth) {
      branch();
    } else {
      this.value = pos.value;
    }
  }
  
  boolean branch() {
    // get all posible moves for board position
    ArrayList<Move> moves = pos.getAllLegalMoves();
    
    // for each possible move, create new board with that move, do things
    children = new ArrayList<LineNode>();
    if(moves.size() > 0) {
      for(Move m : moves) {
        if(m == null) continue;
        if(m.type == Type.TAKE && m.piece2 instanceof King) return true;
        
        Position newPos = m.applyTo(this.pos); // create new position with move applied
        
        LineNode child = new LineNode(newPos, level + 1, engine); // create child, wait for recursive completion
        children.add(child); // after recursive completion, add to list
      }
    } else {
      System.out.println("Checkmate Found");
      this.value = -500;
    }
    return false;
  }
  
  boolean grow() {
    if(children != null) {
      // total for averaging
      float total = 0;
      // go through all children, get value from grow, add to total
      for(int i = children.size() - 1; i >= 0; i--) {
        LineNode child = children.get(i);
        if(child.grow()) children.remove(i); // child was invalid
        else total += child.value;
      }
      this.value = -total / children.size();
      return false;
    } else {
      // reach dead node, add more branches
      return branch();
    }
  }
  
  int compareTo(Object o) {
    LineNode l = (LineNode) o;
    return value - l.value < 0 ? -1 : 1;
  }
}
