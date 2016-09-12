import processing.video.*;

Capture video;
PImage img;
boolean hmd, translucent;

void setup() {
  size(640, 480);
  video = new Capture(this, width, height);
  video.start();  
  img = loadImage("oculus_front.png");
  translucent = false; //四角形
  hmd = true;//oculus
  noStroke();
  smooth();
  rectMode(CORNER);
  println("toggle hmd mode with the key h");
  println("toggle translucent rect mode with the key t");
  println("hmd turn " + (hmd ? "on":"off"));
  println("translucent rect turn " + (translucent ? "on":"off"));
}

void draw() {
  if (video.available()) {
    video.read();
    scale(-1, 1);
    image(video, 0, 0, -width, height); // Draw the webcam video onto the screen
    int brightestX = 0; // X-coordinate of the brightest video pixel
    int brightestY = 0; // Y-coordinate of the brightest video pixel
    int brightestX2 = 0; // X-coordinate of the brightest video pixel
    int brightestY2 = 0; // Y-coordinate of the brightest video pixel
    float brightestValue = 0; // Brightness of the brightest video pixel
    float brightestValue2 = 0;
    // Search for the brightest pixel: For each row of pixels in the video image and
    // for each pixel in the yth row, compute each pixel's index in the video
    video.loadPixels();
    int index = 0;
    for (int y = 0; y < video.height; y++) {
      for (int x = 0; x < video.width; x++) {
        // Get the color stored in the pixel
        int pixelValue = video.pixels[index];
        // Determine the brightness of the pixel
        float pixelBrightness = brightness(pixelValue);
        // If that value is brighter than any previous, then store the
        // brightness of that pixel, as well as its (x,y) location
        //一番明るいのを検出
        if (pixelBrightness > brightestValue) {
          brightestValue = pixelBrightness;
          brightestY = y;
          brightestX = x;
        }
        index++;
      }
    }
    index = 0;
    for (int y = 0; y < video.height; y++) {
      for (int x = 0; x < video.width; x++) {
        //一番明るいのから10√10以上離れた点の中で一番明るいのを検出
        if (sq(brightestY-y)+sq(brightestX-x)>1000) {
          int pixelValue = video.pixels[index];
          float pixelBrightness = brightness(pixelValue);
          if (pixelBrightness > brightestValue2) {
            brightestValue2 = pixelBrightness;
            brightestY2 = y;
            brightestX2 = x;
          }
        }
        index++;
      }
    }
    // Draw a large, yellow circle at the brightest pixel
    //fill(255, 204, 0, 128);

    fill(255, 200, 200, 200);//四角形の色
    scale(-1, 1);

    brightestX=width-brightestX;
    brightestX2=width-brightestX2;
    //ellipse(brightestX, brightestY, 100, 100);//一番明るい場所
    //ellipse(brightestX2, brightestY2, 100, 100);//二番目に明るい場所
    boolean lef = brightestX<brightestX2?true:false;//brightestXとbrightestX2のどちらが左にあるか
    brightestY=brightestY-10;
    brightestY2=brightestY2-10;
    //rect(min(brightestX,brightestX2)-10,brightestY-10,abs(brightestX-brightestX2)+20,abs(brightestX-brightestX2)/2);
    if (translucent) {
      if (lef) {
        //brightestXが左にあるとき
        brightestX=brightestX-10;
        brightestX2=brightestX2+10;
        //明るい点も覆い隠すように範囲を広げる
        //quad()は4点指定でその順番に四角形を作る
        quad(brightestX, brightestY, 
          brightestX2, brightestY2, 
          brightestX2+(brightestY-brightestY2)/2, brightestY2+(brightestX2-brightestX)/2, 
          brightestX+(brightestY-brightestY2)/2, brightestY+(brightestX2-brightestX)/2);
      } else {
        //brightestX2が左にあるとき
        brightestX2=brightestX2-10;
        brightestX=brightestX+10;
        //明るい点も覆い隠すように範囲を広げる
        quad(brightestX2, brightestY2, 
          brightestX, brightestY, 
          brightestX+(brightestY2-brightestY)/2, brightestY+(brightestX-brightestX2)/2, 
          brightestX2+(brightestY2-brightestY)/2, brightestY2+(brightestX-brightestX2)/2);
      }
    }
    if (hmd) {
      if (lef) {
        brightestX=brightestX-10;
        brightestX2=brightestX2+10;
        translate(brightestX, brightestY);//回転の中心を左に移動
        scale(sqrt(sq(brightestY-brightestY2)+sq(brightestX-brightestX2))/img.width);//横の長さを計算
        rotate(atan2((brightestY2-brightestY), (brightestX2-brightestX)));//回転量を計算
      } else {
        brightestX2=brightestX2-10;
        brightestX=brightestX+10;
        translate(brightestX2, brightestY2);
        scale(sqrt(sq(brightestY-brightestY2)+sq(brightestX-brightestX2))/img.width);
        rotate(atan2((brightestY-brightestY2), (brightestX-brightestX2)));
      }

      image(img, 0, 0);//imgを表示
    }
  }
}

void keyPressed() {
  //スペースキーを押したらキャプチャ
  if (key==' ') {
    save("capture.png");
  }
  if (key=='h') {
    hmd = !hmd;
    println("hmd turn " + (hmd ? "on":"off"));
  }
  if (key=='t') {
    translucent =!translucent;
    println("translucent rect turn " + (translucent ? "on":"off"));
  }
}