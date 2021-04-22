/**
 * A Duodecimal Clock. 
 *
 * (c) 2021, loraxipam@github.com
 * 
 * The current time can be read with the second(), minute(), 
 * and hour() functions. In this example, sin() and cos() values
 * are used to set the position of the hands.
 *
 * MIT Licensed
 */

int cx, cy;
float secondsRadius;
float minutesRadius;
float hoursRadius;
float clockDiameter;
PFont f;

void setup() {
  size(384, 384);
  frameRate(2);
  //size(384, 384, P3D);
  //smooth(3);
  stroke(255);
  
  int radius = min(width, height) / 2;
  secondsRadius = radius * 0.72;
  minutesRadius = radius * 0.66;
  hoursRadius = radius * 0.55;
  clockDiameter = radius * 1.8;
  
  cx = width / 2;
  cy = height / 2;
  
  f = loadFont("LiberationSansNarrow-12.vlw");
  textFont(f, 16);
}

void draw() {
  background(0);
  
  // Draw the clock background
  fill(32);
  noStroke();
  ellipse(cx, cy, clockDiameter, clockDiameter);
  // the "night" side
  fill(0);
  arc(cx, cy, secondsRadius*2, secondsRadius*2, 0, PI);

  // Draw the numbers
  fill(128);
  char[] hr = {'6','8','A','0','2','4','6','8','A','0','2','4'};
  for (int t = 0; t < 12; t ++) {
      float rx, ry, tRadius;
      tRadius=secondsRadius+16;
      rx=cos(radians(t*30))*tRadius;
      ry=sin(radians(t*30))*tRadius;
      text(hr[t], cx-4+rx, cy+4+ry);
      if (t < 3 || t > 8) {
        text('1', cx-12+rx, cy+4+ry);
      }
  }
  
  // Angles for sin() and cos() start at "3 o'clock"
  // subtract 3PI/2 to make them start at the bottom
  float sec, min, hor;
  sec=second(); min=minute(); hor=hour();
  float s = map(sec, 0, 60, 0, TWO_PI) - radians(270);
  float m = map(min + norm(sec, 0, 60), 0, 60, 0, TWO_PI) - radians(270); 
  float h = map(hor + norm(min, 0, 60), 0, 24, 0, TWO_PI) - radians(270);
  
  // Draw the hands of the clock
  stroke(255);
  strokeWeight(2);
  line(cx, cy, cx + cos(m) * minutesRadius, cy + sin(m) * minutesRadius);
  strokeWeight(4);
  line(cx, cy, cx + cos(h) * hoursRadius, cy + sin(h) * hoursRadius);
  strokeWeight(1);
  // second hand is red
  stroke(255,0,0);
  line(cx, cy, cx + cos(s) * secondsRadius, cy + sin(s) * secondsRadius);
  
  stroke(255);
  // Draw the minute ticks
  //strokeWeight(2);
  beginShape(POINTS);
  for (int a = 0; a < 360; a+=6) {
    float angle = radians(a);
    float x = cx + cos(angle) * secondsRadius;
    float y = cy + sin(angle) * secondsRadius;
    if (a % 30 == 0) {
      strokeWeight(4);  // useless with P2D
    } else {
      strokeWeight(2);
    }
    vertex(x, y);
  }
  endShape();
}
