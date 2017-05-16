.color.TOKEN_MAP:([token:()] color:());
.color.TYPE_MAP:()!();
.color.TABLECHARS:enlist each "|-";
.color.OPERATORS:enlist each "+*><.@#$%^&!_',\\=~?/";
.color.SPLITS:enlist each "{([;:])}";
.color.QSQL:("select";"delete";"update";"from";"where";"by");
.color.nsvars:{[]
  isNS:{if[not count key x;:0b];if[any x~/:``.;:1b];$[99h=type v:value x;(1#v)~enlist[`]!enlist(::);0b]};
  nsf:{[isNS;ns] if[not isNS ns;:`$()];$[any ns~``.;system"f ",string ns;` sv'ns,/:system"f ",string ns]}[isNS];
  subNS:{[isNS;ns] $[not isNS ns;`$(); 1_key ns]}[isNS];
  nsv:{[isNS;subNS;ns] if[not isNS ns;:`$()]; $[any ns~/:``.;(` sv' `,/:subNS`),system"v ",string ns;` sv' ns,/:system"v ",string ns]}[isNS;subNS];
  nsfv:{[isNS;nsf;nsv;ns] {x@iasc lower x}raze (nsf;nsv)@\:ns}[isNS;nsf;nsv];
  getall:{[isNS;nsfv;ns] if[not isNS ns;:`]; ns,raze raze over'{[nsfv;ns] ns,.z.s[nsfv;]each nsfv ns}[nsfv;ns]}[isNS;nsfv];
  string (distinct raze getall each {` sv`,x}each key`)except `
  };

.color.TYPES:(!) . flip 2 cut
  (
  1h;  `BOOL;
  4h;  `BYTE;
  5h;  `SHORT;
  6h;  `INT;
  7h;  `LONG;
  8h;  `REAL;
  9h;  `FLOAT;
  10h; `STRING;
  11h; `SYMBOL;
  12h; `TIMESPAN;
  13h; `MONTH;
  14h; `DATE;
  15h; `DATETIME;
  16h; `TIMESTAMP;
  17h; `MINUTE;
  18h; `SECOND;
  19h; `TIME
  );

.color.load:{[scheme]
  t:read0 hsym `$getenv[`QREMOTE_HOME],"/csv/schemes.csv";
  cc:count ","vs first t;
  .color.schemes:(cc#"S";enlist",")0:t;
  if[not scheme in cols .color.schemes; 'string[scheme]," scheme not found"];
  .color.TOKEN_MAP:0#.color.TOKEN_MAP;
  .color.scheme:(!). .color.schemes[`TYPE,scheme];
  .color.TYPE_MAP:.color.scheme .color.TYPES;
  {.color.TOKEN_MAP,:flip `token`color!(.color x;.color.scheme x)} each `QSQL`OPERATORS`TABLECHARS`SPLITS`NSPACE`KEYWORDS;
  };

.color.try2token:{@[-4!;x;y]};
.color.color4keyword:{.color.TOKEN_MAP[x;`color]};
.color.color4type:{@[x;where null x;:;{@[{.color.TYPE_MAP abs type parse x};x;`DEFAULT]}each y where null x]};
.color.tagit:{$[y~".special.k";.color.KPROMPT;y sv .color.COLOR_CODES[x,`DEFAULT]]};
.color.specialtag:{[clrs;splt;clr;str] $[all null id:where null clrs;clrs;@[clrs;where str~/:{@[first;x;0b]}each splt;:;clr]]};
.color.off:{system"x .z.pi";};
.color.on:{`.z.pi set .color.zpi;};
.color.reloadnsvars:{[h] .color.NSPACE:h(.color.nsvars;());.color.TOKEN_MAP,:flip `token`color!(.color.NSPACE;.color.scheme`NSPACE)};

.color.tokenover:{.color.try2token[x;{[d;e] count d}[x;]]};
.color.tokenise:{[x]
  if[0b~split:.color.try2token[x;0b];
    split:.color.tokenover each (-2_2+til count x)#\:x;
    pre:split@(a:first where -7h=type each split)-1;
    split:pre,enlist(0^a+1)_x;
    ];
  :split
  };
.color.colorise:{[x]
  raw:ssr[-1_x;"k)";".special.k "];
  split:$[0b~split:.color.try2token[raw;0b]; 
    raze -1_(.color.tokenise each "\n"vs raw),\:enlist"\n";
    split
    ];
  colors:.color.color4keyword each split;
  colors:.color.color4type[colors;split];
  colors:.color.specialtag[colors;split;.color.scheme`SPECIAL;"`"];
  res:.color.tagit ./:flip(colors;split);
  -1 raze res;
  };

.color.zpi:{[x]
  x:-1_x;
  r:value x;
  if[r~(::); :r];
  @[.color.colorise;.Q.s r;{[x;y] 1 x;}.Q.s r];
  };

.color.preview:{[x] 
  -1@$[null x;
    {.color.tagit[x;string[x]," -- ", 2_y]}'[key .color.COLOR_CODES;value .color.COLOR_CODES];
    .color.tagit ./:flip (::;string)@'.color.schemes[x,`TYPE]
    ];
  };
  
.color.init:{[]
  .color.NSPACE:.color.nsvars[];
  .color.KEYWORDS:string (.Q.res union 1_key .q) except `$.color.QSQL;
  .color.COLOR_CODES:"\033[",/:(!).("S*";",")0:hsym `$getenv[`QREMOTE_HOME],"/csv/colors.csv";
  .color.KPROMPT:"k)"sv .color.COLOR_CODES`KPROMPT`ENDC;
  .color.load`qremote;
  .color.on[];
  };

