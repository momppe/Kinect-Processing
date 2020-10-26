// Made by Tom: Ver 0.6

import SimpleOpenNI.*;
import ddf.minim.*;

SimpleOpenNI kinect;
Minim minim;
AudioSnippet player;

// Zoom and Angle
float zoomF =0.9f;
float rotX = radians(165);
float rotY = radians(-10);
PFont font;
int boxSize = 100;
PVector boxPosition = new PVector(10, 10, 600);

// music
boolean InBoxPast = false;


void setup()
{
  size(1024, 768, OPENGL);
  kinect =new SimpleOpenNI(this);
  kinect.setMirror(false);
  kinect.enableDepth();
  font = loadFont("OCR_MOD-55.vlw");
  
  // music
  minim = new Minim(this);
  player = minim.loadSnippet("marcus_kellis_theme.mp3");
  //player = minim.loadSnippet("1.mp3");
  
  
}

void draw()
{
  background(#2B0A64);
  kinect.update();

  translate(width/2, height/2, 0);
  rotateY(radians(map(mouseX, 0, width, -180, 180)));
  rotateX(rotX);  
  //rotateY(rotY);
  scale(zoomF);

  int[]   depthMap = kinect.depthMap();
  int     index;
  int     steps = 10;
  PVector realWorldPoint;

  translate(0, 0, -1000);
  beginShape(POINTS);

  for (int x = 0; x < kinect.depthWidth (); x+=steps) {
    for (int y = 0; y < kinect.depthHeight (); y+=steps) {
      index = x + y * kinect.depthWidth();
      if (depthMap[index] > 0)
      {

        int TOM2;

        realWorldPoint = kinect.depthMapRealWorld()[index];

        float TOM = map(depthMap[index], 500, 1000, 0, 9); // mapping depth and number
        TOM2 = int(TOM); // change float to integer 

        textFont(font, 15);
        fill(random(0, 255), random(0, 255), random(0, 255));
        text(TOM2, realWorldPoint.x, realWorldPoint.y, realWorldPoint.z);
      }
    }
  }
  endShape();

  // Box draw
  
  PVector[] depthPoints = kinect.depthMapRealWorld();
  int opacity = 0;

  for (int i = 0; i < depthPoints.length; i += 10) {

    PVector currentPoint = depthPoints[i];
    if (currentPoint.x > boxPosition.x - boxSize/2 && currentPoint.x < boxPosition.x + boxSize/2)
    {
      if (currentPoint.y > boxPosition.y - boxSize/2 && currentPoint.y < boxPosition.y + boxSize/2)
      {
        if (currentPoint.z > boxPosition.z - boxSize/2 && currentPoint.z > boxPosition.z + boxSize/2)
        {
          opacity++;
        }
      }
    }
  }
  float boxAlpha = map(opacity, 0, 1000, 0, 255);
  
  //boolean InBoxNow = true;
  boolean InBoxNow = (opacity > 200);

  println(opacity); //check opacity value
  
  if (InBoxNow && !InBoxPast) {
    player.play();
  }

  if (!player.isPlaying()) {
    player.rewind();
    player.pause(); 
  }
  
  InBoxPast = InBoxNow;

  
  translate(boxPosition.x, boxPosition.y, boxPosition.z);
  rotateX(-50);
  //rotateY(20);
  fill(255, 5, 5, boxAlpha);
  stroke(255, 5, 5);
  box(boxSize);
  
}