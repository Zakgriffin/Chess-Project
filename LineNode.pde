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
  }
  
  float getRecursiveAverage() {
    if(children != null) {
      float total = 0;
      for(LineNode child : children) {
        total += child.getRecursiveAverage();
      }
      this.value = total / children.size();
      return this.value;
    } else if(canBranch()) {
      ArrayList<Move> moves = pos.getAllLegalMoves();
      // for each possible move, create new board with that move
      children = new ArrayList<LineNode>();
      if(moves.size() > 0) {
        for(Move m : moves) {
          if(m == null) continue;
          //if(m.type == Type.TAKE && m.piece2 instanceof King) return true;
          
          Position newPos = m.applyTo(this.pos);
          
          LineNode child = new LineNode(newPos, level + 1, engine);
          child.pos.evaluateDif(this.pos.value);
          children.add(child);
        }
      }
      this.value = this.getRecursiveAverage();
    } else {
      this.value = this.pos.value;
    }
    return this.value;
    
    
    // reached dead node, add more branches
    /*
    return branch();
    float total = 0;
    for(int i = children.size() - 1; i >= 0; i--) {
      LineNode child = children.get(i);
      if(child.grow()) children.remove(i); // child was invalid
      else total += child.value;
    }
    */
  }
  
  boolean canBranch() {
    return level < engine.currentLevel + engine.searchCeiling;
    //&& Math.abs(engine.currentValue - pos.value) <= engine.bredth)
  }
  
  int compareTo(Object o) {
    LineNode l = (LineNode) o;
    return value - l.value > 0 ? -1 : 1;
  }
  
  void printAll() {
    String spaces = new String(new char[level * 4]).replace("\0", " ");
    //if(this.value != 0)
    output.println(spaces + this.value + " : " + level + " : " + pos.mostRecentMove);
    if(children == null) return;
    for(LineNode n : children)
        n.printAll();
  }
}
