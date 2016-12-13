//light blue = #62A8C1 //<>//
//brown = #6C492E
//green = #1BAA1C

color bgColor = #62A8C1;

color colorArr[];
color c1 = #6C492E;
color c2 = #1BAA1C;

int maxBranch = 15;
float startLength = height;
float angleChange = PI/2/2;
float lenChange = 0.5;
float thickness = 0.1;
float randomAngleMax = radians(15);
float randomLengthMax = 1;

float lengthMod = 1;
float angleMod = radians(1);
float changeMod = 0.01;
float thickMod = 0.1;
float randomAngleMod = radians(1);
float randomLengthMod = 1;

boolean changeBG = true;
boolean isColored = true;
boolean isThick = true;
boolean isRandomAngle = true;
boolean isRandomLength = true;

boolean isDrawing = true;
boolean isChanged = false; //<>//


/**
 * void setup()
 *
 * Setup page for processing
 **/
void setup() {
  //a 16:9 frame
  //size(1056, 594);
  fullScreen();
  if (changeBG)
    background(bgColor);
  noLoop();
  fillColorArray();
}

/**
 * void draw()
 *
 * What we want processing to draw
 **/
void draw() {
  isDrawing = true;
  background(bgColor);
  float x = width/2, y = height;
  branch(x, y, startLength);
  if (isChanged) {
    redraw();
  } else isChanged = false;
  isDrawing = false;
}

/**
 * void keyPressed()
 * 
 * Handles key presses
 **/
void keyPressed() {
  if (key == '8') {
    startLength += lengthMod;
  } else if (key == '2') {
    if (startLength - lengthMod > 0)
      startLength -= lengthMod;
  } else if (key == '4') {
    angleChange -= angleMod;
  } else if (key == '6') {
    angleChange += angleMod;
  } else if (key == '9') { 
    maxBranch++;
    fillColorArray();
  } else if (key == '3') {
    if (maxBranch > 0) {
      maxBranch--;
      fillColorArray();
    }
  } else if (key == '7') {
    lenChange += changeMod;
  } else if (key == '1') {
    lenChange -= changeMod;
  } else if (key == '+') {
    thickness += thickMod;
  } else if (key == '-' && thickness - thickMod >= 0) {
    thickness -= thickMod;
  } else if (key == '/') {
    if (randomAngleMax - randomAngleMod >= 0)
      randomAngleMax -= randomAngleMod;
    else randomAngleMax = 0;
  } else if (key == '*') {
    randomAngleMax += randomAngleMod;
  } else if(key == 'q'){
    isColored = !isColored;
  } else if(key == 'w'){
    isThick = !isThick;
    strokeWeight(maxBranch * thickness);
  } else if(key == 'e'){
    isRandomAngle = !isRandomAngle;
  } else if(key == 'r'){
    isRandomLength = !isRandomLength;
  }
  if (!isChanged) isChanged = true;
  if (!isDrawing) {
    redraw();
  }
}


/**
 * void fillColorArray()
 *
 * Fills the colour array with a gradient between the two chosen colours
 **/
void fillColorArray() {
  if (isColored) {
    float percent = 1.0/(float)(maxBranch);
    colorArr = new int[maxBranch];
    for (int i = 0; i < colorArr.length; i++) {
      colorArr[i] = lerpColor(c1, c2, percent * i);
    }
  }
}

/**
 * branch
 * @param float x         - the x coordinate to start the branch
 * @param float y         - the y coordinate to start the branch
 * @param float len     - the length of the branch
 * @param float minLen  - the minimum length of the branch (when to stop)
 **/
void branch(float x, float y, float len) {
  branch(x, y, 0, len, 0);
}

/**
 * brance
 * @param float x         - the x coordinate to start the branch
 * @param float y         - the y coordinate to start the branch
 * @param float angle   - the angle to rotate the branch (radians)
 * @param float len     - the length of the branch
 * @param float minLen  - the minimum length of the branch (when to stop)
 **/
void branch(float x, float y, float angle, float len, int counter) {
  //check that length is greater than minimum
  if (counter < maxBranch) { 
    float endX = 0, endY = 0;
    
    float newAngle;
    float newLen;
    
    float adj = cos(angle) * len, opp = len* sin(angle);

    endX = x + opp;
    endY = y - adj;

    if (isThick)
      strokeWeight((maxBranch - counter)*thickness);
    if (isColored)
      stroke(colorArr[counter]);

    line(x, y, endX, endY);

    counter++;
    
    //draw branch 1
    newAngle = angle + angleChange;
    newLen = len * lenChange;
    if (isRandomAngle) {
      newAngle += random(randomAngleMax);
    } 
    if (isRandomLength){
      newLen += random(randomLengthMax); 
    }
    branch(endX, endY, newAngle, newLen, counter);
    
    //draw branch 2
    newAngle = angle - angleChange;
    newLen = len * lenChange;
    if (isRandomAngle) {
      newAngle += random(-randomAngleMax, randomAngleMax);
    } 
    if (isRandomLength){
      newLen -= random(-randomLengthMax, randomLengthMax); 
    }
    branch(endX, endY, newAngle, newLen, counter);
  }
}