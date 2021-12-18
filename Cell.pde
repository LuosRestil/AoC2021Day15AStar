class Cell {
  int row;
  int col;
  int cost;
  int g;
  float f;
  float h;
  float cellWidth;
  float cellHeight;
  ArrayList<Cell> neighbors;
  Cell cameFrom;
 
  Cell(int row, int col, int cost, float cellWidth, float cellHeight) {
    this.row = row;
    this.col = col;
    this.cost = cost;
    this.cellWidth = cellWidth;
    this.cellHeight = cellHeight;
  }
  
  void show(float r, float g, float b) {
     fill(r, g, b);
     rect(this.col * cellWidth, this.row * h, cellWidth, cellHeight);
  }
  
  void addNeighbors(ArrayList<ArrayList<Cell>> grid) {
    if (this.row < grid.size() - 1) {
      this.neighbors.add(grid.get(this.row + 1).get(this.col));
    }
    if (this.row > 0) {
      this.neighbors.add(grid.get(this.row - 1).get(this.col));
    }
    if (this.col < grid.get(0).size() - 1) {
      this.neighbors.add(grid.get(this.row).get(this.col + 1));
    }
    if (this.col > 0) {
      this.neighbors.add(grid.get(this.row).get(this.col - 1));
    }
  }
}
