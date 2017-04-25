import processing.pdf.*;

int PIXELES = 3;
// int PIXELES = 1; //variable entrega 1, toma 1 pixel de la imagen 

ArrayList cortes;
float[] ruido;

PImage image_1;
PImage fondo;

float tiempo = 0.1;
float pausaderretimiento = 2;

class Slice {
  float x;
  float y;
  float vel;
  PImage img;

  Slice(int x, float y, PImage img) 
  { this.x = x;
    this.y = y;
    this.img = img;}

  void setVelocity(float v) 
  {this.vel = v;}

  float getVelocity() 
  {return this.vel;}

  void draw() 
  {tint(255, y+40); 
   image(img, x+100, y+25);}

  void update(float delta) {
    if (y < height) {
      y += vel * delta;
    }}}

void createcortes(PImage im) {
  cortes = new ArrayList();
  for (int x = 0; x < im.width; x += PIXELES) {
    PImage ImgSlice = im.get(x, 0, PIXELES, height);
    Slice s = new Slice(x, 0, ImgSlice);
    s.setVelocity( ruido[x/PIXELES] /5.0f);
    cortes.add(s);
  }}

void setup() {

  size(1275, 2267);
  background(#cddfe1);
frameRate(4);
beginRecord(PDF, "Magri3.pdf");
  cortes = new ArrayList(); 

  image_1=loadImage("img2.png");
  fondo=loadImage("img1.png");

  ruido = new float[width];

  for (int i = 0; i < width; i=i+2) {
    ruido[i] = noise(i/10.0f);
  }}

float getDelta() {
  float temp = millis() - tiempo;
  tiempo = millis()+10;
  return temp;}

void draw() {
  image(fondo, 100, 25);
  float delta = getDelta();
  pausaderretimiento += delta;
  if (pausaderretimiento >= 2000) {
    for (int i = 0; i < width; i++) {
      ruido[i]  = noise((i+frameCount)/100.0f);
  }
 pausaderretimiento = 0;
 createcortes(image_1);
  }
// imagen derretida:
  for (int i = 0; i < cortes.size(); i++) {
    Slice s = (Slice)cortes.get(i);
    s.update(delta);
    s.draw();
  }}

void keyPressed() {
  if (key == 'q') {
    endRecord();
    exit();
  }}