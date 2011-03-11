int boxsize=40;
int funnelrows=8;
int spacing=80;
int sides=8;
float a;
PImage eye, stars, pupil, pupil2;
int[] pupilorigpixels;


void setup()
{
  size(580, 400, P3D);
  noStroke();
  pupil = loadImage("pupil.png");
  pupil2 = loadImage("pupil.png");
  
  eye = loadImage("eye.png");
  pupil.loadPixels();
  pupilorigpixels = pupil.pixels;
  stars = loadImage("stars.jpg");
    textureMode(NORMALIZED);
fill(255);
//smooth();

  
}

void draw()
{
  background(0);

  blend(stars, 0, 0, width, height, 0, 0, width, height, BLEND);

  translate(0,0, -400);
  translate(width/2, height/2, 0);
 
  drawFunnel();
}


void drawFunnel()
{
  pushMatrix();
  for (int i=0; i<funnelrows; i++)
  {
    
    translate(0, 0, spacing);
    

//pushMatrix();

   rotate(PI/20);   
   drawRing();
//popMatrix();
  }
  popMatrix();
}

void drawRing()
{
  pushMatrix();
  for (int i=0; i<sides; i++)
  {
  pushMatrix();
    rotate(PI/(sides/2)*i+a);
    translate(spacing, 0, 0);
    drawBox();
  popMatrix();
  }
  popMatrix();
}

void drawBox()
{
  
        a += 0.0001;
  if(a > TWO_PI) { 
    a = 0.0; 
  }

  
  pushMatrix();
  rotateY(frameCount * 0.05);
  rotateZ(frameCount * 0.05);
  
  //box(boxsize);


  pupil.pixels = pupilorigpixels;
  pupil.updatePixels();
  
  float b = atan2(mouseY-height/2, mouseX-height/2);
  
  int x = floor(cos(b)*3);
  int y = floor(sin(b)*2);
  
  pupil.copy(pupil2, 0, 0, 40, 40, x, y, x+40, y+40);
  
  pupil.blend(eye, 0, 0, 40, 40, 0, 0, 40, 40, BLEND);

pushMatrix();
  
  scale(18);
  
  
TexturedCube(pupil);
popMatrix();
  
  popMatrix();
}

void TexturedCube(PImage tex) {
  beginShape(QUADS);
  texture(tex);

  // Given one texture and six faces, we can easily set up the uv coordinates
  // such that four of the faces tile "perfectly" along either u or v, but the other
  // two faces cannot be so aligned.  This code tiles "along" u, "around" the X/Z faces
  // and fudges the Y faces - the Y faces are arbitrarily aligned such that a
  // rotation along the X axis will put the "top" of either texture at the "top"
  // of the screen, but is not otherwised aligned with the X/Z faces. (This
  // just affects what type of symmetry is required if you need seamless
  // tiling all the way around the cube)
  
  // +Z "front" face
  vertex(-1, -1,  1, 0, 0);
  vertex( 1, -1,  1, 1, 0);
  vertex( 1,  1,  1, 1, 1);
  vertex(-1,  1,  1, 0, 1);

  // -Z "back" face
  vertex( 1, -1, -1, 0, 0);
  vertex(-1, -1, -1, 1, 0);
  vertex(-1,  1, -1, 1, 1);
  vertex( 1,  1, -1, 0, 1);

  // +Y "bottom" face
  vertex(-1,  1,  1, 0, 0);
  vertex( 1,  1,  1, 1, 0);
  vertex( 1,  1, -1, 1, 1);
  vertex(-1,  1, -1, 0, 1);

  // -Y "top" face
  vertex(-1, -1, -1, 0, 0);
  vertex( 1, -1, -1, 1, 0);
  vertex( 1, -1,  1, 1, 1);
  vertex(-1, -1,  1, 0, 1);

  // +X "right" face
  vertex( 1, -1,  1, 0, 0);
  vertex( 1, -1, -1, 1, 0);
  vertex( 1,  1, -1, 1, 1);
  vertex( 1,  1,  1, 0, 1);

  // -X "left" face
  vertex(-1, -1, -1, 0, 0);
  vertex(-1, -1,  1, 1, 0);
  vertex(-1,  1,  1, 1, 1);
  vertex(-1,  1, -1, 0, 1);

  endShape();
}


