
StickFigure start;
StickFigure end;
StickFigure oldStart;
StickFigure oldEnd;
StickFigure initialPose;
int nReturning = 0;
float nReturnSteps = 120;

void setup() {
  size(800, 600);
  colorMode(HSB);
  strokeWeight(18);
  start = new StickFigure(50);
  end = new StickFigure(50);
  initialPose = new StickFigure(50);
}

final int RED    = 0 * 255 / 12;
final int ORANGE = 1 * 255 / 12;
final int YELLOW = 2 * 255 / 12;
final int GREEN  = 3 * 255 / 12;
final int BLUE   = 4 * 255 / 12;
final int INDIGO = 5 * 255 / 12;
final int VIOLET = 6 * 255 / 12;

int getColor(int nIndex) {
  switch(nIndex) {
  case 0:  return RED;
  case 1:  return ORANGE;
  case 2:  return YELLOW;
  case 3:  return GREEN;
  case 4:  return BLUE;
  case 5:  return INDIGO;
  default: return VIOLET;
  }
}

void draw() {
  background(255);

  if (nReturning > 0) {
    --nReturning;
    start.tween(nReturning / nReturnSteps, initialPose, oldStart);
    end.tween(nReturning / nReturnSteps, initialPose, oldEnd);
  }

  int nColor = 0;

  stroke(getColor(nColor), 255, 255);
  fill(getColor(nColor), 255, 255);
  start.draw();
  fill(0);
  start.drawPoints();
  ++nColor;

  for (float t = 1.0/7.0; t < 1.0; t += 1.0/7.0) {
    stroke(getColor(nColor), 255, 255);
    fill(getColor(nColor), 255, 255);
    StickFigure tween = new StickFigure(50);
    tween.tween(t, start, end);
    tween.draw();
    ++nColor;
  }

  stroke(getColor(nColor), 255, 255);
  fill(getColor(nColor), 255, 255);
  end.draw();
  fill(0);
  end.drawPoints();
}

void mousePressed() {
    boolean bAccepted = start.mousePressed();

    if (bAccepted == false) {
      end.mousePressed();
    }
}

void mouseReleased() {
    boolean bAccepted = start.mouseReleased();

    if (bAccepted == false) {
      end.mouseReleased();
    }
}

void mouseDragged() {
    boolean bAccepted = start.mouseDragged();

    if (bAccepted == false) {
      end.mouseDragged();
    }
}

void keyPressed() {
  if (key == 'R' || key == 'r') {
    nReturning = (int)nReturnSteps;
    oldStart = start.copy();
    oldEnd = end.copy();
  }
}