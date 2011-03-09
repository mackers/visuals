int boxsize=40;
int funnelrows=25;
int spacing=80;
int sides=8;

void setup()
{
  size(580, 400, P3D);
}

void draw()
{
  background(0);

  translate(width/2, height/2, 300);
  translate(boxsize/2+20, -boxsize/2-100, 0);

  drawFunnel();
}

void drawFunnel()
{
  pushMatrix();
  for (int i=0; i<funnelrows; i++)
  {
    translate(0, 0, -spacing);
    drawRing();
  }
  popMatrix();
}

void drawRing()
{
  pushMatrix();
  for (int i=0; i<sides; i++)
  {
    rotate(PI/(sides/2));
    translate(spacing, 0, 0);
    drawBox();
  }
  popMatrix();
}

void drawBox()
{
  pushMatrix();
  rotateY(frameCount * 0.01);
  rotateZ(frameCount * 0.01);
  box(boxsize);
  popMatrix();
}
