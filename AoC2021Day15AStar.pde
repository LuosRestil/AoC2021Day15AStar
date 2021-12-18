import java.util.stream.Collectors;

String[] input;  
ArrayList<ArrayList<Cell>> grid;
ArrayList<Cell> openSet;
ArrayList<Cell> closedSet;
Cell start;
Cell end;
float w;
float h;
Cell current;
long startTime = System.currentTimeMillis();

void setup() {
  size(600,600);
  input = loadStrings("input.txt");
  
  w = width / input[0].length();
  h = height / input.length;
  
  openSet = new ArrayList<>();
  closedSet = new ArrayList<>();
  
  grid = new ArrayList<>();
  
  for (int i = 0; i < input.length; i++) {
    String[] numStrings = input[i].split("");
    ArrayList<Cell> cells = new ArrayList<>();
    for (int j = 0; j < numStrings.length; j++) {
      cells.add(new Cell(i, j, Integer.parseInt(input[i].substring(j, j + 1)), w, h));
    }
    grid.add(cells);
  };
  
  // Pt .2 expand grid and increment values
  for (int i = 0; i < grid.size(); i++) {
    ArrayList<Cell> row = grid.get(i);
    
  }
  
  
  for (int i = 0; i < grid.size(); i++) {
    for (int j = 0; j < grid.get(0).size(); j++) {
      grid.get(i).get(j).addNeighbors(grid); 
    }
  }
  
  start = grid.get(0).get(0);
  end = grid.get(grid.size() - 1).get(grid.get(0).size() - 1);
  
  openSet.add(start);
}

void draw() {
  if (openSet.size() > 0) {
    // we can keep going
    int winner = 0;
    for (int i = 0; i < openSet.size(); i++) {
      if (openSet.get(i).f < openSet.get(winner).f) {
        winner = i; 
      }
    }
    
    current = openSet.get(winner);
    
    // add winner to closedSet
    closedSet.add(current);
    // remove winner from openSet
    openSet.remove(winner);
    
    // evaluate neighbors
    ArrayList<Cell> neighbors = current.neighbors;
    for (int i = 0; i < neighbors.size(); i++) {
      Cell neighbor = neighbors.get(i);
      if (!closedSet.contains(neighbor)) {
        int tentativeG = neighbor.cost + current.g;
        boolean newPath = false;
        if (openSet.contains(neighbor)) {
          if (tentativeG < neighbor.g) {
            neighbor.g = tentativeG;
            newPath = true;
          }
        } else {
          neighbor.g = tentativeG;
          openSet.add(neighbor);
          newPath = true;
        }
        
        neighbor.h = heuristic(neighbor, end);
        neighbor.f = neighbor.g + neighbor.h;
        if (newPath) {
          neighbor.cameFrom = current; 
        }
      }
    }
    
  } else {
    write("NO SOLUTION :-(");
    noLoop();
    return;
  }
  
  background(0);
  
  for (int i = 0; i < grid.size(); i++) {
    for (int j = 0; j < grid.get(0).size(); j++) {
      grid.get(i).get(j).show(255, 255, 255); 
    }
  }
  
  for (int i = 0; i < openSet.size(); i++) {
    openSet.get(i).show(0, 255, 0);
  }
  
  for (int i = 0; i < closedSet.size(); i++) {
    closedSet.get(i).show(255, 0, 0);
  }
  
  showPath(current);
  
  if (current == end) {
    long cost = calculatePathCost(current);
    write("DONE! Cost: " + (cost - start.cost));
    int hrs = 0;
    int mins = 0;
    int seconds = ((int) (System.currentTimeMillis() - startTime)) / 1000;
    while (seconds >= 60) {
      seconds -= 60;
      mins++;
      if (mins == 60) {
         hrs++;
         mins = 0;
      }
    }
    print(String.format("Execution time: %dh %dm %ds", hrs, mins, seconds));
    noLoop();
    return;
  }
}

float heuristic(Cell a, Cell b) {
  return dist(a.col, a.row, b.col, b.row);
};

void showPath(Cell current) {
  ArrayList<Cell> path = new ArrayList<>();
  Cell p = current;
  path.add(p);
  while (p.cameFrom != null) {
    p = p.cameFrom;
    path.add(p);
  }
  for (int i = 0; i < path.size(); i++) {
     path.get(i).show(150, 150, 225);
  }
}

long calculatePathCost(Cell current) {
  long cost = 0L;
  Cell p = current;
  cost += p.cost;
  while (p.cameFrom != null) {
    p = p.cameFrom;
    cost += p.cost;
  }
  return cost;
};

void write(String text) {
  fill(0);
  textSize(80);
  textAlign(CENTER);
  text(text, width / 2, height / 2);
}
