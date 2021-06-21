int gridSpacing = 18;
int cellsNumber = 0;

Cell[][] cells = new Cell[1][1];  

boolean isPaused = true;

int simulSpeed = 10; //frames to Update
int frameCounter = 0;

PFont font;  


//mouseDrag

int lastX = 0;
int lastY = 0;

void setup()
{
  println(width);
  println(width / gridSpacing);
  
  size(700, 700);
  cellsNumber = width / gridSpacing;
  
  cells = new Cell[cellsNumber][cellsNumber];
  
 // font = createFont("Arial",1,true);
  
  background(51);
  for (int i = 0; i < cellsNumber; i++) {
  for (int j = 0; j < cellsNumber; j++) {
    cells[i][j] = new Cell();
  }
  }
}

void draw()
{
  frameRate(60);
  clear();
  
  drawGrid(gridSpacing);
  drawInstructions();
  
  if( ! isPaused && (frameCounter > simulSpeed))
  {
    updateCellsState();
    frameCounter = -1;
  }
  
  drawCells();
  drawInstructions();
    
  frameCounter ++;
}

void keyPressed()
{
   if (key == 'r' || key == 'R')
     if(isPaused)
       isPaused = false;
     else
       isPaused = true;
       
   if (key == CODED) 
  {

    switch (keyCode)
    {
      case UP: simulSpeed -= 2;  break;
      case DOWN: simulSpeed +=2;
    }
    if (simulSpeed <= 1)
    simulSpeed = 1;
  }
}

void drawCells()
{
  stroke(240);
  fill (220);
  for (int i = 0; i < cellsNumber; i++)
  {
    for (int j = 0; j < cellsNumber; j++)
      {
        if(cells[i][j].isAlive())
          rect(i*gridSpacing, j*gridSpacing,  gridSpacing, gridSpacing );
      }
  }
}

void updateCellsState()
{
  int[][] liveNeighbours = countAllLiveNeighbours();
  
    for (int i = 0; i < cellsNumber; i++)
    {
      for (int j = 0; j < cellsNumber; j++)
      {
        int neighbours = liveNeighbours [i] [j];
        boolean cellWasAlive = cells[i][j].isAlive();
        if(cellWasAlive)
        {
        if (neighbours < 2)
          cells[i][j].die();
        else
        if (neighbours > 3)
          cells[i][j].die();
        }
        
        if( ! cellWasAlive && neighbours == 3)
         cells[i][j].born();
      }
  }
}

int[][] countAllLiveNeighbours()
{
  int[][] liveNeighbours = new int[cellsNumber][cellsNumber]; 
      for (int i = 0; i < cellsNumber; i++)
    {
      for (int j = 0; j < cellsNumber; j++)
      {
        liveNeighbours[i][j] = countLiveNeighbours(i, j, cellsNumber);
      }
  }
  return liveNeighbours;
}

int countLiveNeighbours(int x, int y, int arraySize)
{
  int nOfLiveNeighbours = 0;
  for (int i = x-1; i <= x+1; i++)
  {
    for (int j = y-1; j <= y+1; j++)
      {
        if(i < arraySize && j < arraySize && i >= 0 && j >= 0) //BOUNDARY CHECK
          if(cells[i][j].isAlive() &&  ! (i == x && j == y)) //to make sure we don't count ourselves
            nOfLiveNeighbours++;
      }
  }
 // println("LiveNeighbours: ", nOfLiveNeighbours);
  return nOfLiveNeighbours;
}

void mousePressed() 
{
  int cellColumn = mouseX / gridSpacing;
  int cellRow = mouseY / gridSpacing;
    println(cellColumn, cellRow);
  cells[cellColumn][cellRow].switchState();
    lastX = cellColumn;
    lastY = cellRow;
}

void mouseDragged() 
{
  int cellColumn = mouseX / gridSpacing;
  int cellRow = mouseY / gridSpacing;
  
  if ( cellColumn <cellsNumber && cellRow < cellsNumber && cellColumn >= 0 && cellRow >= 0) //Boundary Check
    if(lastX != cellColumn || lastY != cellRow )
    {
      cells[cellColumn][cellRow].switchState();
      lastX = cellColumn;
      lastY = cellRow;
    }
}

void drawGrid(int gridSpacing)
{
  stroke(120);
  for(int i = gridSpacing; i < width + gridSpacing; )
  {
    line(0,i, width, i);
    line(i,0, i, height);
    i+=gridSpacing;
  }
}

void drawInstructions()
{
  fill(255, 120, 120);
  textSize(26);
  text("Press 'R' to start and pause the Game",0,height-40);
  text("Up and Down to Change Speed",0,height-20);
  textSize (22);
  
  text("Speed :", 0, 22);
  text( String.format("%.0f", 1 / float(simulSpeed) * 1000000, 0), 80, 22);
  
}