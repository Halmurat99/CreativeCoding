import controlP5.*;

ControlP5 cp5;

int ParticleNum=1000;

PImage img;
int uiWidth=150;

float rowSpacing=5;
float columnSpacing=5;
float cubeSize=5;
float cornerRadius=5;

float level=10;

float xSpeed=1;
float ySpeed=1;

int effect=-1;

void setup() {
  size(1000, 800);  
  cp5 = new ControlP5(this);
  ButtonBar b = cp5.addButtonBar("bar")
    .setPosition(20, 360)
    .setSize(int(uiWidth*0.7), 30)
    .addItems(split("1 2 3", " "))
    ;
  //设置按钮条 用于选择使用哪个效果
 
  b.onPress(new CallbackListener() {
    public void controlEvent(CallbackEvent ev) {
      ButtonBar bar = (ButtonBar)ev.getController();
      effect= bar.hover();//按钮条按下使effect的值根据按下哪个按钮变化
    }
  }
  );

  cp5.addSlider("rowSpacing")
    .setPosition(20, 40)
    .setSize(int(uiWidth*0.7), 20)
    .setRange(5, 50)
    ;  

  cp5.addSlider("columnSpacing")
    .setPosition(20, 80)  
    .setSize(int(uiWidth*0.7), 20)
    .setRange(5, 50)
    ;  
  
  cp5.addSlider("cubeSize")
    .setPosition(20, 120)
    .setSize(int(uiWidth*0.7), 20)
    .setRange(5, 50)
    ; 
 
  cp5.addSlider("cornerRadius")
    .setPosition(20, 160)
    .setSize(int(uiWidth*0.7), 20)
    .setRange(0, 1)
    ; 
  
  cp5.addSlider("xSpeed")
    .setPosition(20, 200)
    .setSize(int(uiWidth*0.7), 20)
    .setRange(0, 1)
    ; 
 
  cp5.addSlider("ySpeed")
    .setPosition(20, 240)  
    .setSize(int(uiWidth*0.7), 20)
    .setRange(0, 1)
    ; 
  
  cp5.addSlider("ParticleNum")
    .setPosition(20, 280)  
    .setSize(int(uiWidth*0.7), 20)
    .setRange(0, 1000)
    ;
  
  cp5.addSlider("level")
    .setPosition(20, 320) 
    .setSize(int(uiWidth*0.7), 20)
    .setRange(0, 255)
    ;

  img=loadImage("img.jpg");
  
  if (img.width>img.height) {
    img.resize(width-uiWidth, 0);
  } else {    
    img.resize(0, height);
  }
  //判断图片是竖向还是横向 将图片拉伸至合适的大小

  imageMode(CENTER);
  rectMode(CENTER);
  background(0);
 
  for (int i=0; i<1000; i++) {
    particles[i]=new Particle();
  }
  //实例化数组
}

void draw() {
  if (effect==0) {
    effect0();
  } else if (effect==1) {
    effect1();
  }  
  if (effect==2) {
    effect2() ;
  }
  //根据不同的effect值调用不同的效果

  fill(0);
  rect(uiWidth/2, height/2, uiWidth, height);

}


void effect0() {
  //效果0
  background(0); 
  for (int x=0; x<img.width; x+=columnSpacing) {
    for (int y=0; y<img.height; y+=rowSpacing) {
      //使用二维数组绘制铺满的方块
      noStroke();
      fill(img.get(x, y));
      //从图片获取颜色信息
      rect(x+width/2+uiWidth/2-img.width/2+cubeSize/2, y+height/2-img.height/2+cubeSize/2, cubeSize, cubeSize, cornerRadius*cubeSize);
      //绘制方块
    }
  }
}


Particle particles[]=new Particle[ParticleNum];
//创建粒子数组
class Particle {
  float x, y;
  float vx, vy;
  color c;

  Particle() {
    x=random(img.width);
    y=random(img.height);
    //随机化粒子的位置
    vx=random(1, 5);
    vy=random(1, 5);
    //随机化粒子的速度
  }
  
  void moveEffect1() {
    //效果1
    y+=vy*ySpeed;
    //使粒子在y轴上运动
    noStroke();
    c=img.get(int(x), int(y));
    fill(c);
    //使粒子根据自己的位置获取图片颜色作为自己的填充色
    rect(x+width/2+uiWidth/2-img.width/2+cubeSize/2, y+height/2-img.height/2+cubeSize/2, cubeSize, cubeSize, cornerRadius*cubeSize);
    //绘制
    if (x>img.width)x=0;  
    if (y>img.height)y=0;  
    if (x<0)x=img.width;  
    if (y<0)y=img.height;
    //判定粒子是否触碰屏幕边缘 如果是 使其从另一边出现
  } 
  
  void moveEffect2() {
    //效果2
    x+=vx*xSpeed;
    y+=vy*ySpeed;
    //使粒子在x y轴上都运动
    noStroke();
    c=img.get(int(x), int(y));
    fill(c);

    rect(x+width/2+uiWidth/2-img.width/2+cubeSize/2, y+height/2-img.height/2+cubeSize/2, cubeSize, cubeSize, cornerRadius*cubeSize);
    //绘制
    if (x>img.width) {
      x=img.width; 
      vx*=-1;
    }
    if (y>img.height) {
      y=img.height;   
      vy*=-1;
    }
    if (x<0) { 
      x=0; 
      vx*=-1;
    }
    if (y<0) {
      y=0;   
      vy*=-1;
    }
    //判定粒子是否触碰屏幕边缘 如果是 使其速度反向
  }
}


void effect1() {
  //效果1
  fill(0, level);
  rect(width/2, height/2, width, height);
  for (int i=0; i<ParticleNum; i++) {
    particles[i].moveEffect1();
  }
}
void effect2() {
  //效果2
  fill(0, level);
  rect(width/2, height/2, width, height);
  for (int i=0; i<ParticleNum; i++) {
    particles[i].moveEffect2();
  }
}

void keyPressed(){
   if (key == 's' || key == 'S'){
    saveFrame("image###.png");
  }     
}
