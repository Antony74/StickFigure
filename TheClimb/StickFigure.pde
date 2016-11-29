
/**
 * Each of a StickPuppet's joints is represented by a vertex in a tree.
 * The tree structure means that each vertex has a parent and children.
 * The parent will be null for the root vertex.
 * The children will be empty for a leaf vertex.
 */

class Vertex {

  /**
   * An integer which is unique to this vertex.
   * Typically an index in an ArrayList<Vertex>
   * @see StickPuppet#vertices
   */
  int index;

  /***
   * Our parent vertex.  The parent will be null if we are the root vertex.
   */
  Vertex parent;
  
  /***
   * Any child vertices.  Will be empty if we are a leaf vertex.
   */
  ArrayList<Vertex> children;

  /**
   * The distance from this vertex to our parent vertex
   */
  float magnitude;

  /**
   * The direction of our parent vertex from this vertex
   */
  float heading;

  /**
   * The points you drag around with your mouse to manipulate the StickPuppet - sometimes called lugs, handles or pivots.
   * This variable defines how big each point is.
   */
  static final float pointSize = 10;

  /**
   * @param _index The unique index of the vertex we are creating
   */
  Vertex(int _index) {
    index = _index;
    children = new ArrayList<Vertex>();
  }

  /**
   * @param child The child vertex we are adding
   */
  void addChild(Vertex child) {
    child.parent = this;
    children.add(child);
  }

  /**
   * Calculate our position from the position of our parent
   * @param pvParent PVector representing the position of our parent
   * @return         Our position
   */
  PVector getVector(PVector pvParent) {
    
    PVector pv = pvParent.copy();
    
    if (parent != null) {
      PVector pvRelative = PVector.fromAngle(heading).mult(magnitude);
      pv.sub(pvRelative);
    }
    
    return pv;
  }

  /**
   * Draw a line to our parent vertex, then recursively call our children so that all lines between vertices are drawn.
   * @param pvParent PVector representing the position of our parent
   */
  void draw(PVector pvParent) {

    PVector pv = getVector(pvParent);
    line(pvParent.x, pvParent.y, pv.x, pv.y);
    
    for (int n = 0; n < children.size(); ++n) {

      Vertex child = children.get(n);
      child.draw(pv);
    }
  }

  /**
   * The points you drag around with your mouse to manipulate the StickPuppet - sometimes called lugs, handles or pivots.
   * This draws one at our location, then recursively calls our children so that all points are drawn.
   * @param pvParent PVector representing the position of our parent
   */
  void drawPoints(PVector pvParent) {

    PVector pv = getVector(pvParent);
    rect(pv.x, pv.y, pointSize, pointSize);

    for (int n = 0; n < children.size(); ++n) {

      Vertex child = children.get(n);
      child.drawPoints(pv);
    }
  }

  /**
   * Rotate this vertex around its parent.  Then call our children recursively so that they rotate with us
   * @param angle The amount to rotate by
   */
  void rotate(float angle) {

    // Update heading - to do this the angle needs to be expressed within the range -PI to PI
    angle = angle - TWO_PI * floor( angle / TWO_PI );      
    
    if (angle > PI)
      angle -= TWO_PI;
    
    heading += angle;
    
    // Done updating heading - now recurse to the children
    
    for (int n = 0; n < children.size(); ++n) {

      Vertex child = children.get(n);
      child.rotate(angle);
    }
  }

  void tween(float t, Vertex parentA, Vertex parentB) {

    if (children.size() != parentA.children.size() || children.size() != parentB.children.size()) {
      println("Can't tween, trees differ");
      return;
    }

    for (int n = 0; n < children.size(); ++n) {
      Vertex a = parentA.children.get(n);
      Vertex b = parentB.children.get(n);
      Vertex c = children.get(n);
      
      float heading = map(t, 0, 1, a.heading, b.heading);
      
      float angle = heading - c.heading;
    
      c.rotate(angle);
      c.tween(t, a, b);
    }

  }

  int hitTest(PVector pvParent) {

    PVector pv = getVector(pvParent);

    if ( (abs(pv.x - mouseX) <= pointSize) && abs(pv.y - mouseY) <= pointSize) {
      return index;
    }
    
    for (int n = 0; n < children.size(); ++n) {

      Vertex child = children.get(n);
      int nHit = child.hitTest(pv);

      if (nHit != -1) {
        return nHit;
      }
    }
 
    return -1;
  }

  void mouseDragged(int currentDrag, PVector pvParent) {
    
    PVector pv = getVector(pvParent);

    if (index == currentDrag) {
      
      float newHeading = PVector.sub(new PVector(mouseX, mouseY), pvParent).heading();

      rotate(newHeading - heading + PI);
      
    } else {

      for (int n = 0; n < children.size(); ++n) {
  
        Vertex child = children.get(n);
        child.mouseDragged(currentDrag, pv);
      }
    }

  }

  PVector getChildVector(int desiredIndex, PVector pvParent) {
    PVector pv = getVector(pvParent);
    
    if (index == desiredIndex) {
      return pv;
    } else {
      for (int n = 0; n < children.size(); ++n) {
  
        Vertex child = children.get(n);
        PVector pvChild = child.getChildVector(desiredIndex, pv);
        
        if (pvChild != null) {
          return pvChild;
        }
      }
      
      return null;
    }
    
  }
};

//
// StickPuppet
//
class StickPuppet {

  float size;
  int currentDrag = -1;

  PVector pv;
  ArrayList<Vertex> vertices;

  void drawPoints() {
    
    pushStyle();
    rectMode(RADIUS);
    noStroke();
    fill(255,0,0,128);

    vertices.get(0).drawPoints(pv);
    
    popStyle();
  }

  boolean mousePressed() {

    currentDrag = vertices.get(0).hitTest(pv);

    return (currentDrag != -1);
  }

  boolean mouseReleased() {
    if (currentDrag == -1) {
      return false;
    } else {
      currentDrag = -1;
      return true;
    }
  }

  boolean mouseDragged() {

    if (currentDrag >= 0) {

      if (currentDrag == 0) {
        
        pv.set(mouseX, mouseY);

      } else {

        vertices.get(0).mouseDragged(currentDrag, pv);
      }
      
      return true;
    } else {
      return false;
    }
  }

  void tween(float t, StickFigure a, StickFigure b) {

    float x = map(t, 0, 1, a.pv.x, b.pv.x);
    float y = map(t, 0, 1, a.pv.y, b.pv.y);
    pv.set(x, y);

    vertices.get(0).tween(t, a.vertices.get(0), b.vertices.get(0));

  }

};

//
// StickFigure
//
class StickFigure extends StickPuppet {

  static final int PELVIS = 0;
  static final int LEFT_KNEE = 1;
  static final int RIGHT_KNEE = 2;
  static final int LEFT_FOOT = 3;
  static final int RIGHT_FOOT = 4;
  static final int CHEST = 5;
  static final int NECK = 6;
  static final int HEAD = 7;
  static final int LEFT_ELBOW = 8;
  static final int RIGHT_ELBOW = 9;
  static final int LEFT_HAND = 10;
  static final int RIGHT_HAND = 11;
  static final int VERTEX_COUNT = 12;

  Vertex pelvis()     { return vertices.get(PELVIS);      }
  Vertex leftKnee()   { return vertices.get(LEFT_KNEE);   }
  Vertex rightKnee()  { return vertices.get(RIGHT_KNEE);  }
  Vertex leftFoot()   { return vertices.get(LEFT_FOOT);   }
  Vertex rightFoot()  { return vertices.get(RIGHT_FOOT);  }
  Vertex chest()      { return vertices.get(CHEST);       }
  Vertex neck()       { return vertices.get(NECK);        }
  Vertex head()       { return vertices.get(HEAD);        }
  Vertex leftElbow()  { return vertices.get(LEFT_ELBOW);  }
  Vertex rightElbow() { return vertices.get(RIGHT_ELBOW); }
  Vertex leftHand()   { return vertices.get(LEFT_HAND);   }
  Vertex rightHand()  { return vertices.get(RIGHT_HAND);  }
  
  StickFigure(float _size) {
    size = _size;
    reset();
}
  
  StickFigure(
          float _size,
          PVector _pv,
          float leftKneeHeading,
          float rightKneeHeading,
          float leftFootHeading,
          float rightFootHeading,
          float chestHeading,
          float neckHeading,
          float headHeading,
          float leftElbowHeading,
          float rightElbowHeading,
          float leftHandHeading,
          float rightHandHeading) {

    size = _size;

    reset();
    
    pv = _pv;
    
    leftKnee().heading   = leftKneeHeading;
    rightKnee().heading  = rightKneeHeading;
    leftFoot().heading   = leftFootHeading;
    rightFoot().heading  = rightFootHeading;
    chest().heading      = chestHeading;
    neck().heading       = neckHeading;
    head().heading       = headHeading;
    leftElbow().heading  = leftElbowHeading;
    rightElbow().heading = rightElbowHeading;
    leftHand().heading   = leftHandHeading;
    rightHand().heading  = rightHandHeading;
  }

  void reset() {

    vertices = new ArrayList<Vertex>();
    
    for (int n = 0; n < VERTEX_COUNT; ++n) {
      vertices.add(new Vertex(n));
    }

    addChild(LEFT_KNEE, PELVIS);
    addChild(RIGHT_KNEE, PELVIS);
    addChild(LEFT_FOOT, LEFT_KNEE);
    addChild(RIGHT_FOOT, RIGHT_KNEE);
    addChild(CHEST, PELVIS);
    addChild(NECK, CHEST);
    addChild(HEAD, NECK);
    addChild(LEFT_ELBOW, NECK);
    addChild(RIGHT_ELBOW, NECK);
    addChild(LEFT_HAND, LEFT_ELBOW);
    addChild(RIGHT_HAND, RIGHT_ELBOW);
    
    float EIGHTH_PI = PI/8;

    pv = new PVector(width/2, height/2);
    leftKnee().heading = EIGHTH_PI;
    rightKnee().heading = -EIGHTH_PI;
    leftFoot().heading = EIGHTH_PI;
    rightFoot().heading = -EIGHTH_PI;
    chest().heading = -PI;
    neck().heading = -PI;
    head().heading = -PI;
    leftElbow().heading = QUARTER_PI;
    rightElbow().heading = -QUARTER_PI;
    leftHand().heading = EIGHTH_PI;
    rightHand().heading = -EIGHTH_PI;
    
    for (int n = 0; n < vertices.size(); ++n) {
      Vertex v = vertices.get(n);
      v.magnitude = size;
    }

    pelvis().rotate(-HALF_PI);
  }

  void addChild(int nVertex, int nParent) {
    vertices.get(nParent).addChild(vertices.get(nVertex));
  }

  void draw() {

    pelvis().draw(pv);

    PVector pvHead = pelvis().getChildVector(HEAD, pv);
    PVector pvNeck = pelvis().getChildVector(NECK, pv);

    PVector center = PVector.div( PVector.add( PVector.mult(pvNeck, 1), PVector.mult(pvHead, 2) ), 3);
    float radius = dist(pvHead.x, pvHead.y, pvNeck.x, pvNeck.y) * 0.5;

    pushStyle();
    ellipseMode(RADIUS);
    ellipse(center.x, center.y, radius, radius);
    popStyle();

    // Use this kind of trick if you need to be able to tell one limb from the other
/*
    if (alpha(g.strokeColor) == 255) {
      pushStyle();
      stroke(0, 255, 255);
      vertices.get(LEFT_KNEE).draw(pv);
      popStyle();
    }
*/
  }

  void setSize(int _size) {
    size = _size;

    for (int n = 0; n < vertices.size(); ++n) {
      vertices.get(n).magnitude = size;
    }
}

  StickFigure copy() {
    
    return new StickFigure(
                  size,
                  pv,
                  vertices.get(LEFT_KNEE).heading,
                  vertices.get(RIGHT_KNEE).heading,
                  vertices.get(LEFT_FOOT).heading,
                  vertices.get(RIGHT_FOOT).heading,
                  vertices.get(CHEST).heading,
                  vertices.get(NECK).heading,
                  vertices.get(HEAD).heading,
                  vertices.get(LEFT_ELBOW).heading,
                  vertices.get(RIGHT_ELBOW).heading,
                  vertices.get(LEFT_HAND).heading,
                  vertices.get(RIGHT_HAND).heading); 
  }

  void printlnWithComment(String line, String comment) {

    while (line.length() < 41) {
      line = line + " ";
    }
    
    println(line + "// " + comment);
  }
  
  void printVector(PVector pv, String lineEnding, String comment) {
    String line = "    new PVector(" + pv.x + ", " + pv.y + ")" + lineEnding;
    printlnWithComment(line, comment);
  }
  
  void printAngle(float angle, String lineEnding, String comment) {
    String line = "    " + angle + lineEnding;
    printlnWithComment(line, comment);
  }

  void print() {
    println("sequence.add(new StickFigure(");
    printlnWithComment("    " + size + ",", "Size");
    printVector(pv,                  ",",   "Pelvis position");
    printAngle(leftKnee().heading,   ",",   "Left knee (direction of pelvis)");
    printAngle(rightKnee().heading,  ",",   "Right knee (direction of pelvis)");
    printAngle(leftFoot().heading,   ",",   "Left foot (direction of left knee)");
    printAngle(rightFoot().heading,  ",",   "Right foot (direction of right knee)");
    printAngle(chest().heading,      ",",   "Chest (direction of pelvis)");
    printAngle(neck().heading,       ",",   "Neck (direction of chest)");
    printAngle(head().heading,       ",",   "Head (direction of neck");
    printAngle(leftElbow().heading,  ",",   "Left elbow (direction of neck)");
    printAngle(rightElbow().heading, ",",   "Right elbow (direction of neck)");
    printAngle(leftHand().heading,   ",",   "Left hand (direction of left elbow)");
    printAngle(rightHand().heading,  "));", "Right hand (direction of right elbow)");

    println("");
  }

};