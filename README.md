# Stick Figure

Welcome to stick figure animation for the [Processing](https://processing.org/) programming language!  Let's start with a simple example:

### Hello, World!

``` Processing
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
```

![A stick figure waving hello](http://i.imgur.com/SeasHb4.gif)

[Run this sketch in your browser](https://antony74.github.io/StickFigure/HelloWorld/)

### Other examples

* [TweenTest](./TweenTest) - A visual demonstration of how a stick figure can be posed with the mouse, and how in-between poses can be automatically generated.
* [TheClimb](./TheClimb) - A short animation

### [Documentation](http://antony74.github.io/StickFigure/)

JavaDoc documentation of the three stick figure classes can be found [here](http://antony74.github.io/StickFigure/).