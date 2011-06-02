import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;
AudioPlayer jingle;
FFT fft;


int fishc;
int[] fish = new int[10];
int[] fseq = {2,3,5,8,13,21};
int xrand = 20;
int yrand = 20;
boolean stop = false , gentle = true, bang = false;
int comms = 0;
boolean commtogg=false;

  int step = 40;

int horizon;
int counter;

void setup( )
{
  size(640, 480);
  smooth();
  // don't show where control points are
  //stroke(20);
  stroke(0, 255, 0);
  
  minim = new Minim(this);
  
  jingle = minim.loadFile("4.mp3", 2048);
  jingle.play();
  // create an FFT object that has a time-domain buffer the same size as jingle's sample buffer
  // note that this needs to be a power of two and that it means the size of the spectrum
  // will be 512. see the online tutorial for more info.
  fft = new FFT(jingle.bufferSize(), jingle.sampleRate());
  fft.window(FFT.HAMMING);

horizon = height*2/3;
  
  background(0);
}

void draw()
{
  fadeLandscape();
  drawLandscape();
  drawFish();
  counter++;
}
  
void fadeLandscape()
{
  //background(255);
  
  // take pixels, shift up by 10px, blur
  
  loadPixels();
  
  PImage edgeImg = createImage(width, height, RGB);

  float v = 1.0/9.0;
float[][] kernel = { { v, v, v },
                     { v, v, v },
                     { v, v, v } };

  

  
  for (int y = 1; y < height-1; y++) { // Skip top and bottom edges
  for (int x = 1; x < width-1; x++) { // Skip left and right edges
    float sum = 0; // Kernel sum for this pixel
    for (int ky = -1; ky <= 1; ky++) {
      for (int kx = -1; kx <= 1; kx++) {
        // Calculate the adjacent pixel for this kernel point
        int pos = (y + ky)*width + (x + kx);
        // Image is grayscale, red/green/blue are identical
        float val = green(pixels[pos]);
        // Multiply adjacent pixels based on the kernel values
        sum += kernel[ky+1][kx+1] * val;
      }
    }
    // For this pixel in the new image, set the gray value
    // based on the sum from the kernel
    edgeImg.pixels[y*width + x] = color(0, sum, 0);
    
    if (y>450)
      edgeImg.pixels[y*width + x] = color(0, 0, 0);
    
  }
}

edgeImg.updatePixels();

//background(255);

    for (int i=0; i<pixels.length; i++)
  {
    if (i < pixels.length - (width*10))
      pixels[i] = edgeImg.pixels[i+(width*10)];
    else
      pixels[i] = color(0, 0, 0);
  }
  
  updatePixels();
}

void drawLandscape()
{
  fft.forward(jingle.mix);

  
  beginShape();
  
  int lastx=0;
  float c1x, c1y, c2x, c2y, p2x, p2y;
  p2x=0;
  p2y=horizon;
  c2x=0; c2y=0;
  
  
  vertex(p2x, p2y); // first point
  
  int specsize = fft.specSize();


  for (int i=0; i<specsize; i+=step)
  {
    
    float band = fft.getBand(i) * 20;
   
   if (stop)
   band = 0;
   
   if (gentle)
   band = band / 10;
    
    if (bang)
    band += i*random(0,0.2);

    //float segw=random(30,80);
    float segw=width/(specsize/step);
    
    if (i==specsize-1 && p2x<width)
      segw = width-p2x;
    
    if (c2x==0)
    {
      c1x = p2x-band;
     c1y = p2y+band;
    }
    else
    {
      c1x = p2x + p2x - c2x;
      c1y = p2y + p2y - c2y;
    }
    
    if (i%2==0)
      c2x = p2x-band+segw;
    else
      c2x = p2x+band+segw;
    
     c2y = p2y+band;
     
     p2x = p2x+segw;
    
    
    /*fill(255, 0, 0);
    ellipse(c1x, c1y, 5, 5);

    fill(0, 0, 255);
    ellipse(c2x, c2y, 5, 5);
    */
    //fill(0,0,255);
    //ellipse(p2x, p2y, 5, 5);
    
    
    //noFill();
    fill(0,255,0);
    
          stroke(0, 255, 0);
    bezierVertex(c1x, c1y, c2x, c2y, p2x, p2y);
   
  }
  
  
 
  
  endShape();
}

void drawFish()
{
     for (int j=0; j<fish.length; j++)
    {
      if (fish[j] == 1)
      {
        fill(0, 255, 0);
        ellipse(width+step - (step*fseq[j]), horizon, 5, 5);
        
        if (comms>j)
        {
          noFill();
          
          for (int k=0;k<5; k++)
          {
            stroke(0, 255, 0, 255-(fseq[k]*30));
            //float x = random(20, 20+20*k);
            float x = 20 * sin(counter);
            
            
            ellipse(width+step - (step*fseq[j]), horizon, x*fseq[k], x*fseq[k]);
          }
        }
      }
    }
}

void stop()
{
  // always close Minim audio classes when you finish with them
  jingle.close();
  minim.stop();
  
  super.stop();
}

void keyReleased()
{
  if ( key == 's' ) 
  {
    
    stop = !stop;
  }
  else if (key == 'f')
  {
    if (fishc<fish.length)
    {
      fish[fishc++] = 1;
    }
  }
  else if (key == 'g')
  {
    gentle = !gentle;
  }
  else if (key == 'b')
  {
    bang = !bang;
    
  
      fish = new int[10];
      fishc=0; 
  }
  else if (key == 'c')
  {
    comms++;
  }
}

