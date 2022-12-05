import processing.video.*; // Videoを扱うライブラリをインポート
Capture camera; // ライブカメラの映像をあつかうCapture型の変数
PImage ghost;
PImage room;
PImage room2;
PImage futon;
int h=100, w=100;
void setup() {
  size(1920, 1080);
  fill(100, 0, 100);
  rect(0, 0, 100, 100);
  try {
    String[] cameras = Capture.list();
    camera = new Capture(this, cameras[0]); // Captureオブジェクトを生成
    camera.start();
    room=loadImage("Room.png");
    room2=loadImage("Room2.png");
    futon=loadImage("Futon.png");
  }
  catch(Exception e) {
    println(e);
  }
  noStroke();
}

boolean ghostFlag=false;
void draw() {
  int counterB=0, counterW=0;

  //image(camera, 0, 0); // 画面に表示
  PImage img=camera.copy();
  img.filter(THRESHOLD, 0.5);

  img.loadPixels();
  for (int i=0; i<h; i++)
  {
    for (int j=0; j<w; j++)
    {
      int c=img.pixels[h*i+j];
      if (c>0xFFAAAAAA)
      {
        counterW++;
      }
      if (c<0xFF202020)
      {
        counterB++;
      }
    }
  }
  ;
  if (((float)counterB/(float)(h * w))>=0.8)
  {
    drawDarkRoom();
    ghostFlag=true;
  } else
  {
    drawBrightRoom();
  }
} 

//カメラの映像が更新されるたびに、最新の映像を読み込む
void captureEvent(Capture camera) {
  camera.read();
}

int alpha=0;

void drawBrightRoom()
{
  if (ghostFlag)
  {
    image(room2, 0, 0);
  } else
  {
    image(room, 0, 0);
    image(futon, 0, sin(frameCount*0.1)*3.);
    fill(255);
    ellipse(width/2+30, 995+sin(frameCount*0.08)*2, 3, 2);
    ellipse(width/2+50, 990+sin(frameCount*0.08)*2, 3, 2);
  }
}

void drawDarkRoom()
{
  fill(0);
  rect(0, 0, 1920, 1080);
}
