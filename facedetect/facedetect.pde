import processing.video.*;
import gab.opencv.*;
import java.awt.Rectangle;

Capture video;
OpenCV opencv;
Rectangle[] faces;

PImage pic;

void setup() {
  size(640, 480);
  video = new Capture(this, 640, 480, 30);
  video.start();
}

void draw() {
  if (video.available()) video.read();

  opencv = new OpenCV(this, video);

  pic = loadImage("oculus_front.png");

  opencv.loadCascade("../../../../../../Desktop/infraredtest/facedetect/data/lbpcascade_frontalface.xml");
  faces = opencv.detect();
  scale(-1,1);
  image(opencv.getInput(), 0, 0,-width,height);
  scale(-1,1);
  for (int i = 0; i < faces.length; i++) {
    
    image(pic, width-faces[0].x, faces[0].y, -faces[0].width, faces[0].width/2);
    //(貼り付ける画像、ｘ座標、ｙ座標、横の長さ、縦の長さ)
    //画像の表示位置は微調整してください
  }
}