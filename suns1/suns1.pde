class Sun {
  int radius=51, growinc=1;
  float x, y, xmove, ymove;
  int speed=4;
  
  Sun (float x1, float y1, float xm1, float ym1) {
    x=x1;y=y1;
    xmove=xm1*speed;ymove=ym1*speed;
  }
  
  void grow() { 
    radius+=growinc;
    
    if (radius<20)
    {
      growinc=1;
    }
    
    if (radius>100)
    {
      growinc=-1;
    }
  }
  
  void move() {
    for (int i=0; i<suns.length; i++)
    {
      if (suns[i] == this)
        continue;
      
      if (sqrt(pow(suns[i].x-x,2)+pow(suns[i].y-y,2)) < radius)
      {
        xmove=(x<suns[i].x?0-abs(xmove):0+abs(xmove));
      }
      
      if (y==suns[i].y)
        y+=ymove;
    }
    
    x += xmove;
    y += ymove;
    
    if (x<(radius/2))
    {
      x=radius/2;
      xmove=-xmove;
      return;
    }
    
    if (x>width-(radius/2))
    {
      x=width-radius/2;
      xmove=-xmove;
      return;
    }
    
    if (y<(radius/2))
    {
      y=radius/2;
      ymove=-ymove;  
      return;
    }
    
    if (y>height-(radius/2))
    {
      y=height-radius/2;
      ymove=-ymove;
      return;
    }
    

  }

}

Sun[] suns = {new Sun(200,23,1,2), new Sun(400,320,2,1)};
int counter=0;

void setup( )
{
  size(640, 480);
  background(0);
  smooth();
  // don't show where control points are
  noFill();
  stroke(128);
  
  
}

void draw()
{
  counter++;

  movesuns();
  blur();
  //background(0);
  drawblues();
  drawblues();
  drawblues();
  drawsuns();
}

void movesuns()
{
  for (int i=0; i<suns.length; i++)
  {
    suns[i].move();
    suns[i].grow();
  }
}

void drawblues()
{
  float[] p1 = {suns[0].x, suns[0].y};
  float[] p2 = {suns[1].x, suns[1].y};
  

  float[] mp = {p1[0]+(p2[0]-p1[0])/2, p1[1]+(p2[1]-p1[1])/2};
  
  float slope = (p2[1]-p1[1])/(p2[0]-p1[0]);
   float pslope = -1/slope;
   
   int randval=100;
  
  float[] cp1 = {random(p1[0]-randval, p1[0]+randval), random(p1[1]-randval, p1[1]+randval)};
  
  float x1 = mp[0]+(p1[0]<p2[0]?50:-50);
  float[] cp2 = {x1, -1*pslope*(mp[0]-x1)+mp[1]};
 
  x1 = mp[0]+(p1[0]<p2[0]?-50:50);
  float[] cp3 = {x1, -1*pslope*(mp[0]-x1)+mp[1]};

  float[] cp4 = {random(p2[0]-randval, p2[0]+randval), random(p2[1]-randval, p2[1]+randval)};
    
  /*
  println("slope= " + slope +" , pslope = " + pslope);
  println("cp1 = " + cp1[0]+","+cp1[1]);
  println("cp2 = " + cp2[0]+","+cp2[1]);
  println("cp3 = " + cp3[0]+","+cp3[1]);
  println("cp4 = " + cp4[0]+","+cp4[1]);
  ellipse(cp2[0], cp2[1], 3, 3);
  ellipse(cp3[0], cp3[1], 3, 3);
  ellipse(mp[0], mp[1], 3, 3);
  */
  
  stroke(0, 0, 255, 200);
  strokeWeight(5);
  noFill();
  
  beginShape();

  vertex(p1[0], p1[1]); // first point
  bezierVertex(cp1[0], cp1[1], cp2[0], cp2[1], mp[0], mp[1]);
  bezierVertex(cp3[0], cp3[1], cp4[0], cp4[1], p2[0], p2[1]);
  
  endShape();
}
   
void drawsuns()  
{
  fill(237, 17, 164, 255);
  //noStroke();
  ellipse(suns[0].x, suns[0].y, suns[0].radius, suns[0].radius);
  ellipse(suns[1].x, suns[1].y, suns[1].radius, suns[1].radius);
   
}



void blur()
{
  float v = 1.0/9.0;
float[][] kernel = { { v, v, v },
                     { v, v, v },
                     { v, v, v } };

loadPixels();

// Create an opaque image of the same size as the original
PImage edgeImg = createImage(width, height, RGB);

// Loop through every pixel in the image.
for (int y = 1; y < height-1; y++) { // Skip top and bottom edges
  for (int x = 1; x < width-1; x++) { // Skip left and right edges
    float sum = 0; // Kernel sum for this pixel
    for (int ky = -1; ky <= 1; ky++) {
      for (int kx = -1; kx <= 1; kx++) {
        // Calculate the adjacent pixel for this kernel point
        int pos = (y + ky)*width + (x + kx);
        // Image is grayscale, red/green/blue are identical
        float val = blue(pixels[pos]);
        // Multiply adjacent pixels based on the kernel values
        sum += kernel[ky+1][kx+1] * val;
      }
    }
    // For this pixel in the new image, set the gray value
    // based on the sum from the kernel
    edgeImg.pixels[y*width + x] = color(0,0,sum/2,64);
  }
}
// State that there are changes to edgeImg.pixels[]
edgeImg.updatePixels();

    for (int i=0; i<pixels.length; i++)
  {
    pixels[i] = edgeImg.pixels[i];
  }
  
  updatePixels();
}


