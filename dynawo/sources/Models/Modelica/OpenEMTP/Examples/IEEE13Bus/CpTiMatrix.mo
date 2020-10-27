within OpenEMTP.Examples.IEEE13Bus;
function CpTiMatrix
  input Integer m = 3; // "Number of phases"
  output Real[m, m] Ti; // "Current Transformation matrix, i_phase = Ti * i_mode"
protected
  Real value;
algorithm

  for col in 1:m loop
    value := 1/sqrt(col*(col-1));
    for row in 1:m loop
      if col == 1 then
        Ti[row, col] := 1/sqrt(m);
      elseif( col < row ) then
        Ti[row, col] := 0;
      elseif( col == row ) then
        Ti[row, col] := -(col-1)*value;
      else
        Ti[row, col] := +value;
      end if;
    end for;
  end for;

end CpTiMatrix;
