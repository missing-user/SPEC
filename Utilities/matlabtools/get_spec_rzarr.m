function rzdata = get_spec_rzarr(data,lvol,sarr,tarr,zarr)
 
 
% Transforms (s,theta,zeta) array into (R,Z) array in volume number lvol
%
% INPUT
%   -data    : must be produced by calling e.g. read_spec_grid(filename)
%   -lvol    : volume number
%   -sarr    : is the array of values for the s-coordinate
%   -tarr    : is the array of values for the theta-coordinate
%   -zarr    : is the array of values for the zeta-coordinate
%
% OUTPUT
%   -rzdata  : array with (R,Z) data array with size 2*ns*nt*nz where ns=length(sarr),nt=length(zarr),nt=length(zarr)
%
% Note: Stellarator symmetry is assumed
%
% written by J.Loizu (2016)


Rac     = data.Rbc(:,lvol);   % inner volume boundary harmonics
Zas     = data.Zbs(:,lvol);
Rbc     = data.Rbc(:,lvol+1); % outer volume boundary harmonics
Zbs     = data.Zbs(:,lvol+1);

sarr    = transpose(sarr);
ns      = length(sarr);
nt      = length(tarr);
nz      = length(zarr);
sbar    = (sarr+1)/2;

mn      = data.mn;
im      = double(data.im);
in      = double(data.in);

Rarr    = zeros(ns,nt,nz); % allocate data for R-array
Zarr    = zeros(ns,nt,nz); % allocate data for Z-array

fac     = cell(mn,1);      % allocate data for regularization factors 



% Construct regularization factors

for j=1:mn
  if(lvol>1 || im(j)==0) 
   fac{j} = sbar;
  else
   fac{j} = sbar.^(im(j)/2);
  end
end


% Construct (R,Z) coordinates array

for j=1:mn
  for it=1:nt
    for iz=1:nz
     cosa = cos(im(j)*tarr(it)-in(j)*zarr(iz));
     sina = sin(im(j)*tarr(it)-in(j)*zarr(iz));
     Rarr(:,it,iz) = Rarr(:,it,iz) + (Rac(j) + fac{j}.*(Rbc(j)-Rac(j)) )*cosa;
     Zarr(:,it,iz) = Zarr(:,it,iz) + (Zas(j) + fac{j}.*(Zbs(j)-Zas(j)) )*sina;
    end
  end
end

rzdata{1} = Rarr;
rzdata{2} = Zarr;