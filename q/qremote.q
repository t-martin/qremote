//connects remotely to a q process and places the user within that process
//author: Tom Martin
//date:   2016.04.15
opts:.Q.opt .z.x;
conn:hsym`$.z.x 0;
conndisplay:":"sv 3#":"vs string conn;
connparams:$[`to in key opts;(conn;$[.z.k<3;"I";"J"]$first opts[`to]);conn];
prompt:"q)";
version:"1.1";
program:"[qremote]";
usage:{[] -1"q ",string[.z.f]," <q-IPC-CONNECTION-STRING> [-to <IPC-TIMEOUT>] -c [<CONSOLE-WIDTH>]"};
out:{-1 program," [",x,"]"};
attempts:5;
sleep:"10";
colorise:0b;
color_on:{colorise::1b};
color_off:{colorise::0b};
qmultiloaded:0b;

if[`help in key opts;usage[];exit 0];

{[x]  
  failed:`failed~@[system;"l qmulti.q";{`failed}];
  while[failed and count x; 
    failed:`failed~@[system;"l ",getenv[first x],"/qmulti.q";{`failed}];
    x:1_x;
    ];
  if[not failed;qmultiloaded::1b];
  }`QMULTI_HOME`QHOME`QREMOTE_HOME;

@[{system"l ",getenv[`QREMOTE_HOME],"/q/color.q";.color.init[]; color_on[];};();{}];

.z.pc:{[x] if[x=h;out"remote process closed. attempting reconnect";connect[]]};

footer:{[dur;rdur]
  $[colorise;
    out " | " sv (.color.tagit[`GREY_3]conndisplay;.color.tagit[`BROWN_1]string .z.z;.color.tagit[`GREEN_39;"total:",string[dur],"ms"],$[null rdur;"";"//",.color.tagit[`BLUE_24;"remote:",string[rdur],"ms"],"//",.color.tagit[`YELLOW_21;"transfer:",string[dur-rdur],"ms"]]);
    out " | " sv (conndisplay;string .z.z;"total:",string[dur],"ms",$[null rdur;"";"//remote:",string[rdur],"ms//transfer:",string[dur-rdur],"ms"])
    ]
  };
  
connect:{[]
  connected:0b;
  while[not connected and attempts>0;
    out"connecting to: ",conndisplay;
    h::@[hopen;connparams;{out"could not connect to ",conndisplay,". error: ",x;()}];
    connected:"b"$count h;
    attempts-:1;
    if[attempts and not connected;out["attempts left: ",string[attempts],". retry in ",sleep," seconds"];system"sleep ",sleep];
    ];
  if[not connected;out["no more connection attempts left. exiting..."]; exit 1];
  attempts::5;
  out"connected to:  ",conndisplay;
  if[qmultiloaded;.priv.ml.initremote h;out"qmulti initialised for remote use"];
  out"\\\\ to exit. 'exit 0' will kill remote process";-1"";
  if[colorise;.color.reloadnsvars[h]]
  1 "\n",prompt
  };

k)qsremote:{$[(::)~x;"";`/:$[10h=@r:@[.Q.S[y-2 1;0];x;::];,-3!x;r]]};
k)rtrimn:{$[~t&77h>t:@x;.z.s'x;"\n"=last x;|ltrimn@|x;x]};
k)ltrimn:{$[~t&77h>t:@x;.z.s'x;"\n"=*x;(+/&\"\n"=x)_x;x]};
trimn:{ltrimn rtrimn x};
localpatterns:enlist["\\c*"];
multipatterns:("multi[[][]]";"multi`";enlist "m";"multi");
evalR:{[h;x;qs] h({[qs;x] s:.z.t;r:qs value x;`r`d!(r;`int$.z.t-s)}qs;x)};
evalL:{`r`d!(.Q.s value x;0N)};
 
zpi:{[x]
  x:trimn trim x;
  if[x~"\\\\"; :exit 0];
  start:.z.t;
  res:$[
    qmultiloaded and any x like/:multipatterns;
      `r`d!("";multi[]);
    any x like/:localpatterns;
      evalL x;
    x like "\\rl *";
      evalL 3_x;
    colorise and x like "\\scheme *";
      evalL ".color.load `",trim 7_x;
      evalR[h;x;qsremote[;system"c"]]
    ];
  end:.z.t;
  remdur:res`d;res:res`r;
  if[not ""~res;$[colorise;@[.color.colorise;res;{[x;y] -1 trimn res}res];-1 trimn res]];
  footer[`int$end-start;remdur];
  1 prompt;
  }

.z.pi:{@[zpi;x;{-1"'",x;footer[0;0N];1 prompt}]};

out"v",version;
@[connect;();{out"encountered an error: ",x; exit 1}];


