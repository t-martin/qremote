
opts:first each .Q.opt .z.x

usage:{ -1" 
  Generates an autocomplete dictinoary file to be used with rlwrap
  
  q autocomplete.q [-echo] [-connection h:p:u:pw] [-outputdir D] [-outputfile F]
 
  options:
       -echo: echo the full path to the created dictionary file. To be used with -q to catch output inside shell scripts
       -connection: used to generate dict from a remote q process. Takes IPC connection details (host/port/user/password) as argument
       -outputdir: override the output directory where dictionary file is stored. If not specified, $HOME/.kdb-autocomplete/ will be used
       -outputfile: if not specified, file is saved as $outputdir/kdb-autocomplete, otherwise saved as $outputdir/$outputfile
       -help: print this message
 
  then:
       rlwrap -c -f $outputdir/$outputfile q \"$@\"
  ";
  };

get_ns_vars:{[]
  isNS:{if[not count key x;:0b];if[any x~/:``.;:1b];$[99h=type v:value x;(1#v)~enlist[`]!enlist(::);0b]};
  nsf:{[isNS;ns] if[not isNS ns;:`$()];$[any ns~``.;system"f ",string ns;` sv'ns,/:system"f ",string ns]}[isNS];
  subNS:{[isNS;ns] $[not isNS ns;`$(); 1_key ns]}[isNS];
  nsv:{[isNS;subNS;ns] if[not isNS ns;:`$()]; $[any ns~/:``.;(` sv' `,/:subNS`),system"v ",string ns;` sv' ns,/:system"v ",string ns]}[isNS;subNS];
  nsfv:{[isNS;nsf;nsv;ns] {x@iasc lower x}raze (nsf;nsv)@\:ns}[isNS;nsf;nsv];
  getall:{[isNS;nsfv;ns] if[not isNS ns;:`]; ns,raze raze over'{[nsfv;ns] ns,.z.s[nsfv;]each nsfv ns}[nsfv;ns]}[isNS;nsfv];
  (distinct raze getall each {` sv`,x}each key`)except `
  };

get_all:{[h]
  res:h".Q.res";
  qv:1_key .q;
  nsv:h(get_ns_vars;());
  root:(union/)h@/:system,/:"avbf";
  string (union/)(res;qv;nsv;root;`from`by)
  };

save_all:{[h]
  dir:$[`outputdir in key opts;opts`outputdir;getenv[`HOME],"/.kdb-autocomplete"],"/";
  fn:dir,$[`outputfile in key opts;opts`outputfile;"kdb-autocomplete"];
  hsym[`$fn] 0: get_all h;
  if[`echo in key opts;-1 fn];
  };

save_local:{save_all 0}

save_remote:{save_all h:hopen hsym `$opts`connection; hclose h};

main:{[] $[`help in key opts;[usage[];exit 1]; `connection in key opts;save_remote[]; save_local[]]};

@[main;();{-2 "Error generating autocomplete dictionary: ",x; exit 1}];

exit 0;
