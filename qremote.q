//connects remotely to a q process and places the user within that process
//author: Tom Martin
//date:   2016.04.15
opts:.Q.opt .z.x;
conn:hsym`$.z.x 0;
conndisplay:":"sv 3#":"vs string conn;
connparams:$[`to in key opts;(conn;$[.z.k<3;"I";"J"]$first opts[`to]);conn];
prompt:"q)";
version:"1.0";
program:"qremote";
usage:{[] -1"q ",string[.z.f]," <q-IPC-CONNECTION-STRING> [-to <IPC-TIMEOUT>] -c [<CONSOLE-WIDTH>]"};

if[`help in key opts;usage[];exit 0];

.z.pc:{[x] -2"[remote process closed...]";exit 1};

footer:{[dur] -1"[","connection: ",conndisplay," || ","duration: ",dur,"ms","]";};

connect:{[]
  -1"[",program," v",version,"]";
  -1"[",program," connecting to: ",conndisplay,"]";
  h::@[hopen;connparams;{-2"[could not connect to ",conndisplay,". error: ",x,"]";exit 1}];
  -1"[",program," connected to:  ",conndisplay,"]";
  -1"[\\\\ to exit. 'exit 0' will kill remote process]\n";
  };

k)qsremote:{$[(::)~x;"";`/:$[10h=@r:@[.Q.S[y-2 1;0];x;::];,-3!x;r]]};
k)rtrimn:{$[~t&77h>t:@x;.z.s'x;"\n"=last x;|ltrimn@|x;x]};
k)ltrimn:{$[~t&77h>t:@x;.z.s'x;"\n"=*x;(+/&\"\n"=x)_x;x]};
trimn:{ltrimn rtrimn x};

zpi:{[x]
  x:trimn trim x;
  if[x~"\\\\"; :exit 0];
  start:.z.t;
  res:$[x like "\\c*";.Q.s value x;h(qsremote[;system"c"]@value@;x)];
	end:.z.t;
	if[not ""~res;-1 trimn res];
	footer[string `int$end-start];
  1 prompt;
  };
.z.pi:{@[zpi;x;{-1"'",x;footer["0"];1 prompt}]};

@[connect;();{-2"[",program," encountered an error: ",x,"]"; exit 1}];

1 prompt;  
