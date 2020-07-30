// #include <UTFT.h>
// #include <Fonts/FreeMono9pt7b.h>
#include "SPI.h"
#include "dishplaySetUp.h"
#include "TFT_eSPI.h"
// #include "bitPicture.h"
#include "strings.h"
#include <animationGIF.h>
#include "Wire.h"
enum Board_State
{
  MSG_NOTIFICATION,
  CALL_NOTIFICATION,
  DECTION_NOTIFICATION
} Board_State;

TFT_eSPI tft = TFT_eSPI();

// #include <Fonts/miror20pt7bBitmaps.h>
#include <Fonts/miror10pt7b.h>

void displaysetup()
{
	tft.init();
	tft.begin();
	tft.setRotation(1);
	tft.fillScreen(TFT_BLACK);
}
String wrap(String s, int limit)
{
	int space = 0;
	int i = 0;
	int line = 0;
	while (i < s.length())
	{
		if (s.substring(i, i + 1) == " ")
		{
			space = i;
		}
		if (line > limit - 1)
		{
			s = s.substring(0, space) + "~" + s.substring(space + 1);
			line = 0;
		}
		i++;
		line++;
	}
	s.replace("~", "\n");
	return s;
}

void cleanDisplay(){
	tft.fillScreen(TFT_BLACK);
}


void showAmimation_MSG_NOTIFICATION()
{
	int xx = 0;
	int yy = 0;
	int tt = 100;
	for (int c = 0; c <= 1; c++)
	{
		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Letter0, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Letter1, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Letter2, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Letter3, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Letter4, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Letter5, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Letter6, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Letter7, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Letter8, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Letter9, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Letter10, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Letter11, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Letter12, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Letter13, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Letter14, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Letter15, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Letter16, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Letter17, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Letter18, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Letter19, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Letter20, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Letter21, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Letter22, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Letter23, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Letter24, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Letter25, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Letter26, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Letter27, 48, 48, 1);

		delay(tt);
	}
}

void showAmimation_CALL_NOTIFICATION()
{
	int xx = 0;
	int yy = 0;
	int tt = 100;
	tft.setCursor(7, 35);

	for (int e = 1; e < 3; e++)
	{
		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Phone0, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Phone1, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Phone2, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Phone3, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Phone4, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Phone5, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Phone6, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Phone7, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Phone8, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Phone9, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Phone10, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Phone11, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Phone12, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Phone13, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Phone14, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Phone15, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Phone16, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Phone17, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Phone18, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Phone19, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Phone20, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Phone21, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Phone22, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Phone23, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Phone24, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Phone25, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Phone26, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Phone27, 48, 48, 1);

		delay(tt);
	}

}

void showAmimation_DECTION_NOTIFICATION(){
	int xx = 0;
	int yy = 0;
	int tt = 60;
	tft.setCursor(7, 35);
	for (int c = 1; c < 3; c++)
	{
		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Connect0, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Connect1, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Connect2, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Connect3, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Connect4, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Connect5, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Connect6, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Connect7, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Connect8, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Connect9, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Connect10, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Connect11, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Connect12, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Connect13, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Connect14, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Connect15, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Connect16, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Connect17, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Connect18, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Connect19, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Connect20, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Connect21, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Connect22, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Connect23, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Connect24, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Connect25, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Connect26, 48, 48, 1);

		delay(tt);

		tft.fillScreen(TFT_WHITE);
		tft.drawBitmap(xx, yy, Connect27, 48, 48, 1);

		delay(tt);
	}
}

void showDisplay(String message)
{
	showAmimation_DECTION_NOTIFICATION();
	tft.setCursor(7, 35);


	tft.fillScreen(TFT_RED);

	tft.drawRoundRect(2, 2, 80, 80, 10, TFT_SILVER);

	tft.fillRect(2, 0, 80, 80, TFT_BLACK);
	tft.setTextWrap(false, true);

	tft.setFreeFont(&miror10pt7b);
	tft.setTextSize(0);
	tft.setCursor(7, 30);

	int start = 0;
	int end = message.length();

	char revesttext[end];

	for (int i = end - 1; i > -1; i--)
	{
		Serial.println(message.charAt(i));
		revesttext[start] = message.charAt(i);
		Serial.println(revesttext[start]);
		start += 1;
	}
	Serial.println((char *)revesttext);
	revesttext[end] = '\0'; // ARHHHHH !!! THE BUGGG IS FOUND

	Serial.println((char *)revesttext);
	tft.setTextColor(TFT_WHITE);

	String myString = String(revesttext);
	tft.setCursor(10, 20);
	tft.println(wrap(myString, 5));

	delay(5000);
	// tft.fillScreen(TFT_RED);
	cleanDisplay();

}
void showMessenge(String message, int opCode)
{
	if (opCode == MSG_NOTIFICATION)
	{
		showAmimation_MSG_NOTIFICATION();
	}else if(opCode == CALL_NOTIFICATION )
	{
		showAmimation_CALL_NOTIFICATION();
	}
	tft.fillScreen(TFT_BLUE);
	tft.drawRoundRect(2, 2, 80, 80, 10, TFT_VIOLET);

	tft.fillRect(2, 0, 80, 80, TFT_WHITE);
	tft.setTextWrap(false, true);

	tft.setFreeFont(&miror10pt7b);
	tft.setTextSize(0);
	tft.setCursor(7, 30);

	int start = 0;
	int end = message.length();

	char revesttext[end];

	for (int i = end - 1; i > -1; i--)
	{
		Serial.println(message.charAt(i));
		revesttext[start] = message.charAt(i);
		Serial.println(revesttext[start]);
		start += 1;
	}
	Serial.println((char *)revesttext);
	revesttext[end] = '\0'; // ARHHHHH !!! THE BUGGG IS FOUND

	Serial.println((char *)revesttext);
	tft.setTextColor(TFT_BLACK);
	//tft.println(revesttext);
	tft.setTextWrap(true);
	int x = tft.width() / 32;
	int minX = -7 * strlen(revesttext);
	for (int d = 50; d > 0; d--)
	{

		tft.setTextColor(TFT_WHITE);
		tft.setCursor(x, 20);
		tft.fillScreen(TFT_BLACK);

		tft.println(revesttext);

		// tft.fillRect(80, 0, 80, 90, TFT_BLUE);
		x = x + 4;
		if (x < minX)
			x = tft.width() / 32;
		delay(100);
	}

	// String myString = String(revesttext);
	// tft.setCursor(10, 20);
	// tft.println(wrap(myString, 5));

	delay(5000);
	cleanDisplay();
}