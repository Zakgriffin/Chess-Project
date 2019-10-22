static GameHandler game;
static Player p1, p2;
static Board board;

static PrintWriter output;

void setup() {
  output = createWriter("print_out.txt");
  size(750, 750); // create canvas with x and y size
  rectMode(CENTER);
  pixelDensity(2);
  
  // make 2 player, 1 board, and 1 piece mover instances
  board = new Board();
  p1 = new GraphicalPlayer(color(165, 163, 158)); // white
  p2 = new Engine(color(139, 69, 19)); // black
  game = new GameHandler(board, p1, p2);
}

boolean flag;
void draw() {
  background(0);
  
  board.show();
  game.onLoop(); // handle piece moving
}
