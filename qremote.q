//connects remotely to a q process and places the user within that process
//author: Tom Martin
//date:   2016.04.15
opts:.Q.opt .z.x;
conn:hsym`$.z.x 0;
conndisplay:":"sv 3#":"vs string conn;
connparams:$[`to in key opts;(conn;$[.z.k<3;"I";"J"]$first opts[`to]);conn];
prompt:"q)";
version:"1.0";
program:"[qremote]";
usage:{[] -1"q ",string[.z.f]," <q-IPC-CONNECTION-STRING> [-to <IPC-TIMEOUT>] -c [<CONSOLE-WIDTH>]"};
out:{-1 program," [",x,"]"};

if[`help in key opts;usage[];exit 0];

{[x]
  failed:1b;
  while[failed and count x; 
    failed:`failed~@[system;"l ",getenv[first x],"/qmulti.q";{`failed}];
    x:1_x;
    ];
  }`QMULTI_HOME`QHOME`QREMOTE_HOME;
checkforqmulti:{$[count key v:`.priv.ml.qmultiloaded;value v;0b]};

.z.pc:{[x] out"remote process closed...";exit 1};

footer:{[dur] out conndisplay," || ",dur,"ms";};

connect:{[]
  out"v",version;
  out"connecting to: ",conndisplay;
  h::@[hopen;connparams;{out"could not connect to ",conndisplay,". error: ",x;exit 1}];
  out"connected to:  ",conndisplay;
  if[checkforqmulti[];.priv.ml.initeval h;out"qmulti initialised for remote use"];
  out"\\\\ to exit. 'exit 0' will kill remote process";-1"";};

k)qsremote:{$[(::)~x;"";`/:$[10h=@r:@[.Q.S[y-2 1;0];x;::];,-3!x;r]]};
k)rtrimn:{$[~t&77h>t:@x;.z.s'x;"\n"=last x;|ltrimn@|x;x]};
k)ltrimn:{$[~t&77h>t:@x;.z.s'x;"\n"=*x;(+/&\"\n"=x)_x;x]};
trimn:{ltrimn rtrimn x};
localpatterns:enlist["\\c*"],$[checkforqmulti[];("multi[[]]*";"multi`*");()];

zpi:{[x]
  x:trimn trim x;
  if[x~"\\\\"; :exit 0];
  start:.z.t;
  res:$[any x like/:localpatterns;.Q.s value x;h(qsremote[;system"c"]@value@;x)];
  end:.z.t;
  if[not ""~res;-1 trimn res];
  footer[string `int$end-start];
  1 prompt;
  }

.z.pi:{@[zpi;x;{-1"'",x;footer["0"];1 prompt}]};

@[connect;();{out" encountered an error: ",x; exit 1}];

1 prompt;  
