
StickFigure stickFigure;

void setup() {
  size(300, 300);
  stickFigure = new StickFigure(50); // Create a size 50 stick figure
  strokeWeight(18);
  stroke(0);
  fill(0);

  stickFigure.pv.y = 185; // Place the stick figure so it's slightly more central
}

void draw() {
  background(128);
  stickFigure.rightHand().heading = (0.25 * sin(frameCount/10.0)) + 2; // Wave!
  stickFigure.draw();
}