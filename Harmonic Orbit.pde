import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;
int numDots = 25;
Dot[] dots;
float angle = 0;

void setup() {
  fullScreen();
  dots = new Dot[numDots];
  oscP5 = new OscP5(this, 12000);
  myRemoteLocation = new NetAddress("127.0.0.1", 57120);
  
  float maxRadius = min(width, height) * 0.4;
  float radiusStep = maxRadius / numDots;
  
  colorMode(HSB, 360, 100, 100); 
  
  for (int i = 0; i < numDots; i++) {
    float radius = maxRadius - (i * radiusStep);
    dots[i] = new Dot(radius, i + 1);
  }
}

void draw() {
  background(0);
  translate(width/2, height/2);
  
  stroke(200);
  strokeWeight(2);
  line(-width/2, 0, width/2, 0);
  line(0, -height/2, 0, height/2);
  
  for (Dot dot : dots) {
    dot.update();
    dot.display();
  }
  
  angle += 0.0004;
}

class Dot {
  float radius, revolutions;
  float x, y, prevX, prevY;
  int noteIndex;
  color dotColor;
  ArrayList<TrailPoint> trail;
  int glowTimer = 0;
  float colorFade = 0;
  int dotDiameter = 12;
  long lastTriggerTime = 0;
  
  class TrailPoint {
    float x, y;
    int age;
    float size;
    
    TrailPoint(float x, float y, float size) {
      this.x = x;
      this.y = y;
      this.age = 255;
      this.size = size;
    }
  }
  
  Dot(float r, float rev) {
    radius = r;
    revolutions = rev;
    noteIndex = int(rev) % 25;
    float hue = map(rev, 1, numDots, 0, 360);
    dotColor = color(hue, 100, 100);
    trail = new ArrayList<TrailPoint>();
  }
  
  void update() {
    prevX = x;
    prevY = y;
    x = radius * cos(angle * revolutions);
    y = radius * sin(angle * revolutions);
    
    if (frameCount % 3 == 0) {
      float currentSize = dotDiameter;
      if (glowTimer > 0) {
        currentSize = dotDiameter * (1 + glowTimer/10.0);
      }
      trail.add(new TrailPoint(x, y, currentSize));
      if (trail.size() > 50) {
        trail.remove(0);
      }
    }
    
    for (int i = trail.size() - 1; i >= 0; i--) {
      TrailPoint tp = trail.get(i);
      tp.age -= 5;
      if (tp.age <= 0) {
        trail.remove(i);
      }
    }
    
    checkCrossing();
    if (glowTimer > 0) {
      glowTimer--;
      colorFade = 1.0;
    } else if (colorFade > 0) {
      colorFade = max(0, colorFade - 0.02);
    }
  }
  
  void display() {
    noStroke();
    for (TrailPoint tp : trail) {
      if (colorFade > 0) {
        float h = hue(dotColor);
        float s = saturation(dotColor) * colorFade;
        float b = brightness(dotColor);
        fill(h, s, b, tp.age);
      } else {
        fill(100, 0, 100, tp.age);
      }
      ellipse(tp.x, tp.y, tp.size, tp.size);
    }
    
    if (colorFade > 0) {
      float h = hue(dotColor);
      float s = saturation(dotColor) * colorFade;
      float b = brightness(dotColor);
      fill(h, s, b);
    } else {
      fill(100, 0, 100);
    }
    
    float currentSize = dotDiameter;
    if (glowTimer > 0) {
      currentSize = dotDiameter * (1 + glowTimer/10.0);
    }
    ellipse(x, y, currentSize, currentSize);
    
    if (glowTimer > 0) {
      if (colorFade > 0) {
        float h = hue(dotColor);
        float s = saturation(dotColor) * colorFade;
        float b = brightness(dotColor);
        fill(h, s, b, glowTimer * 12);
      } else {
        fill(100, 0, 100, glowTimer * 12);
      }
      ellipse(x, y, currentSize * 1.5, currentSize * 1.5);
    }
  }
  
  void checkCrossing() {
    long currentTime = System.currentTimeMillis();
    if (((x > 0 && prevX <= 0) || (x < 0 && prevX >= 0) || 
         (y > 0 && prevY <= 0) || (y < 0 && prevY >= 0)) && 
         currentTime - lastTriggerTime > 300) {
      triggerNote();
      glowTimer = 20;
      lastTriggerTime = currentTime;
    }
  }
  
  void triggerNote() {
    OscMessage msg = new OscMessage("/triggerNote");
    msg.add(noteIndex);
    oscP5.send(msg, myRemoteLocation);
  }
}
