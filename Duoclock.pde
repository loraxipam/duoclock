/**
 * A Duodecimal Clock. 
 *
 * (c) 2022 loraxipam@github.com
 * 
 * Is duodecimal not to the clock as chocolate to red wine?
 *
 * This is the resizable "Overweening Chronograph" 2.0 version.
 *
 * MIT Licensed
 */

int cx, cy, prr, crr, radius;
float secondsRadius;
float minutesRadius;
float hoursRadius;
float clockDiameter;
PFont f;

void setup() {
  // the "current radius ratio," crr, is based on this size
  size(384, 384);
  prr = 1; crr = 1;
  surface.setResizable(true);
  frameRate(2);
  //size(384, 384, P3D);
  //smooth(3);
  stroke(255);
  
  f = loadFont("LiberationSansNarrow-16.vlw");
  textFont(f, 16 * crr);
}

void draw() {
  background(0);
  
  radius = min(width, height) / 2;
  crr = 2 * radius / 384;
  secondsRadius = radius * 0.75;
  minutesRadius = radius * 0.666;
  hoursRadius = radius * 0.55;
  clockDiameter = radius * 1.8;
  char[] hr = {'6','8','A','0','2','4','6','8','A','0','2','4'};
  
  cx = width / 2;
  cy = height / 2;
    
  // Draw the clock background
  fill(32);
  noStroke();
  ellipse(cx, cy, clockDiameter, clockDiameter);
  // the "night" side
  fill(0);
  arc(cx, cy, secondsRadius * 2, secondsRadius * 2, 0, PI);

  // Load a new size font if the window has changed scale
  if (crr != prr) {
    prr = crr;
    // we only go up to 4x
    if (crr > 3) {
      f = loadFont("LiberationSansNarrow-64.vlw");
    } else if (crr < 2) {
      f = loadFont("LiberationSansNarrow-16.vlw");
    } else if (crr == 2) {
      f = loadFont("LiberationSansNarrow-32.vlw");
    } else {
      f = loadFont("LiberationSansNarrow-48.vlw");
    }
    textFont(f, 16 * crr);
  }

  // Draw the numbers
  fill(128);
  for (int t = 0; t < 12; t ++) {
      float rx, ry, tRadius;
      // Push the labels out a bit
      tRadius = secondsRadius * 1.125;
      // This is where they need to go
      rx = cos(radians(t * 30)) * tRadius;
      ry = sin(radians(t * 30)) * tRadius;
      // Write them
      text(hr[t], cx-4*crr+rx, cy+4*crr+ry);
      if (t < 3 || t > 8) {
        text('1', cx-12*crr+rx, cy+4*crr+ry);
      }
  }
  
  // Angles for sin() and cos() start at "3 o'clock"
  // subtract 3PI/2 to make them start at the bottom
  float sec, min, hor;
  sec = second(); min = minute(); hor = hour();
  float s = map(sec, 0, 60, 0, TWO_PI) - radians(270);
  float m = map(min + norm(sec, 0, 60), 0, 60, 0, TWO_PI) - radians(270); 
  float h = map(hor + norm(min, 0, 60), 0, 24, 0, TWO_PI) - radians(270);
  
  // Draw the hands of the clock
  stroke(255);
  strokeWeight(2+2*crr);
  line(cx, cy, cx + cos(m) * minutesRadius, cy + sin(m) * minutesRadius);
  strokeWeight(4+4*crr);
  line(cx, cy, cx + cos(h) * hoursRadius, cy + sin(h) * hoursRadius);
  strokeWeight(1+crr);
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
      strokeWeight(4+2*crr);  // useless with P2D
    } else {
      strokeWeight(2+1*crr);
    }
    vertex(x, y);
  }
  endShape();
}
