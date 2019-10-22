class Coord {
  int rank;
  int file;
  
  Coord(int rank, int file) {
    this.rank = rank;
    this.file = file;
  }
  
  boolean matches(Coord c) {
    return c.rank == rank && c.file == file;
  }
  boolean isAt(int r, int f) {
    return rank == r && file == f;
  }
  
  String toString() {
    return "("+ file + ", " + rank + ")";
  }
}
