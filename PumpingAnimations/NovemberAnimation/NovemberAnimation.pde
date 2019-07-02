PImage November; 
String filename = "November2016CSV.csv";
String [] rawData;
ArrayList <Day> allDays = new ArrayList <Day>();
int factor = 5;
int radius=1440/factor;// 1440 minutes in a day
int numDays;
int nextDay; 
float i = -90.0; //need all this in the enviroment to make sure it keeps looping
int count = 1;

void setup()
{
  size(700, 700); 
  processData();
  numDays = 30;
  background(255);
  November = loadImage("November2016.png"); 
  imageMode(CENTER);
  image(November, 350, 350, 580, 580);
  nextDay = 0; 
  frameRate(4); //speeds up/slows down the animation
}

void draw()
{   
  if (nextDay == 21 || nextDay == 23)
  {
    //nextDay++; 
    i+=360.0/numDays;
  }
  
  if (nextDay == allDays.size()) //restarts everything to the beginning
  {
    nextDay = 0;
    background(255);  
    imageMode(CENTER);
    image(November, 350, 350, 580, 580); //creates a new background to start over
    i = -90.0; 
    count = 1;
  }
  PVector center = new PVector(width/2, height/2);
  strokeWeight(0.2);

  float x = center.x + cos(radians(i))*radius; //exterior coordinates for the lines
  float y = center.y + sin(radians(i))*radius;
  stroke(240);
  //line(center.x, center.y, x, y); 

  for (int j = 0; j<9; j++)
  {
    if ((allDays.get(nextDay).getAmount(j) !=0))//&&((count==allDays.get(nextDay).day)))
    {
      pushMatrix();
      float xNew = x -((radius - (allDays.get(nextDay).getStartVal(j)/factor))*(x-center.x)/radius); //coordinates of yellow circles
      float yNew = y -((radius - (allDays.get(nextDay).getStartVal(j)/factor))*(y-center.y)/radius);
      colorMode(RGB, 255, 255, 255, 100);
      fill(255, 195, 93);
      noStroke();
      ellipse (xNew, yNew, allDays.get(nextDay).getAmount(j)*3, allDays.get(nextDay).getAmount(j)*3);
      popMatrix();
    }
  }
  nextDay++;
  count++;
  i+=360.0/numDays;
}



void processData()
{
  rawData = loadStrings(filename);
  int p=1;
  int count=0;

  for (int i=1; i<rawData.length; i++)
  {
    String[] thisRow = split(rawData[i], ','); 

    if (i==rawData.length-1) //last day of the data
    {
      count++;
      for (int m=i-count; m<i; m+=count) //skips by days
      {
        Day d = new Day ();
        String[] firstRow = split (rawData[i], ',');
        d.day =int(firstRow[5]);

        for (int j=0; j<count; j++)//all values for one day
        {
          String [] thatRow = split(rawData [m+j], ',');
          d.amount[j] = float (thatRow[4]);
          d.startVal[j] = int(thatRow[2]);
        }
        allDays.add(d);
      }
    }
    if (int(thisRow[5])==p)
    {
      count++;
    } else
    {      
      for (int m=i-count; m<i; m+=count) //skips by days
      {
        Day d = new Day ();
        String[] firstRow = split (rawData[i], ',');
        d.day = p; //int(firstRow[5])-1;

        for (int j=0; j<count; j++)//all values for one day
        {
          String [] thatRow = split(rawData [m+j], ',');
          d.amount[j] = float (thatRow[4]);
          d.startVal[j] = int(thatRow[2]);
        }
        allDays.add(d);
        p=int(firstRow[5]);
      }
      count=1;
    }
  }
}
