final int TIME_INTERVAL = 100; //<>//
final int SNAKE_LENGTH = 3;
final int CELL_SIZE = 20;
final int TEXT_SIZE = 24;
final int MAX_HITS = 5;
final color SNAKE_COLOR = #3498db;
final color FOOD_COLOR = #ff3636;
int score = 0;
int totalHits = 0;
int lastTimeCheck = 0;
String direction = "";
String directionQueue = "";
PVector food = new PVector(0, 0);
ArrayList<PVector> foodCoordinates = new ArrayList<PVector>();
ArrayList<PVector> snakePos = new ArrayList<PVector>();
boolean overRestart = false;
boolean overExit = false;

void setup() {
 size(500, 500);
 textSize(TEXT_SIZE);
 for (float i = 0; i <= width - CELL_SIZE; i += CELL_SIZE) {
   for (float j = 0; j <= height - CELL_SIZE; j += CELL_SIZE){
      foodCoordinates.add(new PVector(i, j)); 
   }
 }
 //frameRate(10);
 direction = "up";
 directionQueue = "up";
 createSnake();
 createFood();
}


void draw() {
 if (millis() > lastTimeCheck + TIME_INTERVAL) {
  if (totalHits == MAX_HITS){
    displayExitOption();
    return;
  }
   
  PVector head = snakePos.get(0);
  // checking for wall collisions
  if (checkIfBorderHit(head)) {
   createSnake();
   createFood();
   directionQueue = "up";
   score = 0;
   totalHits += 1;
  }
  // checking for colisions with snake's body
  for (int i = 1; i < snakePos.size(); i++) {
   if (checkCollision(head, snakePos.get(i))) {
    createSnake();
    createFood();
    directionQueue = "up";
    score = 0;
    totalHits += 1;
   }
  }
  // checking for collision with food
  if (checkCollision(head, food)) {
   snakePos.add(new PVector(head.x, head.y)); //<>//
   createFood();
   score += 10;
  }

  setBackground(#ffffff, #eeeeee);
  drawSnake();
  drawFood();
  moveSnake();
  text("Score: " + str(score), 10, TEXT_SIZE);
  text("Lives: " + str(MAX_HITS - totalHits), 10, TEXT_SIZE*2 + 10);
  lastTimeCheck = millis();
 }
}

void displayExitOption(){
  background(color(102));
  int buttonHeight = 30;
  int buttonWidth = 100;
  color buttonColor = color(0);
  color buttonHighlight = color(51);
  PVector exit = new PVector((width - buttonWidth)/2, (height - buttonHeight)/2);
  PVector restart = new PVector((width - buttonWidth)/2, (height - buttonHeight*3)/2);
  
  String gameoverText = "GAMVE OVER";
  fill(0);
  text(gameoverText, (width - textWidth(gameoverText))/2, TEXT_SIZE+10);
  fill(0);
  text(str(score), (width - textWidth(str(score)))/2, TEXT_SIZE*2+10);
  
  if (overRestart) {
    fill(buttonHighlight);
  } else {
    fill(buttonColor);
  }
  
  stroke(255);
  rect(restart.x, restart.y, buttonWidth, buttonHeight);
  fill(255);
  String restartText = "Restart";
  text(restartText, restart.x + (buttonWidth - textWidth(restartText))/2, restart.y+buttonHeight-textDescent());
  
  if (overExit) {
    fill(buttonHighlight);
  } else {
    fill(buttonColor);
  }
  
  rect(exit.x, exit.y, buttonWidth, buttonHeight);
  fill(255);
  String exitText = "Exit";
  text(exitText, exit.x + (buttonWidth - textWidth(exitText))/2, exit.y+buttonHeight-textDescent());
  stroke(0);
  
  if (overButton(restart.x, restart.y, buttonWidth, buttonHeight)) {
    overRestart = true;
    overExit = false;
  }
  else if (overButton(exit.x, exit.y, buttonWidth, buttonHeight)) {
    overRestart = false;
    overExit = true;
  }
  else {
    overRestart = overExit = false;
  }
  stroke(0);
}

boolean checkIfBorderHit(PVector head){
  return head.x < 0 || head.x > width - CELL_SIZE || head.y < 0 || head.y > height - CELL_SIZE;
}

// draws a ellipse.. obviously
void drawEllipse(PVector vector, color squarecolor) {
 fill(squarecolor);
 strokeWeight(2);
 ellipse(vector.x + CELL_SIZE / 2, vector.y + CELL_SIZE / 2, CELL_SIZE, CELL_SIZE);
 strokeWeight(1);
}

// giving the food object its coordinates
void createFood() {
 food = foodCoordinates.get(floor(random(foodCoordinates.size())));
 // looping through the snake and checking if there is a collision
 for (int i = 0; i < snakePos.size(); i++) {
  if (checkCollision(food, snakePos.get(i))) {
   createFood();
  }
 }
}

//controls:
void keyPressed() {
 if (key == CODED) {
  if (keyCode == LEFT && direction != "right") {
   directionQueue = "left";
  } else if (keyCode == UP && direction != "down") {
   directionQueue = "up";
  } else if (keyCode == RIGHT && direction != "left") {
   directionQueue = "right";
  } else if (keyCode == DOWN && direction != "up") {
   directionQueue = "down";
  }
 }
}

// drawing food on the canvas
void drawFood() {
 drawEllipse(food, FOOD_COLOR);
}

// setting the colors for the canvas. color1 - the background, color2 - the line color
void setBackground(color color1, color color2) {
 fill(color1);
 stroke(color2);
 rect(0, 0, height, width);
 for (float x = 0.5; x < width; x += CELL_SIZE) {
  line(x, 0, x, height);
 }
 for (float y = 0.5; y < height; y += CELL_SIZE) {
  line(0, y, width, y);
 }

 stroke(0);
}

// creating the snake in the middle on the grid
void createSnake() {
 snakePos = new ArrayList<PVector>();
 for (int i = 0; i < SNAKE_LENGTH; i++) {
  int x =  (height - CELL_SIZE)/2;
  int y = (height - CELL_SIZE)/2 + i * CELL_SIZE;
  snakePos.add(new PVector(x, y));
 }
}

// loops through the snake array and draws each element
void drawSnake() {
 for (int i = 0; i < snakePos.size(); i++) {
  drawEllipse(snakePos.get(i), SNAKE_COLOR);
 }
}

void moveSnake() {
 float x = snakePos.get(0).x; // getting the head coordinates.
 float y = snakePos.get(0).y;

 direction = directionQueue;

 if (direction == "right") {
  x += CELL_SIZE;
 } else if (direction == "left") {
  x -= CELL_SIZE;
 } else if (direction == "up") {
  y -= CELL_SIZE;
 } else if (direction == "down") {
  y += CELL_SIZE;
 }

 // removes the tail and makes it the new head...
 PVector tail = snakePos.remove(snakePos.size() - 1);
 tail.x = x;
 tail.y = y;
 snakePos.add(0, tail);
}

// checks if too coordinates match up
boolean checkCollision(PVector vector1, PVector vector2) {
 if (vector1.x == vector2.x && vector1.y == vector2.y) {
  return true;
 } else {
  return false;
 }
}


void mousePressed() {
  if (overRestart) {
   createSnake();
   createFood();
   directionQueue = "up";
   score = 0;
   totalHits = 0;
  }
  if (overExit) {
   exit();
  }
}

boolean overButton(float x, float y, float width, float height)  {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}
