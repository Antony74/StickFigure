
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

        StickFigure figure = new StickFigure(prevFigure.size);

        if ( prevKeyFrame.nFrame == nextKeyFrame.nFrame) {
          figure = prevFigure.copy();
        } else {
          figure.tween(nFrame, prevKeyFrame.nFrame, nextKeyFrame.nFrame, prevFigure, nextFigure);
        }

        figure.draw();
        break;
      }
    }
  }
};


class Poses {
  ArrayList<StickFigure> walk = new ArrayList<StickFigure>();
  ArrayList<StickFigure> walkShort = new ArrayList<StickFigure>();
  ArrayList<StickFigure> lift = new ArrayList<StickFigure>();
  ArrayList<StickFigure> lifted = new ArrayList<StickFigure>();
  ArrayList<StickFigure> pulled = new ArrayList<StickFigure>();
  ArrayList<StickFigure> pull = new ArrayList<StickFigure>();
  
  Poses() {

    ArrayList<StickFigure> sequence = walk;
    
    sequence.add(new StickFigure(
        50.0,                                // Size
        new PVector(99.0, 359.0),            // Pelvis position
        -1.3843094,                          // Left knee (direction of pelvis)
        -1.8545908,                          // Right knee (direction of pelvis)
        -1.2047883,                          // Left foot (direction of left knee)
        -1.5490602,                          // Right foot (direction of right knee)
        -4.712389,                           // Chest (direction of pelvis)
        -4.712389,                           // Neck (direction of chest)
        -4.712389,                           // Head (direction of neck
        -1.07145,                            // Left elbow (direction of neck)
        -2.098871,                           // Right elbow (direction of neck)
        -1.4641491,                          // Left hand (direction of left elbow)
        -1.7061719));                        // Right hand (direction of right elbow)
        
    sequence.add(new StickFigure(
        50.0,                                // Size
        new PVector(104.0, 361.0),           // Pelvis position
        -1.3796121,                          // Left knee (direction of pelvis)
        -2.1401095,                          // Right knee (direction of pelvis)
        -1.200091,                           // Left foot (direction of left knee)
        -1.5382018,                          // Right foot (direction of right knee)
        -4.712389,                           // Chest (direction of pelvis)
        -4.712389,                           // Neck (direction of chest)
        -4.712389,                           // Head (direction of neck
        -1.07145,                            // Left elbow (direction of neck)
        -2.098871,                           // Right elbow (direction of neck)
        -1.4641491,                          // Left hand (direction of left elbow)
        -1.7061719));                        // Right hand (direction of right elbow)

    sequence.add(new StickFigure(
        50.0,                                // Size
        new PVector(110.0, 361.0),           // Pelvis position
        -1.4310871,                          // Left knee (direction of pelvis)
        -2.3669472,                          // Right knee (direction of pelvis)
        -1.1996619,                          // Left foot (direction of left knee)
        -1.7650394,                          // Right foot (direction of right knee)
        -4.712389,                           // Chest (direction of pelvis)
        -4.712389,                           // Neck (direction of chest)
        -4.712389,                           // Head (direction of neck
        -1.07145,                            // Left elbow (direction of neck)
        -2.098871,                           // Right elbow (direction of neck)
        -1.4641491,                          // Left hand (direction of left elbow)
        -1.7061719));                        // Right hand (direction of right elbow)
  
    sequence.add(new StickFigure(
        50.0,                                // Size
        new PVector(123.0, 364.0),           // Pelvis position
        -1.5316011,                          // Left knee (direction of pelvis)
        -2.3561945,                          // Right knee (direction of pelvis)
        -0.7266761,                          // Left foot (direction of left knee)
        -1.7542868,                          // Right foot (direction of right knee)
        -4.712389,                           // Chest (direction of pelvis)
        -4.712389,                           // Neck (direction of chest)
        -4.712389,                           // Head (direction of neck
        -1.07145,                            // Left elbow (direction of neck)
        -2.098871,                           // Right elbow (direction of neck)
        -1.4641491,                          // Left hand (direction of left elbow)
        -1.7061719));                        // Right hand (direction of right elbow)
      
    sequence.add(new StickFigure(
        50.0,                                // Size
        new PVector(136.0, 363.0),           // Pelvis position
        -1.7359449,                          // Left knee (direction of pelvis)
        -2.1045046,                          // Right knee (direction of pelvis)
        -0.8247191,                          // Left foot (direction of left knee)
        -1.5025969,                          // Right foot (direction of right knee)
        -4.712389,                           // Chest (direction of pelvis)
        -4.712389,                           // Neck (direction of chest)
        -4.712389,                           // Head (direction of neck
        -1.07145,                            // Left elbow (direction of neck)
        -2.098871,                           // Right elbow (direction of neck)
        -1.4641491,                          // Left hand (direction of left elbow)
        -1.7061719));                        // Right hand (direction of right elbow)

    sequence.add(new StickFigure(
        50.0,                                // Size
        new PVector(136.0, 363.0),           // Pelvis position
        -1.5554128,                          // Left knee (direction of pelvis)
        -1.9437838,                          // Right knee (direction of pelvis)
        -1.5659876,                          // Left foot (direction of left knee)
        -0.97914267,                         // Right foot (direction of right knee)
        -4.712389,                           // Chest (direction of pelvis)
        -4.712389,                           // Neck (direction of chest)
        -4.712389,                           // Head (direction of neck
        -1.07145,                            // Left elbow (direction of neck)
        -2.098871,                           // Right elbow (direction of neck)
        -1.4641491,                          // Left hand (direction of left elbow)
        -1.7061719));                        // Right hand (direction of right elbow)

    sequence.add(new StickFigure(
        50.0,                                // Size
        new PVector(147.0, 363.0),           // Pelvis position
        -2.1995926,                          // Left knee (direction of pelvis)
        -1.5565114,                          // Right knee (direction of pelvis)
        -1.3606353,                          // Left foot (direction of left knee)
        -1.3597236,                          // Right foot (direction of right knee)
        -4.712389,                           // Chest (direction of pelvis)
        -4.712389,                           // Neck (direction of chest)
        -4.712389,                           // Head (direction of neck
        -1.07145,                            // Left elbow (direction of neck)
        -2.098871,                           // Right elbow (direction of neck)
        -1.4641491,                          // Left hand (direction of left elbow)
        -1.7061719));                        // Right hand (direction of right elbow)

    sequence.add(new StickFigure(
        50.0,                                // Size
        new PVector(164.0, 364.0),           // Pelvis position
        -2.4149504,                          // Left knee (direction of pelvis)
        -1.6724854,                          // Right knee (direction of pelvis)
        -1.5759931,                          // Left foot (direction of left knee)
        -1.1943626,                          // Right foot (direction of right knee)
        -4.712389,                           // Chest (direction of pelvis)
        -4.712389,                           // Neck (direction of chest)
        -4.712389,                           // Head (direction of neck
        -1.07145,                            // Left elbow (direction of neck)
        -2.098871,                           // Right elbow (direction of neck)
        -1.4641491,                          // Left hand (direction of left elbow)
        -1.7061719));                        // Right hand (direction of right elbow)

    sequence.add(new StickFigure(
        50.0,                                // Size
        new PVector(174.0, 364.0),           // Pelvis position
        -2.2318397,                          // Left knee (direction of pelvis)
        -1.3940878,                          // Right knee (direction of pelvis)
        -1.5372262,                          // Left foot (direction of left knee)
        -0.9159651,                          // Right foot (direction of right knee)
        -4.712389,                           // Chest (direction of pelvis)
        -4.712389,                           // Neck (direction of chest)
        -4.712389,                           // Head (direction of neck
        -1.07145,                            // Left elbow (direction of neck)
        -2.098871,                           // Right elbow (direction of neck)
        -1.4641491,                          // Left hand (direction of left elbow)
        -1.7061719));                        // Right hand (direction of right elbow)

    sequence.add(new StickFigure(
        50.0,                                // Size
        new PVector(190.0, 364.0),           // Pelvis position
        -2.0899425,                          // Left knee (direction of pelvis)
        -1.570796,                           // Right knee (direction of pelvis)
        -1.5744677,                          // Left foot (direction of left knee)
        -1.0926733,                          // Right foot (direction of right knee)
        -4.712389,                           // Chest (direction of pelvis)
        -4.712389,                           // Neck (direction of chest)
        -4.712389,                           // Head (direction of neck
        -1.07145,                            // Left elbow (direction of neck)
        -2.098871,                           // Right elbow (direction of neck)
        -1.4641491,                          // Left hand (direction of left elbow)
        -1.7061719));                        // Right hand (direction of right elbow)

    // End of walk sequence

    // Use the same walk sequence for the shorter figure
    for (int n = 0; n < walk.size(); ++n) {
      StickFigure fig = walk.get(n).copy();
      fig.setSize(40);
      walkShort.add(fig);
    }

    // Lift sequence

    sequence = lift;

    sequence.add(new StickFigure(
        40.0,                                // Size
        new PVector(360.0, 368.0),           // Pelvis position
        -1.5195594,                          // Left knee (direction of pelvis)
        -2.024135,                           // Right knee (direction of pelvis)
        -1.4645538,                          // Left foot (direction of left knee)
        -1.6416645,                          // Right foot (direction of right knee)
        -4.712389,                           // Chest (direction of pelvis)
        -4.712389,                           // Neck (direction of chest)
        -4.712389,                           // Head (direction of neck
        -1.07145,                            // Left elbow (direction of neck)
        -2.098871,                           // Right elbow (direction of neck)
        -1.4641491,                          // Left hand (direction of left elbow)
        -1.7061719));                        // Right hand (direction of right elbow)
    
    sequence.add(new StickFigure(
        40.0,                                // Size
        new PVector(360.0, 364.0),           // Pelvis position
        -1.1547322,                          // Left knee (direction of pelvis)
        -1.8281202,                          // Right knee (direction of pelvis)
        -1.3480434,                          // Left foot (direction of left knee)
        -1.8847771,                          // Right foot (direction of right knee)
        -4.782044,                           // Chest (direction of pelvis)
        -4.782044,                           // Neck (direction of chest)
        -4.782044,                           // Head (direction of neck
        -1.1411049,                          // Left elbow (direction of neck)
        -2.168526,                           // Right elbow (direction of neck)
        -1.533804,                           // Left hand (direction of left elbow)
        -1.7758268));                        // Right hand (direction of right elbow)

    sequence.add(new StickFigure(
        40.0,                                // Size
        new PVector(356.0, 378.0),           // Pelvis position
        -0.9318824,                          // Left knee (direction of pelvis)
        -1.951303,                           // Right knee (direction of pelvis)
        -1.3275571,                          // Left foot (direction of left knee)
        -2.1932058,                          // Right foot (direction of right knee)
        -4.9371,                             // Chest (direction of pelvis)
        -4.9371,                             // Neck (direction of chest)
        -4.9371,                             // Head (direction of neck
        -1.1726749,                          // Left elbow (direction of neck)
        -2.0587656,                          // Right elbow (direction of neck)
        -1.565374,                           // Left hand (direction of left elbow)
        -1.6660665));                        // Right hand (direction of right elbow)

    sequence.add(new StickFigure(
        40.0,                                // Size
        new PVector(354.0, 391.0),           // Pelvis position
        -0.6340227,                          // Left knee (direction of pelvis)
        -2.082027,                           // Right knee (direction of pelvis)
        -1.3437419,                          // Left foot (direction of left knee)
        -2.4674277,                          // Right foot (direction of right knee)
        -4.9371,                             // Chest (direction of pelvis)
        -4.9371,                             // Neck (direction of chest)
        -4.9371,                             // Head (direction of neck
        -0.9674952,                          // Left elbow (direction of neck)
        -1.7393539,                          // Right elbow (direction of neck)
        -1.6387225,                          // Left hand (direction of left elbow)
        -1.1848625));                        // Right hand (direction of right elbow)
    
    sequence.add(new StickFigure(
        40.0,                                // Size
        new PVector(347.0, 403.0),           // Pelvis position
        -0.46364784,                         // Left knee (direction of pelvis)
        -2.1527019,                          // Right knee (direction of pelvis)
        -1.4168835,                          // Left foot (direction of left knee)
        -2.710081,                           // Right foot (direction of right knee)
        -5.120538,                           // Chest (direction of pelvis)
        -5.120538,                           // Neck (direction of chest)
        -5.120538,                           // Head (direction of neck
        -1.1509335,                          // Left elbow (direction of neck)
        -1.9227922,                          // Right elbow (direction of neck)
        -1.8221608,                          // Left hand (direction of left elbow)
        -1.3683008));                        // Right hand (direction of right elbow)

    // Begin lifted sequence

    sequence = lifted;

    sequence.add(new StickFigure(            // 0
        50.0,                                // Size
        new PVector(237.0, 356.0),           // Pelvis position
        -2.4788632,                          // Left knee (direction of pelvis)
        -1.570796,                           // Right knee (direction of pelvis)
        -1.7037334,                          // Left foot (direction of left knee)
        -1.0926733,                          // Right foot (direction of right knee)
        -4.712389,                           // Chest (direction of pelvis)
        -4.712389,                           // Neck (direction of chest)
        -4.712389,                           // Head (direction of neck
        -1.07145,                            // Left elbow (direction of neck)
        -2.098871,                           // Right elbow (direction of neck)
        -1.4641491,                          // Left hand (direction of left elbow)
        -1.7061719));                        // Right hand (direction of right elbow)
        
    sequence.add(new StickFigure(            // 1
        50.0,                                // Size
        new PVector(237.0, 356.0),           // Pelvis position
        -2.888517,                           // Left knee (direction of pelvis)
        -1.570796,                           // Right knee (direction of pelvis)
        -1.5475316,                          // Left foot (direction of left knee)
        -1.0926733,                          // Right foot (direction of right knee)
        -4.712389,                           // Chest (direction of pelvis)
        -4.712389,                           // Neck (direction of chest)
        -4.712389,                           // Head (direction of neck
        -1.07145,                            // Left elbow (direction of neck)
        -2.098871,                           // Right elbow (direction of neck)
        -1.4641491,                          // Left hand (direction of left elbow)
        -1.7061719));                        // Right hand (direction of right elbow)

    sequence.add(new StickFigure(            // 2
        50.0,                                // Size
        new PVector(245.0, 353.0),           // Pelvis position
        -3.237452,                           // Left knee (direction of pelvis)
        -1.570796,                           // Right knee (direction of pelvis)
        -1.380733,                           // Left foot (direction of left knee)
        -0.8926773,                          // Right foot (direction of right knee)
        -4.621729,                           // Chest (direction of pelvis)
        -4.621729,                           // Neck (direction of chest)
        -4.621729,                           // Head (direction of neck
        -0.9807899,                          // Left elbow (direction of neck)
        -2.008211,                           // Right elbow (direction of neck)
        -1.373489,                           // Left hand (direction of left elbow)
        -1.6155118));                        // Right hand (direction of right elbow)

    sequence.add(new StickFigure(            // 3
        50.0,                                // Size
        new PVector(256.0, 343.0),           // Pelvis position
        -3.3269405,                          // Left knee (direction of pelvis)
        -1.6814537,                          // Right knee (direction of pelvis)
        -1.7684555,                          // Left foot (direction of left knee)
        -1.003335,                           // Right foot (direction of right knee)
        -4.503924,                           // Chest (direction of pelvis)
        -4.503924,                           // Neck (direction of chest)
        -4.503924,                           // Head (direction of neck
        -0.8629849,                          // Left elbow (direction of neck)
        -1.8904059,                          // Right elbow (direction of neck)
        -1.255684,                           // Left hand (direction of left elbow)
        -1.4977068));                        // Right hand (direction of right elbow)

    sequence.add(new StickFigure(            // 4
        50.0,                                // Size
        new PVector(269.0, 322.0),           // Pelvis position
        -3.0764675,                          // Left knee (direction of pelvis)
        -1.6814537,                          // Right knee (direction of pelvis)
        -1.7160316,                          // Left foot (direction of left knee)
        -1.003335,                           // Right foot (direction of right knee)
        -4.525902,                           // Chest (direction of pelvis)
        -4.525902,                           // Neck (direction of chest)
        -4.525902,                           // Head (direction of neck
        -0.8849628,                          // Left elbow (direction of neck)
        -1.9123838,                          // Right elbow (direction of neck)
        -1.2776619,                          // Left hand (direction of left elbow)
        -1.5196847));                        // Right hand (direction of right elbow)
    
    sequence.add(new StickFigure(            // 5
        50.0,                                // Size
        new PVector(278.0, 309.0),           // Pelvis position
        -2.7049656,                          // Left knee (direction of pelvis)
        -1.8993492,                          // Right knee (direction of pelvis)
        -1.546936,                           // Left foot (direction of left knee)
        -0.820282,                           // Right foot (direction of right knee)
        -4.601732,                           // Chest (direction of pelvis)
        -4.601732,                           // Neck (direction of chest)
        -4.601732,                           // Head (direction of neck
        -0.9607928,                          // Left elbow (direction of neck)
        -1.9882138,                          // Right elbow (direction of neck)
        -1.3534919,                          // Left hand (direction of left elbow)
        -1.5955147));                        // Right hand (direction of right elbow)
    
    sequence.add(new StickFigure(
        50.0,                                // Size
        new PVector(302.0, 294.0),           // Pelvis position
        -2.4101958,                          // Left knee (direction of pelvis)
        -2.6367311,                          // Right knee (direction of pelvis)
        -1.2521663,                          // Left foot (direction of left knee)
        -1.5576639,                          // Right foot (direction of right knee)
        -4.712389,                           // Chest (direction of pelvis)
        -4.712389,                           // Neck (direction of chest)
        -4.712389,                           // Head (direction of neck
        -1.07145,                            // Left elbow (direction of neck)
        -2.098871,                           // Right elbow (direction of neck)
        -1.4641491,                          // Left hand (direction of left elbow)
        -1.7061719));                        // Right hand (direction of right elbow)

    sequence.add(new StickFigure(
        50.0,                                // Size
        new PVector(302.0, 294.0),           // Pelvis position
        -2.4101958,                          // Left knee (direction of pelvis)
        -2.6367311,                          // Right knee (direction of pelvis)
        -1.2521663,                          // Left foot (direction of left knee)
        -1.5576639,                          // Right foot (direction of right knee)
        -4.5325356,                          // Chest (direction of pelvis)
        -4.5325356,                          // Neck (direction of chest)
        -4.5325356,                          // Head (direction of neck
        -0.89159656,                         // Left elbow (direction of neck)
        -1.9190176,                          // Right elbow (direction of neck)
        -1.2842957,                          // Left hand (direction of left elbow)
        -1.5263184));                        // Right hand (direction of right elbow)

    sequence.add(new StickFigure(
        50.0,                                // Size
        new PVector(313.0, 286.0),           // Pelvis position
        -2.2381024,                          // Left knee (direction of pelvis)
        -2.8144946,                          // Right knee (direction of pelvis)
        -1.2890911,                          // Left foot (direction of left knee)
        -1.7354274,                          // Right foot (direction of right knee)
        -4.5325356,                          // Chest (direction of pelvis)
        -4.5325356,                          // Neck (direction of chest)
        -4.5325356,                          // Head (direction of neck
        -0.89159656,                         // Left elbow (direction of neck)
        -1.9190176,                          // Right elbow (direction of neck)
        -1.2842957,                          // Left hand (direction of left elbow)
        -1.5263184));                        // Right hand (direction of right elbow)

    sequence.add(new StickFigure(
        50.0,                                // Size
        new PVector(324.0, 279.0),           // Pelvis position
        -1.9546137,                          // Left knee (direction of pelvis)
        -2.8864107,                          // Right knee (direction of pelvis)
        -1.2082777,                          // Left foot (direction of left knee)
        -1.8073435,                          // Right foot (direction of right knee)
        -4.5325356,                          // Chest (direction of pelvis)
        -4.5325356,                          // Neck (direction of chest)
        -4.5325356,                          // Head (direction of neck
        -0.89159656,                         // Left elbow (direction of neck)
        -1.9190176,                          // Right elbow (direction of neck)
        -1.2842957,                          // Left hand (direction of left elbow)
        -1.5263184));                        // Right hand (direction of right elbow)

    sequence.add(new StickFigure(
        50.0,                                // Size
        new PVector(333.0, 279.0),           // Pelvis position
        -1.9546137,                          // Left knee (direction of pelvis)
        -2.8864107,                          // Right knee (direction of pelvis)
        -1.2082777,                          // Left foot (direction of left knee)
        -1.8073435,                          // Right foot (direction of right knee)
        -4.5325356,                          // Chest (direction of pelvis)
        -4.5325356,                          // Neck (direction of chest)
        -4.5325356,                          // Head (direction of neck
        -0.89159656,                         // Left elbow (direction of neck)
        -1.9190176,                          // Right elbow (direction of neck)
        -1.2842957,                          // Left hand (direction of left elbow)
        -1.5263184));                        // Right hand (direction of right elbow)

    sequence.add(new StickFigure(
        50.0,                                // Size
        new PVector(350.0, 270.0),           // Pelvis position
        -1.663126,                           // Left knee (direction of pelvis)
        -3.0676537,                          // Right knee (direction of pelvis)
        -1.3352766,                          // Left foot (direction of left knee)
        -1.9885864,                          // Right foot (direction of right knee)
        -4.5325356,                          // Chest (direction of pelvis)
        -4.5325356,                          // Neck (direction of chest)
        -4.5325356,                          // Head (direction of neck
        -0.89159656,                         // Left elbow (direction of neck)
        -1.9190176,                          // Right elbow (direction of neck)
        -1.2842957,                          // Left hand (direction of left elbow)
        -1.5263184));                        // Right hand (direction of right elbow)

    sequence.add(new StickFigure(
        50.0,                                // Size
        new PVector(367.0, 252.0),           // Pelvis position
        -1.5191183,                          // Left knee (direction of pelvis)
        -2.9116883,                          // Right knee (direction of pelvis)
        -0.9374547,                          // Left foot (direction of left knee)
        -1.8326211,                          // Right foot (direction of right knee)
        -4.5325356,                          // Chest (direction of pelvis)
        -4.5325356,                          // Neck (direction of chest)
        -4.5325356,                          // Head (direction of neck
        -0.89159656,                         // Left elbow (direction of neck)
        -1.9190176,                          // Right elbow (direction of neck)
        -1.2842957,                          // Left hand (direction of left elbow)
        -1.5263184));                        // Right hand (direction of right elbow)

    sequence.add(new StickFigure(
        50.0,                                // Size
        new PVector(375.0, 237.0),           // Pelvis position
        -1.8157749,                          // Left knee (direction of pelvis)
        -2.6563654,                          // Right knee (direction of pelvis)
        -0.7463021,                          // Left foot (direction of left knee)
        -1.7229581,                          // Right foot (direction of right knee)
        -4.5325356,                          // Chest (direction of pelvis)
        -4.5325356,                          // Neck (direction of chest)
        -4.5325356,                          // Head (direction of neck
        -0.89159656,                         // Left elbow (direction of neck)
        -1.9190176,                          // Right elbow (direction of neck)
        -1.2842957,                          // Left hand (direction of left elbow)
        -1.5263184));                        // Right hand (direction of right elbow)
        
    sequence.add(new StickFigure(
        50.0,                                // Size
        new PVector(378.0, 218.0),           // Pelvis position
        -2.0085878,                          // Left knee (direction of pelvis)
        -2.4805498,                          // Right knee (direction of pelvis)
        -0.93911505,                         // Left foot (direction of left knee)
        -1.8468313,                          // Right foot (direction of right knee)
        -4.4369626,                          // Chest (direction of pelvis)
        -4.4369626,                          // Neck (direction of chest)
        -4.4369626,                          // Head (direction of neck
        -0.7960236,                          // Left elbow (direction of neck)
        -1.8234446,                          // Right elbow (direction of neck)
        -1.1887227,                          // Left hand (direction of left elbow)
        -1.4307455));                        // Right hand (direction of right elbow)

    sequence.add(new StickFigure(
        50.0,                                // Size
        new PVector(384.0, 211.0),           // Pelvis position
        -1.8606429,                          // Left knee (direction of pelvis)
        -2.3136668,                          // Right knee (direction of pelvis)
        -1.0801597,                          // Left foot (direction of left knee)
        -1.6799483,                          // Right foot (direction of right knee)
        -4.4369626,                          // Chest (direction of pelvis)
        -4.4369626,                          // Neck (direction of chest)
        -4.4369626,                          // Head (direction of neck
        -0.7960236,                          // Left elbow (direction of neck)
        -1.8234446,                          // Right elbow (direction of neck)
        -1.1887227,                          // Left hand (direction of left elbow)
        -1.4307455));                        // Right hand (direction of right elbow)
    
    sequence.add(new StickFigure(
        50.0,                                // Size
        new PVector(405.0, 203.0),           // Pelvis position
        -2.267539,                           // Left knee (direction of pelvis)
        -2.0344443,                          // Right knee (direction of pelvis)
        -1.4870558,                          // Left foot (direction of left knee)
        -1.6131501,                          // Right foot (direction of right knee)
        -4.4369626,                          // Chest (direction of pelvis)
        -4.4369626,                          // Neck (direction of chest)
        -4.4369626,                          // Head (direction of neck
        -0.7960236,                          // Left elbow (direction of neck)
        -1.8234446,                          // Right elbow (direction of neck)
        -1.1887227,                          // Left hand (direction of left elbow)
        -1.4307455));                        // Right hand (direction of right elbow)

    sequence.add(new StickFigure(
        50.0,                                // Size
        new PVector(419.0, 201.0),           // Pelvis position
        -2.5127964,                          // Left knee (direction of pelvis)
        -1.8203835,                          // Right knee (direction of pelvis)
        -1.7323132,                          // Left foot (direction of left knee)
        -1.3990893,                          // Right foot (direction of right knee)
        -4.6248937,                          // Chest (direction of pelvis)
        -4.6248937,                          // Neck (direction of chest)
        -4.6248937,                          // Head (direction of neck
        -0.98395467,                         // Left elbow (direction of neck)
        -2.0113757,                          // Right elbow (direction of neck)
        -1.3766538,                          // Left hand (direction of left elbow)
        -1.6186765));                        // Right hand (direction of right elbow)

    sequence.add(new StickFigure(
        50.0,                                // Size
        new PVector(431.0, 196.0),           // Pelvis position
        -2.0344439,                          // Left knee (direction of pelvis)
        -1.5096483,                          // Right knee (direction of pelvis)
        -1.5644994,                          // Left foot (direction of left knee)
        -1.3011842,                          // Right foot (direction of right knee)
        -4.808248,                           // Chest (direction of pelvis)
        -4.808248,                           // Neck (direction of chest)
        -4.808248,                           // Head (direction of neck
        -1.167309,                           // Left elbow (direction of neck)
        -2.19473,                            // Right elbow (direction of neck)
        -1.5600082,                          // Left hand (direction of left elbow)
        -1.8020309));                        // Right hand (direction of right elbow)

    sequence.add(new StickFigure(
        50.0,                                // Size
        new PVector(431.0, 196.0),           // Pelvis position
        -1.8281202,                          // Left knee (direction of pelvis)
        -1.2998495,                          // Right knee (direction of pelvis)
        -1.8750548,                          // Left foot (direction of left knee)
        -1.558876,                           // Right foot (direction of right knee)
        -4.808248,                           // Chest (direction of pelvis)
        -4.808248,                           // Neck (direction of chest)
        -4.808248,                           // Head (direction of neck
        -1.167309,                           // Left elbow (direction of neck)
        -2.19473,                            // Right elbow (direction of neck)
        -1.5600082,                          // Left hand (direction of left elbow)
        -1.8020309));                        // Right hand (direction of right elbow)

    sequence.add(new StickFigure(
        50.0,                                // Size
        new PVector(431.0, 213.0),           // Pelvis position
        -1.9255023,                          // Left knee (direction of pelvis)
        -1.0617256,                          // Right knee (direction of pelvis)
        -2.226633,                           // Left foot (direction of left knee)
        -1.7479095,                          // Right foot (direction of right knee)
        -4.974509,                           // Chest (direction of pelvis)
        -4.974509,                           // Neck (direction of chest)
        -4.974509,                           // Head (direction of neck
        -1.3335698,                          // Left elbow (direction of neck)
        -2.1426647,                          // Right elbow (direction of neck)
        -1.7262688,                          // Left hand (direction of left elbow)
        -1.7499657));                        // Right hand (direction of right elbow)

    sequence.add(new StickFigure(
        50.0,                                // Size
        new PVector(447.0, 209.0),           // Pelvis position
        -1.5070529,                          // Left knee (direction of pelvis)
        -0.9616332,                          // Right knee (direction of pelvis)
        -1.8676629,                          // Left foot (direction of left knee)
        -1.6478171,                          // Right foot (direction of right knee)
        -5.052771,                           // Chest (direction of pelvis)
        -5.052771,                           // Neck (direction of chest)
        -5.052771,                           // Head (direction of neck
        -1.4049957,                          // Left elbow (direction of neck)
        -2.0214493,                          // Right elbow (direction of neck)
        -1.7976947,                          // Left hand (direction of left elbow)
        -1.6287503));                        // Right hand (direction of right elbow)

    sequence.add(new StickFigure(
        50.0,                                // Size
        new PVector(447.0, 217.0),           // Pelvis position
        -1.2953706,                          // Left knee (direction of pelvis)
        -0.80978394,                         // Right knee (direction of pelvis)
        -1.8474841,                          // Left foot (direction of left knee)
        -1.6683769,                          // Right foot (direction of right knee)
        -5.231535,                           // Chest (direction of pelvis)
        -5.231535,                           // Neck (direction of chest)
        -5.231535,                           // Head (direction of neck
        -1.2772477,                          // Left elbow (direction of neck)
        -1.8526719,                          // Right elbow (direction of neck)
        -1.6699467,                          // Left hand (direction of left elbow)
        -1.1089549));                        // Right hand (direction of right elbow)

    sequence.add(new StickFigure(
        50.0,                                // Size
        new PVector(455.0, 226.0),           // Pelvis position
        -1.016489,                           // Left knee (direction of pelvis)
        -0.61253786,                         // Right knee (direction of pelvis)
        -2.1361012,                          // Left foot (direction of left knee)
        -1.7065849,                          // Right foot (direction of right knee)
        -5.3003917,                          // Chest (direction of pelvis)
        -5.3003917,                          // Neck (direction of chest)
        -5.3003917,                          // Head (direction of neck
        -1.2356594,                          // Left elbow (direction of neck)
        -1.7929542,                          // Right elbow (direction of neck)
        -1.6283584,                          // Left hand (direction of left elbow)
        -1.0492373));                        // Right hand (direction of right elbow)

    sequence.add(new StickFigure(
        50.0,                                // Size
        new PVector(462.0, 231.0),           // Pelvis position
        -0.85773563,                         // Left knee (direction of pelvis)
        -0.37433386,                         // Right knee (direction of pelvis)
        -2.0152583,                          // Left foot (direction of left knee)
        -1.6404343,                          // Right foot (direction of right knee)
        -5.509835,                           // Chest (direction of pelvis)
        -5.509835,                           // Neck (direction of chest)
        -5.509835,                           // Head (direction of neck
        -1.18244,                            // Left elbow (direction of neck)
        -1.7544,                             // Right elbow (direction of neck)
        -1.575139,                           // Left hand (direction of left elbow)
        -1.0106831));                        // Right hand (direction of right elbow)

    sequence.add(new StickFigure(
        50.0,                                // Size
        new PVector(475.0, 239.0),           // Pelvis position
        -0.6470475,                          // Left knee (direction of pelvis)
        -0.09347677,                         // Right knee (direction of pelvis)
        -2.052702,                           // Left foot (direction of left knee)
        -1.4713659,                          // Right foot (direction of right knee)
        -5.753596,                           // Chest (direction of pelvis)
        -5.753596,                           // Neck (direction of chest)
        -5.753596,                           // Head (direction of neck
        -1.0894582,                          // Left elbow (direction of neck)
        -1.664324,                           // Right elbow (direction of neck)
        -1.4821572,                          // Left hand (direction of left elbow)
        -0.9206071));                        // Right hand (direction of right elbow)

    // Pulled sequence
    sequence = pulled;

    sequence.add(new StickFigure(            // 0
        40.0,                                // Size
        new PVector(347.0, 403.0),           // Pelvis position
        -0.46364784,                         // Left knee (direction of pelvis)
        -2.1527019,                          // Right knee (direction of pelvis)
        -1.4168835,                          // Left foot (direction of left knee)
        -2.710081,                           // Right foot (direction of right knee)
        -5.120538,                           // Chest (direction of pelvis)
        -5.120538,                           // Neck (direction of chest)
        -5.120538,                           // Head (direction of neck
        -1.1509335,                          // Left elbow (direction of neck)
        -1.9227922,                          // Right elbow (direction of neck)
        -1.8221608,                          // Left hand (direction of left elbow)
        -1.3683008));                        // Right hand (direction of right elbow)

    sequence.add(new StickFigure(            // 1
        40.0,                                // Size
        new PVector(343.0, 390.0),           // Pelvis position
        -0.7672186,                          // Left knee (direction of pelvis)
        -1.7577758,                          // Right knee (direction of pelvis)
        -1.3873653,                          // Left foot (direction of left knee)
        -2.100618,                           // Right foot (direction of right knee)
        -4.993621,                           // Chest (direction of pelvis)
        -4.993621,                           // Neck (direction of chest)
        -4.993621,                           // Head (direction of neck
        -1.0240161,                          // Left elbow (direction of neck)
        -1.7958748,                          // Right elbow (direction of neck)
        -1.6952435,                          // Left hand (direction of left elbow)
        -1.2413834));                        // Right hand (direction of right elbow)

    sequence.add(new StickFigure(            // 2
        40.0,                                // Size
        new PVector(342.0, 376.0),           // Pelvis position
        -1.0303769,                          // Left knee (direction of pelvis)
        -1.7782927,                          // Right knee (direction of pelvis)
        -1.4026041,                          // Left foot (direction of left knee)
        -1.8365326,                          // Right foot (direction of right knee)
        -4.8542857,                          // Chest (direction of pelvis)
        -4.8542857,                          // Neck (direction of chest)
        -4.8542857,                          // Head (direction of neck
        -0.47311044,                         // Left elbow (direction of neck)
        -1.2943819,                          // Right elbow (direction of neck)
        -1.1443378,                          // Left hand (direction of left elbow)
        -0.73989046));                       // Right hand (direction of right elbow)
    
    sequence.add(new StickFigure(            // 3
        40.0,                                // Size
        new PVector(342.0, 380.0),           // Pelvis position
        -1.1354432,                          // Left knee (direction of pelvis)
        -1.9173355,                          // Right knee (direction of pelvis)
        -1.3392758,                          // Left foot (direction of left knee)
        -1.7316055,                          // Right foot (direction of right knee)
        -4.789161,                           // Chest (direction of pelvis)
        -4.789161,                           // Neck (direction of chest)
        -4.789161,                           // Head (direction of neck
        0.11617446,                          // Left elbow (direction of neck)
        -0.78366446,                         // Right elbow (direction of neck)
        -0.5550529,                          // Left hand (direction of left elbow)
        -0.22917306));                       // Right hand (direction of right elbow)
    
    sequence.add(new StickFigure(            // 4
        40.0,                                // Size
        new PVector(342.0, 380.0),           // Pelvis position
        -1.1354432,                          // Left knee (direction of pelvis)
        -1.9173355,                          // Right knee (direction of pelvis)
        -1.3392758,                          // Left foot (direction of left knee)
        -1.7316055,                          // Right foot (direction of right knee)
        -4.789161,                           // Chest (direction of pelvis)
        -4.789161,                           // Neck (direction of chest)
        -4.789161,                           // Head (direction of neck
        0.67700005,                          // Left elbow (direction of neck)
        -0.09921169,                         // Right elbow (direction of neck)
        0.16050565,                          // Left hand (direction of left elbow)
        0.18394887));                        // Right hand (direction of right elbow)
    
    sequence.add(new StickFigure(            // 5
        40.0,                                // Size
        new PVector(342.0, 380.0),           // Pelvis position
        -1.1354432,                          // Left knee (direction of pelvis)
        -1.9173355,                          // Right knee (direction of pelvis)
        -1.3392758,                          // Left foot (direction of left knee)
        -1.7316055,                          // Right foot (direction of right knee)
        -4.789161,                           // Chest (direction of pelvis)
        -4.789161,                           // Neck (direction of chest)
        -4.789161,                           // Head (direction of neck
        1.3669648,                           // Left elbow (direction of neck)
        0.8212588,                           // Right elbow (direction of neck)
        1.2476994,                           // Left hand (direction of left elbow)
        1.1044194));                         // Right hand (direction of right elbow)

    sequence.add(new StickFigure(            // 6
        40.0,                                // Size
        new PVector(342.0, 380.0),           // Pelvis position
        -1.1354432,                          // Left knee (direction of pelvis)
        -1.9173355,                          // Right knee (direction of pelvis)
        -1.3392758,                          // Left foot (direction of left knee)
        -1.7316055,                          // Right foot (direction of right knee)
        -4.789161,                           // Chest (direction of pelvis)
        -4.789161,                           // Neck (direction of chest)
        -4.53821,                            // Head (direction of neck
        1.9846013,                           // Left elbow (direction of neck)
        1.4449024,                           // Right elbow (direction of neck)
        1.8653358,                           // Left hand (direction of left elbow)
        1.728063));                          // Right hand (direction of right elbow)
    
    sequence.add(new StickFigure(            // 7
        40.0,                                // Size
        new PVector(342.0, 380.0),           // Pelvis position
        -1.1354432,                          // Left knee (direction of pelvis)
        -1.9173355,                          // Right knee (direction of pelvis)
        -1.3392758,                          // Left foot (direction of left knee)
        -1.7316055,                          // Right foot (direction of right knee)
        -4.789161,                           // Chest (direction of pelvis)
        -4.789161,                           // Neck (direction of chest)
        -4.9947534,                          // Head (direction of neck
        2.31397,                             // Left elbow (direction of neck)
        1.8637357,                           // Right elbow (direction of neck)
        2.1947048,                           // Left hand (direction of left elbow)
        2.437216));                          // Right hand (direction of right elbow)

    sequence.add(new StickFigure(            // 8
        40.0,                                // Size
        new PVector(347.0, 371.0),           // Pelvis position
        -1.5056715,                          // Left knee (direction of pelvis)
        -2.145101,                           // Right knee (direction of pelvis)
        -1.7095041,                          // Left foot (direction of left knee)
        -1.9593711,                          // Right foot (direction of right knee)
        -4.770017,                           // Chest (direction of pelvis)
        -4.770017,                           // Neck (direction of chest)
        -4.9756093,                          // Head (direction of neck
        2.3331141,                           // Left elbow (direction of neck)
        1.8828797,                           // Right elbow (direction of neck)
        2.2138488,                           // Left hand (direction of left elbow)
        2.45636));                           // Right hand (direction of right elbow)
    
    sequence.add(new StickFigure(            // 9
        40.0,                                // Size
        new PVector(353.0, 359.0),           // Pelvis position
        -1.877842,                           // Left knee (direction of pelvis)
        -2.5602126,                          // Right knee (direction of pelvis)
        -1.8086829,                          // Left foot (direction of left knee)
        -2.0460563,                          // Right foot (direction of right knee)
        -4.770017,                           // Chest (direction of pelvis)
        -4.770017,                           // Neck (direction of chest)
        -4.9756093,                          // Head (direction of neck
        2.3331141,                           // Left elbow (direction of neck)
        1.8828797,                           // Right elbow (direction of neck)
        2.2138488,                           // Left hand (direction of left elbow)
        2.45636));                           // Right hand (direction of right elbow)

     sequence.add(new StickFigure(           // 10
        40.0,                                // Size
        new PVector(359.0, 351.0),           // Pelvis position
        -2.7430706,                          // Left knee (direction of pelvis)
        -2.164546,                           // Right knee (direction of pelvis)
        -2.1607199,                          // Left foot (direction of left knee)
        -1.6503897,                          // Right foot (direction of right knee)
        -4.770017,                           // Chest (direction of pelvis)
        -4.770017,                           // Neck (direction of chest)
        -4.9756093,                          // Head (direction of neck
        2.3331141,                           // Left elbow (direction of neck)
        1.8828797,                           // Right elbow (direction of neck)
        2.2138488,                           // Left hand (direction of left elbow)
        2.45636));                           // Right hand (direction of right elbow)

    sequence.add(new StickFigure(
        40.0,                                // Size
        new PVector(364.0, 312.0),           // Pelvis position
        -2.896614,                           // Left knee (direction of pelvis)
        -1.8993497,                          // Right knee (direction of pelvis)
        -1.4074306,                          // Left foot (direction of left knee)
        -1.3851933,                          // Right foot (direction of right knee)
        -4.770017,                           // Chest (direction of pelvis)
        -4.770017,                           // Neck (direction of chest)
        -4.9756093,                          // Head (direction of neck
        2.3331141,                           // Left elbow (direction of neck)
        1.8828797,                           // Right elbow (direction of neck)
        2.3867831,                           // Left hand (direction of left elbow)
        2.6701944));                         // Right hand (direction of right elbow)
    
     sequence.add(new StickFigure(
        40.0,                                // Size
        new PVector(379.0, 282.0),           // Pelvis position
        -3.0750246,                          // Left knee (direction of pelvis)
        -2.1815224,                          // Right knee (direction of pelvis)
        -2.071773,                           // Left foot (direction of left knee)
        -1.9252033,                          // Right foot (direction of right knee)
        -4.5364494,                          // Chest (direction of pelvis)
        -4.5364494,                          // Neck (direction of chest)
        -4.7420416,                          // Head (direction of neck
        2.2107358,                           // Left elbow (direction of neck)
        1.7833147,                           // Right elbow (direction of neck)
        1.9011583,                           // Left hand (direction of left elbow)
        2.1749256));                         // Right hand (direction of right elbow)
    
    sequence.add(new StickFigure(
        40.0,                                // Size
        new PVector(371.0, 273.0),           // Pelvis position
        -3.0750246,                          // Left knee (direction of pelvis)
        -2.34127,                            // Right knee (direction of pelvis)
        -2.071773,                           // Left foot (direction of left knee)
        -2.084951,                           // Right foot (direction of right knee)
        -4.661152,                           // Chest (direction of pelvis)
        -4.661152,                           // Neck (direction of chest)
        -4.866744,                           // Head (direction of neck
        2.445072,                            // Left elbow (direction of neck)
        1.9178686,                           // Right elbow (direction of neck)
        2.1354945,                           // Left hand (direction of left elbow)
        2.3094795));                         // Right hand (direction of right elbow)
    
    sequence.add(new StickFigure(
        40.0,                                // Size
        new PVector(396.0, 279.0),           // Pelvis position
        -3.0750246,                          // Left knee (direction of pelvis)
        -2.045196,                           // Right knee (direction of pelvis)
        -2.071773,                           // Left foot (direction of left knee)
        -1.788877,                           // Right foot (direction of right knee)
        -4.7540317,                          // Chest (direction of pelvis)
        -4.7540317,                          // Neck (direction of chest)
        -4.959624,                           // Head (direction of neck
        2.3521922,                           // Left elbow (direction of neck)
        1.8249888,                           // Right elbow (direction of neck)
        2.0426147,                           // Left hand (direction of left elbow)
        2.2165997));                         // Right hand (direction of right elbow)

    sequence.add(new StickFigure(
        40.0,                                // Size
        new PVector(413.0, 267.0),           // Pelvis position
        -2.8198419,                          // Left knee (direction of pelvis)
        -1.8925471,                          // Right knee (direction of pelvis)
        -1.8165903,                          // Left foot (direction of left knee)
        -1.6362281,                          // Right foot (direction of right knee)
        -4.7540317,                          // Chest (direction of pelvis)
        -4.7540317,                          // Neck (direction of chest)
        -4.959624,                           // Head (direction of neck
        2.3521922,                           // Left elbow (direction of neck)
        1.8249888,                           // Right elbow (direction of neck)
        2.0426147,                           // Left hand (direction of left elbow)
        2.2165997));                         // Right hand (direction of right elbow)
    
    sequence.add(new StickFigure(
        40.0,                                // Size
        new PVector(433.0, 258.0),           // Pelvis position
        -2.4788632,                          // Left knee (direction of pelvis)
        -1.5964317,                          // Right knee (direction of pelvis)
        -1.4756117,                          // Left foot (direction of left knee)
        -1.3401127,                          // Right foot (direction of right knee)
        -4.7540317,                          // Chest (direction of pelvis)
        -4.7540317,                          // Neck (direction of chest)
        -4.959624,                           // Head (direction of neck
        2.748405,                            // Left elbow (direction of neck)
        2.228761,                            // Right elbow (direction of neck)
        2.4388275,                           // Left hand (direction of left elbow)
        2.6203718));                         // Right hand (direction of right elbow)
    
    sequence.add(new StickFigure(
        40.0,                                // Size
        new PVector(451.0, 255.0),           // Pelvis position
        -2.2253675,                          // Left knee (direction of pelvis)
        -1.4121413,                          // Right knee (direction of pelvis)
        -1.6897063,                          // Left foot (direction of left knee)
        -1.1558223,                          // Right foot (direction of right knee)
        -4.7540317,                          // Chest (direction of pelvis)
        -4.7540317,                          // Neck (direction of chest)
        -4.959624,                           // Head (direction of neck
        2.014172,                            // Left elbow (direction of neck)
        1.397362,                            // Right elbow (direction of neck)
        1.7045946,                           // Left hand (direction of left elbow)
        1.7889729));                         // Right hand (direction of right elbow)
    
    sequence.add(new StickFigure(
        40.0,                                // Size
        new PVector(451.0, 255.0),           // Pelvis position
        -2.2253675,                          // Left knee (direction of pelvis)
        -1.4121413,                          // Right knee (direction of pelvis)
        -1.6897063,                          // Left foot (direction of left knee)
        -1.1558223,                          // Right foot (direction of right knee)
        -4.7540317,                          // Chest (direction of pelvis)
        -4.7540317,                          // Neck (direction of chest)
        -4.85077,                            // Head (direction of neck
        1.19591,                             // Left elbow (direction of neck)
        0.56038594,                          // Right elbow (direction of neck)
        0.8863325,                           // Left hand (direction of left elbow)
        0.9519968));                         // Right hand (direction of right elbow)
    
    sequence.add(new StickFigure(
        40.0,                                // Size
        new PVector(465.0, 252.0),           // Pelvis position
        -1.6983061,                          // Left knee (direction of pelvis)
        -2.107232,                           // Right knee (direction of pelvis)
        -1.1626449,                          // Left foot (direction of left knee)
        -1.4124746,                          // Right foot (direction of right knee)
        -4.7540317,                          // Chest (direction of pelvis)
        -4.7540317,                          // Neck (direction of chest)
        -4.85077,                            // Head (direction of neck
        0.17711496,                          // Left elbow (direction of neck)
        -0.610337,                           // Right elbow (direction of neck)
        -0.1324625,                          // Left hand (direction of left elbow)
        -0.21872616));                       // Right hand (direction of right elbow)
    
    sequence.add(new StickFigure(
        40.0,                                // Size
        new PVector(465.0, 252.0),           // Pelvis position
        -1.570796,                           // Left knee (direction of pelvis)
        -2.327631,                           // Right knee (direction of pelvis)
        -1.0351348,                          // Left foot (direction of left knee)
        -1.6328735,                          // Right foot (direction of right knee)
        -4.6880035,                          // Chest (direction of pelvis)
        -4.6880035,                          // Neck (direction of chest)
        -4.784742,                           // Head (direction of neck
        -0.7346363,                          // Left elbow (direction of neck)
        -1.4467123,                          // Right elbow (direction of neck)
        -1.0442138,                          // Left hand (direction of left elbow)
        -1.0551014));                        // Right hand (direction of right elbow)

    StickFigure walkStart = walkShort.get(0).copy();
    walkStart.pv.set(465, 252);
    sequence.add(walkStart);

    // Pull sequence

    sequence = pull;
  
    sequence.add(new StickFigure(
        50.0,                                // Size
        new PVector(475.0, 239.0),           // Pelvis position
        -0.6470475,                          // Left knee (direction of pelvis)
        -0.09347677,                         // Right knee (direction of pelvis)
        -2.052702,                           // Left foot (direction of left knee)
        -1.4713659,                          // Right foot (direction of right knee)
        -5.753596,                           // Chest (direction of pelvis)
        -5.753596,                           // Neck (direction of chest)
        -5.753596,                           // Head (direction of neck
        -1.0894582,                          // Left elbow (direction of neck)
        -1.664324,                           // Right elbow (direction of neck)
        -1.4821572,                          // Left hand (direction of left elbow)
        -0.9206071));                        // Right hand (direction of right elbow)

      sequence.add(new StickFigure(
        50.0,                                // Size
        new PVector(493.0, 231.0),           // Pelvis position
        -0.8557048,                          // Left knee (direction of pelvis)
        -0.23684883,                         // Right knee (direction of pelvis)
        -2.1273375,                          // Left foot (direction of left knee)
        -1.2091155,                          // Right foot (direction of right knee)
        -5.709745,                           // Chest (direction of pelvis)
        -5.709745,                           // Neck (direction of chest)
        -5.709745,                           // Head (direction of neck
        -1.0456073,                          // Left elbow (direction of neck)
        -1.6204731,                          // Right elbow (direction of neck)
        -1.4383063,                          // Left hand (direction of left elbow)
        -0.8767562));                        // Right hand (direction of right elbow)

    sequence.add(new StickFigure(
        50.0,                                // Size
        new PVector(497.0, 226.0),           // Pelvis position
        -0.8318763,                          // Left knee (direction of pelvis)
        -0.6022873,                          // Right knee (direction of pelvis)
        -1.7142816,                          // Left foot (direction of left knee)
        -1.574554,                           // Right foot (direction of right knee)
        -5.4578085,                          // Chest (direction of pelvis)
        -5.4578085,                          // Neck (direction of chest)
        -5.4578085,                          // Head (direction of neck
        -0.7936709,                          // Left elbow (direction of neck)
        -1.3685367,                          // Right elbow (direction of neck)
        -1.1863699,                          // Left hand (direction of left elbow)
        -0.62481976));                       // Right hand (direction of right elbow)
    

    sequence.add(new StickFigure(
        50.0,                                // Size
        new PVector(508.0, 218.0),           // Pelvis position
        -1.2036228,                          // Left knee (direction of pelvis)
        -0.4711666,                          // Right knee (direction of pelvis)
        -1.4637899,                          // Left foot (direction of left knee)
        -1.4434333,                          // Right foot (direction of right knee)
        -5.3003917,                          // Chest (direction of pelvis)
        -5.3003917,                          // Neck (direction of chest)
        -5.3003917,                          // Head (direction of neck
        -0.6362541,                          // Left elbow (direction of neck)
        -1.2111199,                          // Right elbow (direction of neck)
        -1.0289531,                          // Left hand (direction of left elbow)
        -0.46740294));                       // Right hand (direction of right elbow)

    sequence.add(new StickFigure(
        50.0,                                // Size
        new PVector(508.0, 218.0),           // Pelvis position
        -1.4369855,                          // Left knee (direction of pelvis)
        -0.8884797,                          // Right knee (direction of pelvis)
        -1.6971526,                          // Left foot (direction of left knee)
        -1.5176158,                          // Right foot (direction of right knee)
        -4.8954997,                          // Chest (direction of pelvis)
        -4.8954997,                          // Neck (direction of chest)
        -4.8954997,                          // Head (direction of neck
        -0.2313621,                          // Left elbow (direction of neck)
        -0.8062279,                          // Right elbow (direction of neck)
        -0.6240611,                          // Left hand (direction of left elbow)
        -0.06251097));                       // Right hand (direction of right elbow)

    sequence.add(new StickFigure(
        50.0,                                // Size
        new PVector(508.0, 218.0),           // Pelvis position
        -1.4369855,                          // Left knee (direction of pelvis)
        -0.8884797,                          // Right knee (direction of pelvis)
        -1.6971526,                          // Left foot (direction of left knee)
        -1.5176158,                          // Right foot (direction of right knee)
        -4.653633,                           // Chest (direction of pelvis)
        -4.653633,                           // Neck (direction of chest)
        -4.653633,                           // Head (direction of neck
        0.010504484,                         // Left elbow (direction of neck)
        -0.56436133,                         // Right elbow (direction of neck)
        -0.38219452,                         // Left hand (direction of left elbow)
        0.17935562));                        // Right hand (direction of right elbow)

    // End of pull sequence

  }
};


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
 * I will write something about the StickPuppet class here
 */
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

  void tween(float value, float start, float stop, StickFigure a, StickFigure b) {

    float x = map(value, start, stop, a.pv.x, b.pv.x);
    float y = map(value, start, stop, a.pv.y, b.pv.y);
    pv.set(x, y);

    vertices.get(0).tween(value, start, stop, a.vertices.get(0), b.vertices.get(0));

  }

};

/**
 * I will write something about the StickFigure class here
 */
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
