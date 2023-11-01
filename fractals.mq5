#property copyright "2009-2020, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_plots   2
#property indicator_type1   DRAW_ARROW
#property indicator_type2   DRAW_ARROW
#property indicator_color1  clrGray
#property indicator_color2  clrGray
#property indicator_label1  "Up Fractal"
#property indicator_label2  "Down Fractal"

double ExtUpBuffer[];
double ExtLowBuffer[];
//input
input int how_many = 2; //bars left and right
int ExtShift = 10;
int sign_size = 1;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
void OnInit() {

   SetIndexBuffer(0, ExtUpBuffer, INDICATOR_DATA);
   SetIndexBuffer(1, ExtLowBuffer, INDICATOR_DATA);
   IndicatorSetInteger(INDICATOR_DIGITS, _Digits);

   PlotIndexSetInteger(0, PLOT_ARROW, 218);
   PlotIndexSetInteger(1, PLOT_ARROW, 217);

   PlotIndexSetInteger(0, PLOT_ARROW_SHIFT, -ExtShift);
   PlotIndexSetInteger(1, PLOT_ARROW_SHIFT, ExtShift);

   PlotIndexSetDouble(0, PLOT_EMPTY_VALUE, 0);
   PlotIndexSetDouble(1, PLOT_EMPTY_VALUE, 0);

   PlotIndexSetInteger(0, PLOT_LINE_WIDTH, sign_size);
   PlotIndexSetInteger(1, PLOT_LINE_WIDTH, sign_size);

}
//+------------------------------------------------------------------+
//|  OnCalculate function                                            |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[]) {
                

   if(rates_total < ((how_many * 2) + 1))
      return(0);


   int start;
   if(prev_calculated < ((how_many * 2) + 3)) {
      start = how_many;
      ArrayInitialize(ExtUpBuffer,0);
      ArrayInitialize(ExtLowBuffer,0);
   } else
      start = rates_total - ((how_many * 2) + 1);


// Low Fractal
   for(int i = start; i < rates_total - (how_many + 1) && !IsStopped(); i++) 
   {
      bool IsFractalDn = true;
      for(int j = 1; j <= how_many && IsFractalDn == true; j++) {
         IsFractalDn = ( IsFractalDn && (low[i] < low[i + j]) );
         IsFractalDn = ( IsFractalDn && (low[i] < low[i - j]) );
      }
      if(IsFractalDn) 
         ExtLowBuffer[i] = low[i];
      else
         ExtLowBuffer[i] = 0;
   }
// Up Fractal
   for(int i = start; i < rates_total - (how_many + 1) && !IsStopped(); i++) 
   {
      bool IsFractalUp = true;
      for(int j = 1; j <= how_many && IsFractalUp == true; j++) {
         IsFractalUp = ( IsFractalUp && (high[i] > high[i + j]) );
         IsFractalUp = ( IsFractalUp && (high[i] > high[i - j]) );
      }
      if(IsFractalUp) 
         ExtUpBuffer[i] = high[i];
      else
         ExtUpBuffer[i] = 0;
   }
   
   return(rates_total);
}
//------------------------------------------------------------------//
//------------------------------------------------------------------//
