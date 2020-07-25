#include <Arduino.h>
#include <Servo.h>

Servo myservoM;
Servo myservoY;
Servo myservoX;

float posM = 0;
float posY = 0;
float posX = 0;

void setServos()
{
  //Serial.println("setServos: " + String(posM) + "|" + String(posX) + "|" + String(posY));
  myservoM.write(posM);
  myservoX.write(posX);
  myservoY.write(map(posY, 0, 180, 180, 0));
}

void shake(int times)
{
  Serial.println("SHAKE");

  int d1 = 80;
  int i;
  for (i = 0; i <= times; i += 1)
  {

    posM = posM - 5;
    posX = posX - 3;
    posY = posY - 5;
    setServos();
    delay(d1);
    posM = posM + 5;
    posX = posX + 3;
    posY = posY + 5;
    setServos();
    delay(d1);
  }
}

void Move(int m, int x, int y, int _speed)
{
  int mDistance = abs(posM - m);
  int xDistance = abs(posX - x);
  int yDistance = abs(posY - y);
  Serial.println("mDistance: " + String(mDistance));
  Serial.println("xDistance: " + String(xDistance));
  Serial.println("yDistance: " + String(yDistance));

  float biggestDistance;

  if (mDistance > xDistance)
  {
    if (mDistance > yDistance)
    {
      biggestDistance = mDistance;
    }
    else
    {
      biggestDistance = yDistance;
    }
  }
  else
  {
    if (xDistance > yDistance)
    {
      biggestDistance = xDistance;
    }
    else
    {
      biggestDistance = yDistance;
    }
  }
  Serial.println("biggestDistance: " + String(biggestDistance));

  bool mDirection;
  if (m > posM)
  {
    mDirection = true;
  }
  else
  {
    mDirection = false;
  };

  bool xDirection;
  if (x > posX)
  {
    xDirection = true;
  }
  else
  {
    xDirection = false;
  };

  bool yDirection;
  if (y > posY)
  {
    yDirection = true;
  }
  else
  {
    yDirection = false;
  };

  float mAlfa = mDistance / biggestDistance;
  float xAlfa = xDistance / biggestDistance;
  float yAlfa = yDistance / biggestDistance;

  Serial.println("mAlfa: " + String(mAlfa));
  Serial.println("xAlfa: " + String(xAlfa));
  Serial.println("yAlfa: " + String(yAlfa));

  int i;
  for (i = 0; i < biggestDistance; i += 1)
  {

    if (mDirection)
    {
      posM += mAlfa;
    }
    else
    {
      posM -= mAlfa;
    }

    if (xDirection)
    {
      posX += xAlfa;
    }
    else
    {
      posX -= xAlfa;
    }

    if (yDirection)
    {
      posY += yAlfa;
    }
    else
    {
      posY -= yAlfa;
    }

    setServos();
    delay(_speed);
  }
}

void Touch(int _m, int xUp, int xDown, int yUp, int yDown)
{
  Move(_m, xUp, yUp, 10);
  delay(100);

  Move(_m, xDown, yDown, 5);
  delay(1);
  Move(_m, xUp, yUp, 5);
  delay(50);
}

void TouchSlow(int _m, int xUp, int xDown, int yUp, int yDown)
{
  Move(_m, xUp, yUp, 10);
  delay(500);

  Move(_m, xDown, yDown, 10);
  delay(10);
  Move(_m, xUp, yUp, 10);
  delay(500);
}

///////////////////////////////////////////////////////////////////
///////////////////////     SETUP    //////////////////////////////
///////////////////////////////////////////////////////////////////
void setup()
{
  Serial.begin(9600);
  myservoM.attach(8);
  myservoY.attach(9);
  myservoX.attach(10);

  ////////////////  RESET  ///////////////////
  posM = 90;
  posX = 50;
  posY = 80;
  setServos();
  delay(1000);
  ////////////////  RESET  ///////////////////

  shake(2);

  /////////START APP
  Touch(83, 76, 84, 63, 84); // START ICON
  delay(5);
  Move(90, 50, 80, 20); //START POSITION
  delay(10000);

  //////////LOGIN
  Touch(101, 76, 81, 63, 82); // 2
  Touch(101, 66, 79, 66, 90); // 3
  Touch(101, 76, 81, 63, 82); // 2
  Touch(101, 66, 79, 66, 90); // 3
  delay(3000);

  //////////TYPE TEL NUMBER
  Touch(96, 84, 95, 57, 86);  // 4
  Touch(88, 76, 81, 63, 82);  // 8
  Touch(94, 66, 79, 66, 88);  // 6
  Touch(101, 66, 79, 66, 90); // 3
  Touch(90, 84, 94, 57, 81);  // 7
  Touch(94, 66, 79, 66, 88);  // 6
  Touch(97, 78, 82, 63, 85);  // 5
  Touch(90, 84, 94, 57, 81);  // 7
  Touch(82, 66, 81, 66, 88);  // OK
  delay(4000);
  TouchSlow(96, 74, 81, 68, 88);  // OKPUPUP
  Move(90, 50, 80, 20); //START POSITION
  
  delay(10000);

  ////////////////////// SCANER ////////////////////////////
  delay(500);
  Move(120, 70, 110, 30);
  delay(500);
  Move(110, 130, 80, 22); //TOUCH SCANNER BUTTON
  delay(500);
  Move(130, 100, 100, 30);
  delay(500);

  Move(90, 40, 90, 20);//START POSITION

  delay(4000);

  TouchSlow(82, 66, 79, 66, 88);  // OK
  delay(5000);
  TouchSlow(82, 66, 79, 66, 88);  // OK


  ////////////////  RESET  ///////////////////
  delay(1000);
  Move(90, 50, 80, 20); //START POSITION
}

///////////////////////////////////////////////////////////////////
///////////////////////     LOOP     //////////////////////////////
///////////////////////////////////////////////////////////////////
void loop()
{
}
