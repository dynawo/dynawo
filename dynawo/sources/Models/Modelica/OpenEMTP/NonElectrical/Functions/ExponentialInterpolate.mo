within OpenEMTP.NonElectrical.Functions;

function ExponentialInterpolate "Interpolate exponentially in a vector"
  extends UserGuide.Icons.Function;
  input Real y[:] "Abscissa table vector (strict monotonically increasing values required)";
  //Vj
  input Real p[size(y, 1)] "Ordinate table vector";
  input Real q[size(y, 1)] "Ordinate table vector";
  input Real Vref;
  input Real u "Desired abscissa value";
  input Integer iLast=1 "Index used in last search";
  output Real yy "Ordinate value corresponding to xi";
  output Integer iNew=1 "xi is in the interval x[iNew] <= xi < x[iNew+1]";
protected
  Integer i;
  Integer nx=size(y, 1);
  Real yi=abs(u),xi;
  Real x1,y1;
  Real p1;
  Real q1;
  Real m;

algorithm
  assert(nx > 0, "The table vectors must have at least 1 entry.");
// Search point
// search forward
  if yi >= y[nx] then
    i := nx;
  else
    i := 1;
    while i < nx and yi >= y[i] loop
      i := i + 1;
    end while;
    i := i - 1;
  end if;
// Interpolate
  if i == 0 then
    x1 := p[1] * (y[1] / Vref) ^ q[1];
    m := y[1] / x1;
    xi := 1 / m * yi;
  else
    xi := p[i] * (yi / Vref) ^ q[i];
  end if;
//i=0
//i>1
  iNew := i;
//symetricalization based on odd function f(-x)=-f(X)
  if u >= 0 then
    yy := xi;
  else
    yy := -xi;
  end if;
  annotation (smoothOrder( normallyConstant=u, normallyConstant=y)=100,
    Documentation(info = "<html><head></head><body><blockquote><pre>The function is used to interpolate the V-I characteristics of metal oxid arrester as per EMTP.</pre><pre>The segment connecting the first exponential segment to the origin
is assumed symmetrical.<br>
</pre></blockquote>
</body></html>", revisions = "<html><head></head><body><em style=\"font-size: 12px;\">2020-09-25 &nbsp;</em><span style=\"font-size: 12px;\">&nbsp;by Alireza Masoom initially implemented</span></body></html>"));

end ExponentialInterpolate;
