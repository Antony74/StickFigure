# The Climb

This was my week 2 homework for FutureLearn's [Explore Animation](<https://www.futurelearn.com/courses/explore-animation>) course.

It's not the worse animation you'll ever see, but you can probably do better!

![Two stick figures negotiate a simple obstacle](http://i.imgur.com/vzVqspC.gif)

[Run this sketch in your browser](https://antony74.github.io/StickFigure/TheClimb/)

### [Poses.pde](./Poses.pde)

For each pose a stick figure was positioned using the mouse pointer, then the [print()](https://antony74.github.io/StickFigure/StickFigure.html#print--) function was called to generate each chunk of code you see pasted into Poses.pde.

### [AnimatedFigure.pde](./AnimatedFigure.pde)

You'll probably want to use the [StickFigure](https://antony74.github.io/StickFigure/) class in your own way, but it might be worth taking a quick look at how I arrange poses into ordered key frames, so that when AnimatedFigure.draw() is called we can find the key frame immediately before and after the requested frame, then call [tween()](https://antony74.github.io/StickFigure/StickFigure.html#tween--) to generate a stick figure positioned exactly where it should be drawn in-between the two poses.   This results in nice smooth animation.

### [TheClimb.pde](./TheClimb.pde)

The three boolean flags at the top of this file control which mode the sketch is run in.

| Name          | Description   |
| ------------- | ------------------------------------------------------- |
| bRunAnimation | Displays the finished animation |
| bWorkOnAnimation | This is where I worked on the animation.  The stick figure can be posed by dragging points around.  Left and right arrows to move through the current sequence of poses.  N for a new pose.  P to print.  To help line up the next pose, the previous pose is shown as a half transparent 'onion skin'. |
| bRecord | Don't switch this on until you're prepared for this directory to fill up with .png files of each consecutive frame!  Then use tools such as Processing's Movie Maker, [ImageMagick](https://www.imagemagick.org/) or [ffmpeg](https://www.ffmpeg.org/) to convert the frames into a video file or animated .gif |