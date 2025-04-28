within Dynawo.NonElectrical;

function ReverseCombiTable
  //These variables are dedicated to reverse the lookup table Table (only necessary when MwpqMode = 2)
  input Real Table[:,:];
  input Real y0;

  output Real x0;

protected
  Integer i "Iterative variable to search in each interval of the lookup table";
  Boolean search "Boolean variable to know whether it is necessary to keep searching or not";
  Dynawo.Types.PerUnit x1 "Left bound of interval i" ;
  Dynawo.Types.PerUnit x2 "Right bound of interval i";
  Dynawo.Types.ReactivePowerPu y1 "y-value associated to x1 in the lookup table";
  Dynawo.Types.ReactivePowerPu y2 "y-value associated to x2 in the lookup table";
  Dynawo.Types.ReactivePowerPu yma "Maximum between y1 and y2";
  Dynawo.Types.ReactivePowerPu ymi "Minimum between y1 and y2";

algorithm
  i := 0;
  search := true;

  while search loop
    i := i + 1; //For each iteration we search into the i-th interval

    //Let's update the data for this interval
    x1 := Table[i,1];
    x2 := Table[i+1,1];
    y1 := Table[i,2];
    y2 := Table[i+1,2];

    if y1 < y2 then
      yma := y2;
      ymi := y1;
    else
      yma := y1;
      ymi := y2;
    end if;

    // Check if y0 is between ymi and yma
    if (y0 >= ymi) and (y0 <= yma) then
      // Interpolate to find the corresponding x value and set search to false to stop searching (possible other solutions in other intervals are ignored)
      search := false;
      x0 := x1 + (y0 - y1) / (y2 - y1) * (x2 - x1); // Store the solution
    end if;

  // If we are at the end of the table and no corresponding value has been found, x0 is set to 0 and we stop searching
    if i >= size(Table,1) - 1 and search then
      x0 := 0;
      search := false;
    end if;

  end while;
end ReverseCombiTable;
