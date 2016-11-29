
// These important flags indicate which role(s) this program is taking on.  We tend to flip between bWorkOnAnimation
// and bRunAnimation while working in this way
boolean bWorkOnAnimation = false;
boolean bRunAnimation = true;
boolean bRecord = false;

PImage background;
Poses poses;
ArrayList<StickFigure> sequence;
AnimatedFigure fig1;
AnimatedFigure fig2;

int nCurrentPose;
StickFigure stickFigure;
StickFigure onionSkin;

void setup() {
  size(800, 600);
  strokeWeight(18);

  background = loadImage("background.png");
  poses = new Poses();

  sequence = poses.pulled;  // We set this to the sequence we're currently working on
  
  setCurrentPose(sequence.size() - 1); // And we usually want to start with the last frame

  fig1 = new AnimatedFigure();
  fig1.resetFig1();

  fig2 = new AnimatedFigure();
  fig2.resetFig2();

}

void draw() {
  image(background, 0, 0);

  if (bRunAnimation == true) {
    stroke(0, 255);
    fill(0, 255);

    int nFrame = (frameCount) % max(fig1.lastFrame(), fig2.lastFrame());
    
    if (nFrame < frameCount) {
      bRecord = false;
    }
    
    fig1.draw(nFrame);
    fig2.draw(nFrame);
  }
  
  if (bWorkOnAnimation) {

    if (onionSkin != null) {
      stroke(0, 128);
      fill(0, 128);
  
      onionSkin.draw();
    }
  
    stroke(0, 255);
    fill(0, 255);
  
    if (stickFigure != null) {
      stickFigure.draw();
      stickFigure.drawPoints();
    }
  
    text("Current pose " + nCurrentPose, 10, 10);
  }

  if (bRecord && (frameCount % 5 == 0)) {
    saveFrame("TheClimb-######.png");
  }
}

void mousePressed() {
  if (bWorkOnAnimation) {
    stickFigure.mousePressed();
  }
}

void mouseReleased() {
  if (bWorkOnAnimation) {
    stickFigure.mouseReleased();
  }
}

void mouseDragged() {
  if (bWorkOnAnimation) {
    stickFigure.mouseDragged();
  }
}

void keyPressed() {
  if (bWorkOnAnimation) {
    char key = Character.toLowerCase((char)keyCode);
  
    switch(key) {
    case 'p':
      stickFigure.print();
      break;
  
    case 'n':
      sequence.add(stickFigure.copy());
      setCurrentPose(sequence.size() - 1);
      break;
    }
  
    switch (keyCode) {
    case LEFT:
      if (nCurrentPose > 0) {
        setCurrentPose(nCurrentPose - 1);
      }
      break;
      
    case RIGHT:
      if (nCurrentPose + 1 < sequence.size()) {
        setCurrentPose(nCurrentPose + 1);
      }
    }
  }
}

void setCurrentPose(int nPose) {

  nCurrentPose = nPose;
  
  if (nPose >= 0 && nPose < sequence.size()) {
    stickFigure = sequence.get(nPose);
  } else {
    stickFigure = null;
  }

  if (nPose - 1 >= 0 && nPose - 1 < sequence.size()) {
    onionSkin = sequence.get(nPose - 1);
  } else {
    onionSkin = null;
  }

}
