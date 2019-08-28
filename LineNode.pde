static final int willInvest = 9;
static final int searchCeiling = 4;
static int currentLevel = 0;
static float currentValue = 0;
static Engine engine;

//static int count = 0;
//static int[] all = new int[10];

class LineNode implements Comparable {
  Position pos;
  int level;
  ArrayList<LineNode> children;
  float value;
  
  LineNode(Position pos, int level) {
    //System.out.println(level);
    //all[level]++;
    //if(level == 2) count++;
    //System.out.println(count);
    this.pos = pos;
    this.level = level;
    if(level < currentLevel + searchCeiling
        && pos.value > currentValue - willInvest) {
      branch();
    } else {
      this.value = pos.value;
    }
  }
  
  void branch() {
    // get all posible moves for board position
    /*
    ArrayList<Move> moves = new ArrayList<Move>();
    for(int r = 0; r < 8; r++) {
      for(int f = 0; f < 8; f++) {
        ChessPiece on = pos.pieces[r][f];
        if(on == null || on.owner != engine) continue;
        // add moves for this piece to list
        moves.addAll(on.getLegalMoves(pos, r, f));
      }
    }*/
    ArrayList<Move> moves = pos.getAllLegalMoves();
    
    // for each possible move, create new board with that move, do things
    float total = 0;
    children = new ArrayList<LineNode>();
    float average;
    if(moves.size() > 0) {
      for(int i = 0; i < moves.size(); i++) {
        Move m = moves.get(i);
        if(m == null) continue;
        // create new position with move applied
        Position newPos = m.applyTo(this.pos);
        // evaluate new position, passing old position value as reference before take
        newPos.evaluate(this.pos.value);
        
        // create child, wait for recursive completion
        LineNode child = new LineNode(newPos, level + 1);
        //System.out.println(child.level + ": " + child.value);
        // after recursive completion, add to list
        children.add(child);
        // add to total for later average
        total += child.value;
      }
      average = (float) total / children.size();
    } else {
      System.out.println("J");
      average = -500;
    }
    this.value = average;
  }
  
  float grow() {
    if(children == null) {
      // reach dead node, add more branches
      branch();
      // return this.value to averaged by parent nodes
      return this.value;
    } else {
      // total for avaeraging
      float total = 0;
      // go through all children, get value from grow, add to total
      for(LineNode child : children) {
        total += child.grow();
      }
      this.value = total / children.size();
      return this.value;
    }
  }
  
  int compareTo(Object o) {
    LineNode l = (LineNode) o;
    return pos.compareTo(l.pos);
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
}
