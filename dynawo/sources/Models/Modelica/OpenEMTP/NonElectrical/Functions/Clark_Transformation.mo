within OpenEMTP.NonElectrical.Functions;
function Clark_Transformation "The alpha-beta transformation (also known as the Clarke transformation) for m-phase system"
  extends UserGuide.Icons.Function;
  input Integer m = 3; // "Number of phases"
  output Real[m, m] Ti; // "Current Transformation matrix, i_phase = Ti * i_mode"

algorithm
  for col in 1:m loop
//    value := 1/sqrt(col*(col-1));
    for row in 1:m loop
      if col == 1 then
        Ti[row, col] := 1/sqrt(m);
      elseif
            ( col < row) then
        Ti[row, col] := 0;
      elseif
            ( col == row) then
        Ti[row, col] := -(col-1)*(1/sqrt(col*(col-1)));
      else
        Ti[row, col] := (1/sqrt(col*(col-1)));
      end if;
    end for;
  end for;
end Clark_Transformation;
