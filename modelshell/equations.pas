{ This unit defines the structure of the model. There are four functions. The
  first function, called counts, defines the number, names, and units of the
  model, the state variables, the process variables, the driver variables and
  the parameters. The second function, called processes, is the actual equations
  which make up the model. The third function, derivs, calculates the
  derivatives of state variables. And the fourth function, parcount, is used to
  automatically number the parameters consecutively. 
    The state variables, driver variables, process variables and parameters are
  all stored in global arrays, called stat, drive, proc, and par, respectively.
  The function counts accesses the global arrays directly but the other functions
  operate on copies of the global arrays. }
unit equations;

interface

uses  stypes, math, sysutils;

PROCEDURE counts;
PROCEDURE processes(time:double; dtime:double; var tdrive:drivearray;
                       var tpar:paramarray; var tstat:statearray;
                       var tproc:processarray; CalculateDiscrete:Boolean);
PROCEDURE derivs(t, drt:double; var tdrive:drivearray; var tpar:paramarray;
             var statevalue:yValueArray; VAR dydt:yValueArray);
function ParCount(processnum:integer) : integer;

var
  tproc:processarray;
  tstat:statearray;
  sensflag:boolean;
  newyear:Boolean = false;
  DayofYear: double = 0;
  h: array[1..4,1..4] of double;

implementation

uses frontend, calculate, options;

           { Do not make modifcations above this line. }
{*****************************************************************************}

{ This procedure defines the model. The number of parameters, state, driver and
  process variables are all set in this procedure. The model name, version
  number and time unit are also set here. This procedure accesses the global
  arrays containing the the parameters, state, driver and process variables and
  the global structure ModelDef directly, to save memory space. }
PROCEDURE counts;
var
 i,npar,CurrentProc:integer;
begin
{ Set the modelname, version and time unit. }
ModelDef.modelname := 'openness';
ModelDef.versionnumber := '1.0.0';
ModelDef.timeunit := 'day';
ModelDef.contactperson := 'Ed';
ModelDef.contactaddress1 := 'MBL';
ModelDef.contactaddress2 := 'Woods Hole';
ModelDef.contactaddress3 := 'MA';

{ Set the number of state variables in the model. The maximum number of state
  variables is maxstate, in unit stypes. }
ModelDef.numstate := 5;

{ Enter the name, units and symbol for each state variable. The maximum length
  of the state variable name is 17 characters and the maximum length for units
  and symbol is stringlength (specified in unit stypes) characters. }
 
 
with stat[1] do
 begin
    name:='Autotrophic C';  units:='g C m-2';  symbol:='BC';
 end;
 
with stat[2] do
 begin
    name:='Autotrophic N';  units:='g N m-2';  symbol:='BN';
 end;
 
with stat[3] do
 begin
    name:='Detrital C';  units:='g C m-2';  symbol:='DC';
 end;
 
with stat[4] do
 begin
    name:='Detrital N';  units:='g N m-2';  symbol:='DN';
 end;
 
with stat[5] do
 begin
    name:='Inorganic N';  units:='g N m-2';  symbol:='N';
 end;

{ Set the total number of processes in the model. The first numstate processes
  are the derivatives of the state variables. The maximum number of processes is
  maxparam, in unit stypes. }
ModelDef.numprocess := ModelDef.numstate + 14;

{ For each process, set proc[i].parameters equal to the number of parameters
  associated with that process, and set IsDiscrete to true or false. After each
  process, set the name, units, and symbol for all parameters associated with
  that process. Note that Parcount returns the total number of parameters in
  all previous processes. }
 
CurrentProc := ModelDef.numstate + 1;
With proc[CurrentProc] do
   begin
      name       := 'Allometric scalar';
      units       := 'g C m-2';
      symbol       := 'S';
      parameters       := 2;
      ptype       := ptGroup1;
   end;
npar:=ParCount(CurrentProc);
with par[npar + 1] do
 begin
    name:='alpha';  units:='m2 g-1 C';  symbol:='alpha';
 end;
with par[npar + 2] do
 begin
    name:='gamma';  units:='m2 g-1 C';  symbol:='gamma';
 end;
 
CurrentProc := ModelDef.numstate + 2;
With proc[CurrentProc] do
   begin
      name       := 'Autotroph Stoichiometry';
      units       := 'none';
      symbol       := 'Psi';
      parameters       := 1;
      ptype       := ptGroup1;
   end;
npar:=ParCount(CurrentProc);
with par[npar + 1] do
 begin
    name:='autotroph C:N';  units:='g C g-1 N';  symbol:='qB';
 end;
 
CurrentProc := ModelDef.numstate + 3;
With proc[CurrentProc] do
   begin
      name       := 'Heterotroph stoichiometry';
      units       := 'none';
      symbol       := 'Phi';
      parameters       := 1;
      ptype       := ptGroup1;
   end;
npar:=ParCount(CurrentProc);
with par[npar + 1] do
 begin
    name:='heterotroph C:N';  units:='g C g-1 N';  symbol:='qD';
 end;
 
CurrentProc := ModelDef.numstate + 4;
With proc[CurrentProc] do
   begin
      name       := 'Photosyinthesis';
      units       := 'g C m-1 day-1';
      symbol       := 'Ps';
      parameters       := 3;
      ptype       := ptGroup1;
   end;
npar:=ParCount(CurrentProc);
with par[npar + 1] do
 begin
    name:='Ps rate const';  units:='day-1';  symbol:='gC';
 end;
with par[npar + 2] do
 begin
    name:='CO2 half sat';  units:='ppm';  symbol:='kC';
 end;
with par[npar + 3] do
 begin
    name:='Q10 Ps';  units:='none';  symbol:='Q10Ps';
 end;
 
CurrentProc := ModelDef.numstate + 5;
With proc[CurrentProc] do
   begin
      name       := 'Autotroph respiration';
      units       := 'g C m-2 day-1';
      symbol       := 'Ra';
      parameters       := 2;
      ptype       := ptGroup1;
   end;
npar:=ParCount(CurrentProc);
with par[npar + 1] do
 begin
    name:='autotrop resp const';  units:='day-1';  symbol:='rB';
 end;
with par[npar + 2] do
 begin
    name:='Q10 Ra';  units:='none';  symbol:='Q10Ra';
 end;
 
CurrentProc := ModelDef.numstate + 6;
With proc[CurrentProc] do
   begin
      name       := 'Litter C';
      units       := 'g C m-2 day-1';
      symbol       := 'LitC';
      parameters       := 1;
      ptype       := ptGroup1;
   end;
npar:=ParCount(CurrentProc);
with par[npar + 1] do
 begin
    name:='C litter rate const';  units:='day-1';  symbol:='mCB';
 end;
 
CurrentProc := ModelDef.numstate + 7;
With proc[CurrentProc] do
   begin
      name       := 'Autotroph N uptake';
      units       := 'g N m-2 day-1';
      symbol       := 'UN';
      parameters       := 3;
      ptype       := ptGroup1;
   end;
npar:=ParCount(CurrentProc);
with par[npar + 1] do
 begin
    name:='Autotroph N up const';  units:='g N g-1 C day-1';  symbol:='gN';
 end;
with par[npar + 2] do
 begin
    name:='Autotroph N half sat';  units:='g N m-2';  symbol:='kN';
 end;
with par[npar + 3] do
 begin
    name:='Q10 UN';  units:='none';  symbol:='Q10UN';
 end;
 
CurrentProc := ModelDef.numstate + 8;
With proc[CurrentProc] do
   begin
      name       := 'Litter N';
      units       := 'g N m-2 day-1';
      symbol       := 'LitN';
      parameters       := 1;
      ptype       := ptGroup1;
   end;
npar:=ParCount(CurrentProc);
with par[npar + 1] do
 begin
    name:='N litter rate const';  units:='day-1';  symbol:='mNB';
 end;
 
CurrentProc := ModelDef.numstate + 9;
With proc[CurrentProc] do
   begin
      name       := 'Heterotroph resp';
      units       := 'g C m-2 day-1';
      symbol       := 'Rh';
      parameters       := 2;
      ptype       := ptGroup1;
   end;
npar:=ParCount(CurrentProc);
with par[npar + 1] do
 begin
    name:='heterotr resp rate cosnt';  units:='day-1';  symbol:='rD';
 end;
with par[npar + 2] do
 begin
    name:='Q10 Rh';  units:='none';  symbol:='Q10Rh';
 end;
 
CurrentProc := ModelDef.numstate + 10;
With proc[CurrentProc] do
   begin
      name       := 'N immobilization';
      units       := 'g N m-2 day-1';
      symbol       := 'UNm';
      parameters       := 3;
      ptype       := ptGroup1;
   end;
npar:=ParCount(CurrentProc);
with par[npar + 1] do
 begin
    name:='Immob rate const';  units:='g N g-1 C day-1';  symbol:='gNm';
 end;
with par[npar + 2] do
 begin
    name:='Immob half sat';  units:='g N m-2';  symbol:='kNm';
 end;
with par[npar + 3] do
 begin
    name:='Q10 IMM';  units:='none';  symbol:='Q10IMM';
 end;
 
CurrentProc := ModelDef.numstate + 11;
With proc[CurrentProc] do
   begin
      name       := 'N miniralization';
      units       := 'g N m-2 day-1';
      symbol       := 'M';
      parameters       := 2;
      ptype       := ptGroup1;
   end;
npar:=ParCount(CurrentProc);
with par[npar + 1] do
 begin
    name:='mineraliz const';  units:='day-1';  symbol:='mNm';
 end;
with par[npar + 2] do
 begin
    name:='Q10 Min';  units:='none';  symbol:='Q10Min';
 end;
 
CurrentProc := ModelDef.numstate + 12;
With proc[CurrentProc] do
   begin
      name       := 'N leaching';
      units       := 'g N m-2 day-1';
      symbol       := 'Nout';
      parameters       := 1;
      ptype       := ptGroup1;
   end;
npar:=ParCount(CurrentProc);
with par[npar + 1] do
 begin
    name:='leach rate';  units:='day-1';  symbol:='betaN';
 end;
 
CurrentProc := ModelDef.numstate + 13;
With proc[CurrentProc] do
   begin
      name       := 'DON leaching';
      units       := 'g N m-2 day-1';
      symbol       := 'DONout';
      parameters       := 1;
      ptype       := ptGroup1;
   end;
npar:=ParCount(CurrentProc);
with par[npar + 1] do
 begin
    name:='leach DON rate';  units:='day-1';  symbol:='betaDON';
 end;
 
CurrentProc := ModelDef.numstate + 14;
With proc[CurrentProc] do
   begin
      name       := 'DOC leaching';
      units       := 'g C m-2 day-1';
      symbol       := 'DOCout';
      parameters       := 1;
      ptype       := ptGroup1;
   end;
npar:=ParCount(CurrentProc);
with par[npar + 1] do
 begin
    name:='C:N DOM';  units:='g C g-1 N';  symbol:='qDOM';
 end;

{ Set the total number of drivers in the model. The maximum number of drivers is
  maxdrive, in unit stypes. }
ModelDef.numdrive := 3;

{ Set the names, units, and symbols of the drivers. The maximum length for the
  name, units and symbol is 20 characters. }
 
with drive[1] do
 begin
    name:='N inputs';  units:='g N m-2 day-1';  symbol:='Nin';
 end;
 
with drive[2] do
 begin
    name:='Atm CO2';  units:='ppm';  symbol:='Ca';
 end;
 
with drive[3] do
 begin
    name:='temperature';  units:='oC';  symbol:='Tmp';
 end;

{ The first numstate processes are the derivatives of the state variables. The
  code sets the names, units and symbols accordingly.}
for i:= 1 to ModelDef.numstate do proc[i].name:='d'+stat[i].name+'dt';
for i:= 1 to ModelDef.numstate do proc[i].units := stat[i].units + 't-1';
for i:= 1 to ModelDef.numstate do proc[i].symbol := 'd' + stat[i].symbol + 'dt';

{ Code to sum up the total number of parameters in the model. Do not change the
  next few lines. }
ModelDef.numparam := 0;
for i := 1 to ModelDef.NumProcess do
  ModelDef.numparam := ModelDef.numparam + proc[i].parameters;

end; // counts procedure


{ A procedure to calculate the value of all states and processes at the current
  time. This function accesses time, state variables and process variables by
  reference, ie it uses the same array as the calling routine. It does not use
  the global variables time, stat and proc because values calculated during
  integration might later be discarded. It does access the global variables par,
  drive and ModelDef directly because those values are not modified.

  The model equations are written using variable names which correspond to the
  actual name instead of using the global arrays (i.e. SoilWater instead of
  stat[7].value). This makes it necessary to switch all values into local
  variables, do all the calculations and then put everything back into the
  global variables. Lengthy but worth it in terms of readability of the code. }

// Choose either GlobalPs, ArcticPs, or none here so the appropriate Ps model is compiled below.
{$DEFINE none}

PROCEDURE processes(time:double; dtime:double; var tdrive:drivearray;
                       var tpar:paramarray; var tstat:statearray;
                       var tproc:processarray; CalculateDiscrete:Boolean);
{$IFDEF GlobalPs}
const
// Global Ps parameters
 x1 = 11.04;             x2 = 0.03;
 x5 = 0.216;             x6 = 0.6;
 x7 = 3.332;             x8 = 0.004;
 x9 = 1.549;             x10 = 1.156;
 gammastar = 0;          kCO2 = 995.4;  }
{$ENDIF}

// Modify constant above (line above "procedure processes..." line )to specify
// which Ps model and it's constants should be compiled. Choosing a Ps model
// automatically includes the Et and Misc constants (i.e. Gem is assumed).

{$IFDEF ArcticPs}
const
// Arctic Ps parameters
x1 = 0.192;	x2 = 0.125;
x5 = 2.196;	x6 = 50.41;
x7 = 0.161;	x8 = 14.78;
x9 = 1.146;
gammastar = 0.468;	kCO2 = 500.3;
{$ENDIF}

{$IFDEF ArcticPs OR GlobalPs}
//const
// General Et parameters
aE1 = 0.0004;    aE2 = 150;  aE3 = 1.21;   aE4 = 6.11262E5;

// Other constants
cp = 1.012E-9; //specific heat air MJ kg-1 oC-1
sigmaSB = 4.9e-9; //stefan-Boltzmann MJ m-2 day-1 K-4
S0 = 117.5; //solar constant MJ m-2 day-1
bHI1 =0.23;
bHI2 =0.48;
mw = 2.99; //kg h2o MJ-1
alphaMS = 2; //mm oC-1 day-1                                 }
{$ENDIF}

var
{ List the variable names you are going to use here. Generally, this list
  includes all the symbols you defined in the procedure counts above. The order
  in which you list them does not matter. }
{States}
BC, dBCdt, 
BN, dBNdt, 
DC, dDCdt, 
DN, dDNdt, 
N, dNdt, 

{processes and associated parameters}
S, alpha, gamma, 
Psi, qB, 
Phi, qD, 
Ps, gC, kC, Q10Ps, 
Ra, rB, Q10Ra, 
LitC, mCB, 
UN, gN, kN, Q10UN, 
LitN, mNB, 
Rh, rD, Q10Rh, 
UNm, gNm, kNm, Q10IMM, 
M, mNm, Q10Min, 
Nout, betaN, 
DONout, betaDON, 
DOCout, qDOM, 

{drivers}
Nin, 
Ca, 
Tmp

{Other double}

:double; {Final double}

{Other integers}
npar, j, jj, kk, ll, tnum:integer;

{ Boolean Variables }


{ Functions or procedures }

begin
{ Copy the drivers from the global array, drive, into the local variables. }
Nin := tdrive[1].value;
Ca := tdrive[2].value;
Tmp := tdrive[3].value;

{ Copy the state variables from the global array into the local variables. }
BC := tstat[1].value;
BN := tstat[2].value;
DC := tstat[3].value;
DN := tstat[4].value;
N := tstat[5].value;

{ And now copy the parameters into the local variables. No need to copy the
  processes from the global array into local variables. Process values will be
  calculated by this procedure.

  Copy the parameters for each process separately using the function ParCount
  to keep track of the number of parameters in the preceeding processes.
  npar now contains the number of parameters in the preceding processes.
  copy the value of the first parameter of this process into it's local
  variable }
npar:=ParCount(ModelDef.numstate + 1);
alpha := par[npar + 1].value;
gamma := par[npar + 2].value;

npar:=ParCount(ModelDef.numstate + 2);
qB := par[npar + 1].value;
 
npar:=ParCount(ModelDef.numstate + 3);
qD := par[npar + 1].value;
 
npar:=ParCount(ModelDef.numstate + 4);
gC := par[npar + 1].value;
kC := par[npar + 2].value;
Q10Ps := par[npar + 3].value;
 
npar:=ParCount(ModelDef.numstate + 5);
rB := par[npar + 1].value;
Q10Ra := par[npar + 2].value;
 
npar:=ParCount(ModelDef.numstate + 6);
mCB := par[npar + 1].value;
 
npar:=ParCount(ModelDef.numstate + 7);
gN := par[npar + 1].value;
kN := par[npar + 2].value;
Q10UN := par[npar + 3].value;
 
npar:=ParCount(ModelDef.numstate + 8);
mNB := par[npar + 1].value;
 
npar:=ParCount(ModelDef.numstate + 9);
rD := par[npar + 1].value;
Q10Rh := par[npar + 2].value;
 
npar:=ParCount(ModelDef.numstate + 10);
gNm := par[npar + 1].value;
kNm := par[npar + 2].value;
Q10IMM := par[npar + 3].value;
 
npar:=ParCount(ModelDef.numstate + 11);
mNm := par[npar + 1].value;
Q10Min := par[npar + 2].value;
 
npar:=ParCount(ModelDef.numstate + 12);
betaN := par[npar + 1].value;
 
npar:=ParCount(ModelDef.numstate + 13);
betaDON := par[npar + 1].value;
 
npar:=ParCount(ModelDef.numstate + 14);
qDOM := par[npar + 1].value;
 
dBCdt := -999;
dBNdt := -999;
dDCdt := -999;
dDNdt := -999;
dNdt := -999;
S := -999;
Psi := -999;
Phi := -999;
Ps := -999;
Ra := -999;
LitC := -999;
UN := -999;
LitN := -999;
Rh := -999;
UNm := -999;
M := -999;
Nout := -999;
DONout := -999;
DOCout := -999;
 
{ Enter the equations to calculate the processes here, using the local variable
  names defined above. }

S:=BC*(BC*alpha+1)/(BC*gamma+1);
if BN>0 then Psi:=BC/(BN*qB) else Psi:=1;
if DN>0 then Phi:=DC/(DN*qD) else Phi:=1;
Ps:=power(Q10Ps,Tmp/10)*gC*S*Ca/(kC+Ca)/Psi;
Ra:=power(Q10Ra,Tmp/10)*rB*BC*Psi;
LitC:=mCB*BC;
UN:=power(Q10UN,Tmp/10)*gN*S*Psi*N/(kN+N);
LitN:=mNB*BN/Psi;
Rh:=power(Q10Rh,Tmp/10)*rD*DC*Phi;
UNm:=power(Q10IMM,Tmp/10)*gNm*DC*Phi*N/(kNm+N);
M:=power(Q10Min,Tmp/10)*mNm*DN/Phi;
Nout:=betaN*N;
DONout:=betaDON*DN;
DOCout:=DONout*qDOM;
if CalculateDiscrete then
begin
// Add any discrete processes here
end; //discrete processes


{ Now calculate the derivatives of the state variables. If the holdConstant
  portion of the state variable is set to true then set the derivative equal to
  zero. }
if (tstat[1].HoldConstant) and (FmOptions.RunOptions.HoldStatesConstant) then
 dBCdt := 0
else
 dBCdt:=Ps-Ra-LitC;
 
if (tstat[2].HoldConstant) and (FmOptions.RunOptions.HoldStatesConstant) then
 dBNdt := 0
else
 dBNdt:=UN-LitN;
 
if (tstat[3].HoldConstant) and (FmOptions.RunOptions.HoldStatesConstant) then
 dDCdt := 0
else
 dDCdt:=LitC-Rh-DOCout;
 
if (tstat[4].HoldConstant) and (FmOptions.RunOptions.HoldStatesConstant) then
 dDNdt := 0
else
 dDNdt:=LitN+UNm-M-DONout;
 
if (tstat[5].HoldConstant) and (FmOptions.RunOptions.HoldStatesConstant) then
 dNdt := 0
else
 dNdt:=Nin+M-UN-UNm-Nout;
 

{ Now that the calculations are complete, assign everything back into the arrays
  so the rest of the code can access the values calculated here. (Local variables
  are destroyed at the end of the procedure).

  Put the state variables back into the global arrays in case the state variable
  was manually changed in this procedure (e.g. discrete state variables or steady state
  calculations).   }
tstat[1].value := BC;
tstat[2].value := BN;
tstat[3].value := DC;
tstat[4].value := DN;
tstat[5].value := N;

{  Put all process values into process variable array. The first numstate
  processes are the derivatives of the state variables (Calculated above).}
tproc[1].value := dBCdt;
tproc[2].value := dBNdt;
tproc[3].value := dDCdt;
tproc[4].value := dDNdt;
tproc[5].value := dNdt;

{ Now the remaining processes. Be sure to number the processes the same here as
  you did in the procedure counts above. }
tproc[ModelDef.numstate + 1].value := S;
tproc[ModelDef.numstate + 2].value := Psi;
tproc[ModelDef.numstate + 3].value := Phi;
tproc[ModelDef.numstate + 4].value := Ps;
tproc[ModelDef.numstate + 5].value := Ra;
tproc[ModelDef.numstate + 6].value := LitC;
tproc[ModelDef.numstate + 7].value := UN;
tproc[ModelDef.numstate + 8].value := LitN;
tproc[ModelDef.numstate + 9].value := Rh;
tproc[ModelDef.numstate + 10].value := UNm;
tproc[ModelDef.numstate + 11].value := M;
tproc[ModelDef.numstate + 12].value := Nout;
tproc[ModelDef.numstate + 13].value := DONout;
tproc[ModelDef.numstate + 14].value := DOCout;

end;  // End of processes procedure


       { Do not make any modifications to code below this line. }
{****************************************************************************}


{This function counts the parameters in all processes less than processnum.}
function ParCount(processnum:integer) : integer;
var
 NumberofParams, counter : integer;
begin
  NumberofParams := 0;
  for counter := ModelDef.numstate + 1 to processnum - 1 do
         NumberofParams := NumberofParams + proc[counter].parameters;
  ParCount := NumberofParams;
end; // end of parcount function

{ This procedure supplies the derivatives of the state variables to the
  integrator. Since the integrator deals only with the values of the variables
  and not there names, units or the state field HoldConstant, this procedure
  copies the state values into a temporary state array and copies the value of
  HoldConstant into the temporary state array and passes this temporary state
  array to the procedure processes. }
PROCEDURE derivs(t, drt:double; var tdrive:drivearray; var tpar:paramarray;
             var statevalue:yValueArray; VAR dydt:yValueArray);
var
   i:integer;
   tempproc:processarray;
   tempstate:statearray;
begin
   tempstate := stat;  // Copy names, units and HoldConstant to tempstate
  // Copy current values of state variables into tempstate
   for i := 1 to ModelDef.numstate do tempstate[i].value := statevalue[i];
  // Calculate the process values
   processes(t, drt, tdrive, tpar, tempstate, tempproc, false);
  // Put process values into dydt array to get passed back to the integrator.
   for i:= 1 to ModelDef.numstate do dydt[i]:=tempproc[i].value;
end;  // end of derivs procedure

end.
