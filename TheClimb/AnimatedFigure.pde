
class KeyFrame {
  int nFrame;
  StickFigure pose;
  float x;
  float y;

  KeyFrame(int _nFrame, StickFigure _pose, float _x, float _y) {
    nFrame = _nFrame;
    pose = _pose;
    x = _x;
    y = _y;
  }
}

class AnimatedFigure {

  ArrayList<KeyFrame> keyFrames = new ArrayList<KeyFrame>();

  int lastFrame() {
    return keyFrames.get(keyFrames.size() - 1).nFrame;
  }

  void resetFig1() {
    keyFrames.clear();

    // Figure 1 walks in from left
    
    float x = -150;
    float speed = 8;
    int nFrame = 0;
    int nFrameSpacing = 10;
    ArrayList<StickFigure> sequence = poses.walk;

    for (int nWalkCycle = 0; nWalkCycle < 5; ++nWalkCycle) {
 
      for (int n = 0; n < sequence.size(); ++n) {
        keyFrames.add(new KeyFrame(nFrame, sequence.get(n), x, 360));
        x += speed;
        nFrame += nFrameSpacing;
      }
    }

    // Figure 1 recieves a leg up over the obstacle

    nFrameSpacing = 20;
    sequence = poses.lifted;

    for (int n = 0; n < sequence.size(); ++n) {
      StickFigure pose = sequence.get(n);
      keyFrames.add(new KeyFrame(nFrame, pose, pose.pv.x, pose.pv.y));
      nFrame += nFrameSpacing;
    }
  
    // Figure 1 pulls

    nFrame = 1040;
    sequence = poses.pull;

    for (int n = 0; n < sequence.size(); ++n) {
      StickFigure pose = sequence.get(n);
      keyFrames.add(new KeyFrame(nFrame, pose, pose.pv.x, pose.pv.y));
      nFrame += nFrameSpacing;
    }

    // Figure 1 exit stage right

    sequence = poses.walk;
    nFrame = 1400;
    speed = 8;
    nFrameSpacing = 10;
    
    x = 508.0;
    float y = 218.0;

    for (int nWalkCycle = 0; nWalkCycle < 5; ++nWalkCycle) {
 
      for (int n = 0; n < sequence.size(); ++n) {
        keyFrames.add(new KeyFrame(nFrame, sequence.get(n), x, y));
        x += speed;
        nFrame += nFrameSpacing;
      }
    }

  }

  void resetFig2() {
    keyFrames.clear();
    float x = -70;
    float speed = 8;
    int nFrame = 0;
    int nFrameSpacing = 8;

    // Figure 2 walks in from left
    
    ArrayList<StickFigure> sequence = poses.walkShort;

    for (int nWalkCycle = 0; nWalkCycle < 5; ++nWalkCycle) {

      for (int n = 0; n < sequence.size(); ++n) {
        keyFrames.add(new KeyFrame(nFrame, sequence.get(n), x, 360));
        x += speed;
        nFrame += nFrameSpacing;
      }
    }

    // And just a little further
    
    for (int n = 0; n < 3; ++n) {
      keyFrames.add(new KeyFrame(nFrame, sequence.get(n), x, 360));
      x += speed;
      nFrame += nFrameSpacing;
    }

    // Figure 2 lifts figure 1

    nFrameSpacing = 20;

    sequence = poses.lift;
    
    for (int n = 0; n < sequence.size(); ++n) {
      StickFigure pose = sequence.get(n);
      keyFrames.add(new KeyFrame(nFrame, pose, pose.pv.x, pose.pv.y));
      nFrame += nFrameSpacing;
    }

    // Figure 2 is pulled up

    nFrame = 900;
    sequence = poses.pulled;

    for (int n = 0; n < sequence.size(); ++n) {
      StickFigure pose = sequence.get(n);
      keyFrames.add(new KeyFrame(nFrame, pose, pose.pv.x, pose.pv.y));
      nFrame += nFrameSpacing;
    }

    // Figure 2 exit stage right

    x = 465;
    float y = 252;
    speed = 8;
    nFrameSpacing = 8;
    sequence = poses.walkShort;

    for (int nWalkCycle = 0; nWalkCycle < 5; ++nWalkCycle) {

      for (int n = 0; n < sequence.size(); ++n) {
        keyFrames.add(new KeyFrame(nFrame, sequence.get(n), x, y));
        x += speed;
        nFrame += nFrameSpacing;
      }
    }
}
  
  void draw(int nFrame) {
    
    for (int n = 0; n < keyFrames.size(); ++n) {

      boolean bLastKeyFrame = (n == keyFrames.size() - 1);
      
      KeyFrame prevKeyFrame = keyFrames.get(n);
      KeyFrame nextKeyFrame;

      if (bLastKeyFrame) {
        nextKeyFrame = prevKeyFrame;
      } else {
        nextKeyFrame = keyFrames.get(n + 1);
      }

      if (nFrame < nextKeyFrame.nFrame || bLastKeyFrame) {

        StickFigure prevFigure = prevKeyFrame.pose.copy();
        StickFigure nextFigure = nextKeyFrame.pose.copy();
        prevFigure.pv.set(prevKeyFrame.x, prevKeyFrame.y);
        nextFigure.pv.set(nextKeyFrame.x, nextKeyFrame.y);

        float tween = 0;
        
        if ( prevKeyFrame.nFrame == nextKeyFrame.nFrame) {
          tween = 0.5; // Any value, doesn't matter
        } else {
          tween = map(nFrame, prevKeyFrame.nFrame, nextKeyFrame.nFrame, 0, 1);
        }

        StickFigure figure = new StickFigure(prevFigure.size);
        figure.tween(tween, prevFigure, nextFigure);
        figure.draw();
        break;
      }
    }
  }
};