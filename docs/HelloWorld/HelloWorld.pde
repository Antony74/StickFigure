
StickFigure stickFigure;

void setup() {
  size(300, 300);
  stickFigure = new StickFigure(50); // Create a size 50 stick figure
  strokeWeight(18);
  stroke(0);
  fill(0);

  stickFigure.pv.set(150, 185); // Place the stick figure so it's slightly more central
}

void draw() {
  background(128);
  stickFigure.rightHand().heading = (0.25 * sin(frameCount/10.0)) + 2; // Wave!
  stickFigure.draw();
}


/**
 * Each of a StickPuppet's joints is represented by a vertex in a tree.
 * The tree structure means that each vertex has a parent and children.
 * The parent will be null for the root vertex.
 * The children will be empty for a leaf vertex.
 */

class Vertex {

  /**
   * An integer which is unique to this vertex.
   * Typically an index in an ArrayList&gt;Vertex&lt;
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
   * The distance from this vertex to our parent vertex.
   */
  float magnitude;

  /**
   * The direction of our parent vertex from this vertex.
   */
  float heading;

  /**
   * How big the points you drag around with your mouse to manipulate the StickPuppet are (sometimes called lugs, handles or pivots).
   */
  static final float pointSize = 10;

  /**
   * @param _index The unique index of the vertex we are creating.
   */
  Vertex(int _index) {
    index = _index;
    children = new ArrayList<Vertex>();
  }

  /**
   * Adds a child vertex to this vertex
   * @param child The child vertex we are adding
   */
  void addChild(Vertex child) {
    child.parent = this;
    children.add(child);
  }

  /**
   * Calculate's the position of this vertex from the position of its parent vertex.
   * @param pvParent PVector representing the position of our parent
   * @return         Our position
   */
  PVector getVector(PVector pvParent) {
    
    PVector pv = pvParent.get();
    
    if (parent != null) {
      PVector pvRelative = PVector.fromAngle(heading);
      pvRelative.mult(magnitude);
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
   * Draw a point at our present location (to show we can be dragged around with the mouse to manipulate the StickPuppet).
   * Then recursively calls our children so that all points are drawn.
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
   * Rotate this vertex around its parent.  Then call our children recursively so that they rotate with
   * us (thus staying in the same position with respect to us).
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

  /**
   * Calculate the direction of our parent vertex as somewhere in between the directions of the two given vertices.
   * Then call our children recursively so they get tweened too.
   * The parameters are based on Processing's <A href="https://processing.org/reference/map_.html" target="_top">map()</A>
   * function - in fact the only difference should be that we are not mapping to floats we are mapping to vertices.
   * @param value The incoming value to be converted
   * @param start The lower bound of the value's current range
   * @param stop The upper bound of the value's current range
   * @param parentA The desired vertex's lower bound
   * @param parentB The desired vertex's upper bound
   */
  void tween(float value, float start, float stop, Vertex parentA, Vertex parentB) {

    if (children.size() != parentA.children.size() || children.size() != parentB.children.size()) {
      println("Can't tween, trees differ");
      return;
    }

    for (int n = 0; n < children.size(); ++n) {
      Vertex a = parentA.children.get(n);
      Vertex b = parentB.children.get(n);
      Vertex c = children.get(n);
      
      float heading = map(value, start, stop, a.heading, b.heading);
      
      float angle = heading - c.heading;
    
      c.rotate(angle);
      c.tween(value, start, stop, a, b);
    }

  }

  /**
   * Called to determine which vertex, if any, the mouse is currently over.  If the mouse is not over this particular vertex, then our children are called recursively so they get hit tested too.
   * @param pvParent The position of our parent vertex
   * @return The index of the vertex the mouse is over, or -1 if the mouse is not currently over any vertex
   */
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

  /**
   * If this vertex is being dragged by the mouse then rotate appropriately in order to follow the mouse,
   * otherwise call our children recursively in case one of them is being dragged.
   * @param currentDrag The index of the vertex which is currently being dragged
   * @param pvParent The position of our parent vertex
   */
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

  /**
   * Called to determine a particular vertex's x-y location.  If this isn't the desired vertex then our children are called recursively so it can be located.
   * @param desiredIndex The index of the vertex who's location we wish to determine
   * @param pvParent The position of our parent vertex
   * @return The x-y location of the desired vertex, or null if that vertex cannot be located on this branch of the tree.
   */
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

/**
 * StickPuppet is the base-class for StickFigure, and could also be the base-class for anything non-humanoid you wanted to model
 * in the same way (e.g. a dog, an octopus, a dragon...)
 */
class StickPuppet {

  /**
   * The unique index of the vertex currently being mouse-dragged, or -1 if
   * none of the vertices in this StickPuppet are currently being dragged.
   */
  int currentDrag = -1;

  /**
   * Contains the x-y location within the sketch of where the StickPuppet's root vertex
   * is (the StickFigure's root vertex is its PELVIS). 
   */
  PVector pv;

  /**
   * Contains all the StickPuppet's vertices.  Note that the root vertex should be item zero in the ArrayList.
   */
  ArrayList<Vertex> vertices;

  /**
   * Draws a point at each vertex so you can see what can be manipulated with the mouse
   * (such "points" are also sometimes called lugs, handles or pivots).
   */
  void drawPoints() {
    
    pushStyle();
    rectMode(RADIUS);
    noStroke();
    fill(255,0,0,128);

    vertices.get(0).drawPoints(pv);
    
    popStyle();
  }

  /**
   * To make a StickPuppet mouse controlled, call its mousePressed, mouseReleased and mouseDragged
   * functions from the Processing functions with the same name.
   * @return true if the mousePressed event is relevant to the StickPuppet.  Otherwise false, and you can offer the event to some other object. 
   */
  boolean mousePressed() {

    currentDrag = vertices.get(0).hitTest(pv);

    return (currentDrag != -1);
  }

  /**
   * To make a StickPuppet mouse controlled, call its mousePressed, mouseReleased and mouseDragged
   * functions from the Processing functions with the same name.
   * @return true if the mouseReleased event is relevant to the StickPuppet.  Otherwise false, and you can offer the event to some other object. 
   */
  boolean mouseReleased() {
    if (currentDrag == -1) {
      return false;
    } else {
      currentDrag = -1;
      return true;
    }
  }

  /**
   * To make a StickPuppet mouse controlled, call its mousePressed, mouseReleased and mouseDragged
   * functions from the Processing functions with the same name.
   * @return true if the mouseDragged event is relevant to the StickPuppet.  Otherwise false, and you can offer the event to some other object. 
   */
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

  /**
   * Creates a parent-child relationship between two vertices, specified by array index.
   * @param nChild  The array index of the child vertex in this new relationship
   * @param nParent The array index of the parent vertex in this new relationship
   */
  void addChild(int nChild, int nParent) {
    vertices.get(nParent).addChild(vertices.get(nChild));
  }

  /**
   * Sets this StickPuppet to a pose somewhere in between the two poses given.
   * The parameters are based on Processing's <A href="https://processing.org/reference/map_.html" target="_top">map()</A>
   * function - in fact the only difference should be that we are not mapping to floats we are mapping to StickPuppets.
   * @param value The incoming value to be converted
   * @param start The lower bound of the value's current range
   * @param stop The upper bound of the value's current range
   * @param a The start pose
   * @param b The end pose
   */
  void tween(float value, float start, float stop, StickPuppet a, StickPuppet b) {

    float x = map(value, start, stop, a.pv.x, b.pv.x);
    float y = map(value, start, stop, a.pv.y, b.pv.y);
    pv.set(x, y);

    vertices.get(0).tween(value, start, stop, a.vertices.get(0), b.vertices.get(0));

  }

};

/**
 * Stick figure animation for the Processing programming language!
 */
class StickFigure extends StickPuppet {

  /**
   * This is the length of each of the StickFigure's segments (they're all the same).
   * In this way, the size variable also represents this overall size of this stick figure.
   * Call setSize() to change it.
   * @see StickFigure#setSize
   */
  float size;

  /** Array index of the pelvis vertex */
  static final int PELVIS = 0;

  /** Array index of the left knee vertex */
  static final int LEFT_KNEE = 1;

  /** Array index of the right knee vertex */
  static final int RIGHT_KNEE = 2;

  /** Array index of the left foot vertex */
  static final int LEFT_FOOT = 3;

  /** Array index of the right foot vertex */
  static final int RIGHT_FOOT = 4;

  /** Array index of the chest vertex */
  static final int CHEST = 5;

  /** Array index of the neck vertex */
  static final int NECK = 6;

  /** Array index of the head vertex */
  static final int HEAD = 7;

  /** Array index of the left elbow vertex */
  static final int LEFT_ELBOW = 8;

  /** Array index of the right elbow vertex */
  static final int RIGHT_ELBOW = 9;

  /** Array index of the left hand vertex */
  static final int LEFT_HAND = 10;

  /** Array index of the right hand vertex */
  static final int RIGHT_HAND = 11;

  /** Size of ArrayList */
  static final int VERTEX_COUNT = 12;

  /** Convenience method.
   *  @return pelvis vertex
   */
  Vertex pelvis()     { return vertices.get(PELVIS);      }

  /** Convenience method.
   *  @return left knee vertex
   */
  Vertex leftKnee()   { return vertices.get(LEFT_KNEE);   }

  /** Convenience method.
   *  @return right knee vertex
   */
  Vertex rightKnee()  { return vertices.get(RIGHT_KNEE);  }

  /** Convenience method.
   *  @return left foot vertex
   */
  Vertex leftFoot()   { return vertices.get(LEFT_FOOT);   }

  /** Convenience method.
   *  @return right foot vertex
   */
  Vertex rightFoot()  { return vertices.get(RIGHT_FOOT);  }

  /** Convenience method.
   *  @return chest vertex
   */
  Vertex chest()      { return vertices.get(CHEST);       }

  /** Convenience method.
   *  @return neck vertex
   */
  Vertex neck()       { return vertices.get(NECK);        }

  /** Convenience method.
   *  @return head vertex
   */
  Vertex head()       { return vertices.get(HEAD);        }

  /** Convenience method.
   *  @return left elbow vertex
   */
  Vertex leftElbow()  { return vertices.get(LEFT_ELBOW);  }

  /** Convenience method.
   *  @return right elbow vertex
   */
  Vertex rightElbow() { return vertices.get(RIGHT_ELBOW); }

  /** Convenience method.
   *  @return left hand vertex
   */
  Vertex leftHand()   { return vertices.get(LEFT_HAND);   }

  /** Convenience method.
   *  @return right hand vertex
   */
  Vertex rightHand()  { return vertices.get(RIGHT_HAND);  }

  /**
   * Constructs a new stick figure of the specified size
   * @param _size Size of the stick figure
   * @see StickFigure#size
   */
  StickFigure(float _size) {
    size = _size;
    reset();
}
  
  /**
   * Constructs a new stick figure in the pose specified by the parameters.
   * It is needlessly fiddly to write your own call to this constructor.
   * Instead pose the stick figure exactly where you want it, then a call
   * to print() will generate code for you which uses this constructor.
   * @param _size Size of the stick figure
   * @param _pv Position of the stick figure's pelvis (all other vertices are positioned relative to this vector)
   * @param leftKneeHeading   The direction from the left knee to the pelvis
   * @param rightKneeHeading  The direction from the right knee to the pelvis
   * @param leftFootHeading   The direction from the left foot to the left knee
   * @param rightFootHeading  The direction from the right foot to the right knee
   * @param chestHeading      The direction from the chest to the pelvis
   * @param neckHeading       The direction from the neck to the chest
   * @param headHeading       The direction from the head to the neck
   * @param leftElbowHeading  The direction from the left elbow to the neck
   * @param rightElbowHeading The direction from the right elbow to the neck
   * @param leftHandHeading   The direction from the left hand to the left elbow
   * @param rightHandHeading  The direction from the right hand to the right elbow
   * @see StickFigure#print
   */
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
    
    pv = _pv.get();
    
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

  /**
   * Creates the stick figure's vertex tree, connecting up all the joints.
   * Places it in a neutral pose in the middle of the sketch.
   */
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

  /**
   * Draw the stick figure.  This is what to override or hack if you want to give it a makeover or a new wardrobe.
   */
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

  /**
   * Set the length of each of the StickFigure's segments to the same value.
   * Thus setting the overall size of this stick figure.
   * @param _size The new size of each stick figure segment
   */
  void setSize(float _size) {
    size = _size;

    for (int n = 0; n < vertices.size(); ++n) {
      vertices.get(n).magnitude = size;
    }
}

  /**
   * Create a copy of the stick figure.
   * @return The copy
   */
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

  /**
   * Utility method for code generation.  Pad and print a line of code followed by a comment.
   * @param line    The line of code
   * @param comment The comment
   */
  void printlnWithComment(String line, String comment) {

    while (line.length() < 41) {
      line = line + " ";
    }
    
    println(line + "// " + comment);
  }
  
  /**
   * Utility method for code generation.  Generate a line of code which creates a new PVector.
   * @param pv         The PVector
   * @param lineEnding Comma if there are more parameters to come, close bracket semi-colon if this is the last parameter
   * @param comment    The comment
   */
  void printVector(PVector pv, String lineEnding, String comment) {
    String line = "    new PVector(" + pv.x + ", " + pv.y + ")" + lineEnding;
    printlnWithComment(line, comment);
  }
  
  /**
   * Utility method for code generation.  Generate an angle parameter.
   * @param angle      The angle
   * @param lineEnding Comma if there are more parameters to come, close bracket semi-colon if this is the last parameter
   * @param comment    The comment
   */
  void printAngle(float angle, String lineEnding, String comment) {
    String line = "    " + angle + lineEnding;
    printlnWithComment(line, comment);
  }

  /**
   * "Save" the stick figure's current pose by generating code for it, which can then be pasted into your sketch.
   */
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