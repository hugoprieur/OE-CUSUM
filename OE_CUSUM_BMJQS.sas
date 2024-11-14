/*



O-E CUSUM GRAPH SAS Code v1.0, 11/10/2024
This code is also available in the appendix of the original manuscript

Draws the O-E CUSUM graph of a given dataset of procedures into a png file.



Inputs :
> CUSUM Parameters
> Table of procedures including the following variables :
	- Number of the procedure in the dataset
	- Expected probability of event
	- Observed event

Output :
> png file of a O-E CUSUM graph



Summary :
> Parameters
	CUSUM parameters for the detection of signals and output parameters, including path, name and size of the output file
> Sample data
	A table of simulated data is provided for testing the code.
> O-E, CUSUM scores and signals
	Calculation of the observed minus expected values, CUSUM scores, and CUSUM signals of improvement or deterioration
> Annomac tables
	Creation of datasets for the different graphic elements that will be drawn by the annotate procedure
> Graph file output



*/





/* -------------------------------- */
/* ---------- Parameters ---------- */
/* -------------------------------- */



/* --- CUSUM parameters --- */

%LET R0 = 1;
%LET RA_X = 2;		/* RA for deterioration signals */
%LET RA_Z = 1/2;	/* RA for improvement signals */
%LET LIM_X = 1.6;	/* CUSUM limit for deterioration signals */
%LET LIM_Z = -1.5;	/* CUSUM limit for improvement signals */



/* --- Output --- */

%LET PNG_PATH = C:\folder\O-E_CUSUM.png; /* Path to the png file to create */
%LET XPX = 1920; 		/* Width of the picture (graph + labels) (pixels) */
%LET YPX = 680; 		/* Height of the picture (graph + labels) (pixels) */
%LET LINESIZE = 0.3;	/* Lines base width */
%LET FONTSIZE = 3; 		/* Size of the tick labels */
%LET X_INTERVAL = 10;	/* Interval between 2 ticks on the x-axis */
%LET Y_INTERVAL = 2;	/* Interval between 2 ticks on the y-axis */
/* Colors (format : "CX" & hexadecimal) */
%LET CX_AXIS	= CX8B9AAB;
%LET CX_STD		= CX8B9AAB;
%LET CX_SEQX	= CXFF3030;
%LET CX_SEQZ	= CX14B700;
%LET CX_SEQX_L	= CXFFEAEA;
%LET CX_SEQZ_L	= CXEAFFEA;
%LET CX_AXIS_L	= CXF5F5F5;





/* --------------------------------- */
/* ---------- Sample data ---------- */
/* --------------------------------- */





data base;
	input n pred evt;
	datalines;
1 0.218324376 0
2 0.000756346 0
3 0.000003651 0
4 0.004897523 0
5 0.000259069 0
6 0.271548888 0
7 0.168342343 1
8 0.000553514 0
9 0.022767651 0
10 0.00001497 0
11 0.65536515 1
12 0.38359939 1
13 0.52092919 1
14 0.96276556 1
15 0.00333328 0
16 0.99551418 1
17 0.00000065 0
18 0.56107034 0
19 0.29265058 1
20 0.00051051 0
21 0.00000098 0
22 0.96527270 1
23 0.01761614 0
24 0.64638632 1
25 0.23484585 0
26 0.96729063 1
27 0.94647897 1
28 0.00000327 0
29 0.00001233 0
30 0.55219308 1
31 0.85178232 1
32 0.90062453 1
33 0.18860821 0
34 0.02508199 0
35 0.14915877 0
36 0.00353451 0
37 0.32154201 0
38 0.00114298 0
39 0.00005086 0
40 0.00000534 0
41 0.00000234 0
42 0.99025254 1
43 0.07440102 0
44 0.98671174 1
45 0.74435805 1
46 0.26070163 0
47 0.00004238 0
48 0.92010631 1
49 0.83979927 1
50 0.00026351 0
51 0.00106049 0
52 0.23718294 0
53 0.56763473 1
54 0.01243145 0
55 0.01104642 0
56 0.00000163 0
57 0.58087298 0
58 0.11157097 1
59 0.99433715 1
60 0.63178705 0
61 0.40258098 0
62 0.07778404 0
63 0.27430608 0
64 0.04810524 0
65 0.00018669 0
66 0.15107899 0
67 0.54245928 1
68 0.84487540 1
69 0.37220112 1
70 0.14293314 0
71 0.05222025 0
72 0.22778525 0
73 0.02712744 0
74 0.12785133 0
75 0.88084493 0
76 0.05020076 0
77 0.06987377 0
78 0.02454716 0
79 0.98359869 1
80 0.00761436 0
81 0.97979134 1
82 0.29090464 0
83 0.00819029 0
84 0.00002407 0
85 0.00963778 0
86 0.00009441 0
87 0.19495348 0
88 0.33855396 0
89 0.01346008 0
90 0.00000801 0
91 0.00069185 0
92 0.00000119 0
93 0.52311713 1
94 0.00348021 0
95 0.80765306 0
96 0.00002071 0
97 0.03329127 0
98 0.04994371 0
99 0.17862950 0
100 0.8395834 1
101 0.6986946 1
102 0.0000006 0
103 0.0001226 0
104 0.3073143 0
105 0.1713220 0
106 0.9300953 1
107 0.9444526 1
108 0.0000001 0
109 0.0002982 0
110 0.2309132 0
111 0.0000708 0
112 0.2516242 0
113 0.0000005 0
114 0.9905170 1
115 0.0780732 0
116 0.0014393 0
117 0.9938476 1
118 0.0093629 0
119 0.8780204 1
120 0.9741164 1
121 0.0000922 0
122 0.0000808 0
123 0.9962916 1
124 0.0066511 0
125 0.0832514 0
126 0.0679356 0
127 0.0000044 0
128 0.4551175 1
129 0.1738783 0
130 0.0000248 0
131 0.0074039 0
132 0.0519059 0
133 0.0145781 0
134 0.9752933 1
135 0.0000024 0
136 0.6220216 1
137 0.8291508 1
138 0.0000173 0
139 0.0001830 0
140 0.0000020 0
141 0.7536943 1
142 0.0000007 0
143 0.9406913 1
144 0.0017504 0
145 0.7094722 1
146 0.0001033 0
147 0.4541259 1
148 0.2601301 0
149 0.0002826 0
150 0.5896005 1
;
run;





/* --------------------------------------------------- */
/* ---------- O-E, CUSUM scores and signals ---------- */
/* --------------------------------------------------- */



/* --- Calculating observed minus expected, CUSUM scores and CUSUM signals */

data cc (keep = n evt pred x z oe signal);
	set base (where = (evt ne . and pred ne .));
	retain x 0 z 0 oe 0; /* x : CUSUM deterioration score, z : CUSUM improvement score, oe : observed minus expected */
	signal = " "; /* "x" if the procedure triggers a deterioration signal, "z" if it triggers an improvement signal, else empty */
	/* Resetting both CUSUM scores after a signal (sequences cannot overlap) */
	if x > &LIM_X. or z < &LIM_Z. then do;
		x = 0;
		z = 0;
	end;
	/* Calculating the observed minus expected */
	oe = oe + evt - pred;
	/* Calculating both CUSUM scores in the case of an event */
	if evt = 1 then do;
		w_x1 = log( (1 - pred + &R0 * pred) * &RA_X / (1 - pred + &RA_X * pred) / &R0 );
		w_z1 = log( (1 - pred + &R0 * pred) * &RA_Z / (1 - pred + &RA_Z * pred) / &R0 );
		x = max(0, x + w_x1);
		z = min(0, z - w_z1);
	end;
	/* Calculating both CUSUM scores in the case of no event */
	if evt = 0 then do;
		w_x0 = log( (1 - pred + &R0 * pred) / (1 - pred + &RA_X * pred) );
		w_z0 = log( (1 - pred + &R0 * pred) / (1 - pred + &RA_Z * pred) );
		x = max(0, x + w_x0);
		z = min(0, z - w_z0);
	end;
	/* CUSUM signal triggers */
	if x > &LIM_X. then signal = "x";
	if z < &LIM_Z. then signal = "z";
run;



/* --- Identifying CUSUM sequences : groups of consecutive procedures that lead to a signal --- */
/* Sequences start at the last procedure whose CUSUM score was 0, and end at the procedure that signalled */
/* All procedures are divided into groups : each sequence is a group, then all procedures between two given sequences form groups */

proc sort data = cc; /* The dataset has to be sorted in reverse for the next data step */
	by descending n;
run;
data cc;
	set cc;
	retain group 1 group_type "stand"; /* group : id number of the group ; group_type = "stand" (no sequence), "seq_x" (deterioration sequence) or "seq_z" (improvement sequence) */
	/* If we reach the start of a sequence, we start a new group ; it is assumed not to be a sequence, but this might change on the last 2 "if" blocks */
	/* Note that we are reading the dataset in reverse order, so the first procedure of a sequence is the last one we read */
	if x = 0 and group_type = "seq_x" then do;
		group = group + 1;
		group_type = "stand";
	end;
	if z = 0 and group_type = "seq_z" then do;
		group = group + 1;
		group_type = "stand";
	end;
	/* End of a sequence -> new group (note that this is the first procedure we read from this sequence) */
	if signal = "x" then do;
		group = group + 1;
		group_type = "seq_x";
	end;
	if signal = "z" then do;
		group = group + 1;
		group_type = "seq_z";
	end;
run;
proc sort data = cc; /* Going back to chronological order */
	by n;
run;



/* --- Calculating the observed minus expected value within a sequence, and storing the procedure the sequence starts at --- */

data cc (drop = lag_n);
	set cc;
	retain group_oe . n_seq_start . lag_n .; /* group_oe : progression of the O-E during the sequence, n_seq_start : first procedure of the sequence, lag_n : previous procedure */
	/* Start of a sequence */
	if group_type in ("seq_x" "seq_z") and group ne lag(group) then do;
		group_oe = oe - (evt - pred); /* Storing the last O-E value before the sequence */
		n_seq_start = lag_n; /* Id of the previous procedure */
		if _n_ = 1 then do; /* In case of a sequence starting at the first procedure */
			group_oe = 0;
			n_seq_start = 0;
		end;
	end;
	/* End of a sequence */
	if signal ne " " then group_oe = int(oe - group_oe); /* group_oe was set at the O-E value at the start of the sequence */
	/* No sequence -> resetting the values */
	if group_type = "stand" then do;
		group_oe = .;
		n_seq_start = .;
	end;
	/* Updating lag_n */
	lag_n = n;
run;





/* ------------------------------------ */
/* ---------- Annomac tables ---------- */
/* ------------------------------------ */



/* --- Prerequisites --- */

%annomac;

/* Format for the O-E values within sequences */
proc format;
	picture signe
	low - < 0 = '000'(prefix = '-')
	0 = '0'
	0 < - high = '000' (prefix = '+');
run;



/* --- Axis --- */

/* Calculating the x-axis end value */
data _null_;
	set cc;
	call symput("N_MAX", _n_);
run;

/* Calculating the y-axis end values */
data _null_;
	set cc;
	retain oe_max 0;
	if oe >=0 then oe_max = max(oe_max, oe * 1.5); /* We add some room on top of the curve... */
	if oe < 0 then oe_max = max(oe_max, oe *-2.5); /* ... and more room below it (accounting for the O-E value circles) */
	call symput("OE_MAX", put(round(oe_max, &Y_INTERVAL.), 3.)); /* Rounding to the nearest interval */
run;

/* Using annomac macros */
data axis;
	format color $8. function $8. style $12. text $39. position $1.;
	retain hsys xsys ysys '5';
	/* Y-axis */
	%line(9, 13, 9, 99, &CX_AXIS., 1, &LINESIZE.); /* Left line of the graph box */
	%MACRO Y_TL(); /* Ticks and labels */
		%DO I = - &OE_MAX. %TO &OE_MAX. %BY &Y_INTERVAL.;
			%LET HEIGHT = %SYSEVALF(&I. / &OE_MAX. * 86 / 2 + 56); /* Y-coordinate of the tick */
			%line(8.5, &HEIGHT., 9, &HEIGHT., &CX_AXIS., 1, &LINESIZE.); /* Tick */
			%label(8, &HEIGHT., "&I.", &CX_AXIS., 0, 0, &FONTSIZE., verdana, <); /* Label */
		%END;
	%MEND;
	%Y_TL();
	/* X-axis */
	%line( 9, 56, 99, 56, &CX_AXIS_L.,	1, &LINESIZE.); /* Horizontal line at the middle of the graph box */
	%line( 9, 13, 99, 13, &CX_AXIS.,	1, &LINESIZE.); /* Bottom line of the graph box */
	%MACRO X_TL(); /* Ticks and labels */
		%LET NTICKS = %SYSFUNC(int(&N_MAX. / &X_INTERVAL.)); /* Number of ticks */
		%DO I = 0 %TO &NTICKS.;
			%LET LABEL = %SYSEVALF(&I. * &X_INTERVAL.);
			%LET COORD = %SYSEVALF(&LABEL. / &N_MAX. * 90 + 9); /* X-coordinate of the tick */
			%line(&COORD., 11, &COORD., 13, &CX_AXIS., 1, &LINESIZE.); /* Tick */
			%label(&COORD., 9, "&LABEL.",  &CX_AXIS., 0, 0, &FONTSIZE., verdana, +); /* Label */
		%END;
	%MEND;
	%X_TL();
	/* Closing the graph box */
	%line( 9, 99, 99, 99, &CX_AXIS., 1, &LINESIZE.); /* Top line of the graph box */
	%line(99, 13, 99, 99, &CX_AXIS., 1, &LINESIZE.); /* Right line of the graph box */
	/* Axis labels */
	%label(3, 56, "Cumulative Observed minus Expected", &CX_AXIS., 90, 0, 4, verdana, +);
	%label(54, 3, "Number of procedures", &CX_AXIS., 0, 0, 4, verdana, +);
run;



/* --- O-E curve --- */

/* Calculating the coordinates of each point of the curve, which will be used for several graphic elements */
data cc;
	set cc;
	x_coord = n / &N_MAX. * 90 + 9;
	y_coord = oe / &OE_MAX. * 86 / 2 + 56;
run;
/* Writing the annomac table from data */
data curve (keep = hsys xsys ysys color x y function line size);
	format color $8. function $8.;
	retain hsys xsys ysys '5' line 1 size &LINESIZE.;
	if _n_ = 1 then do; /* Zero point */
		function = "MOVE";
		x = 9;
		y = 56;
		output;
	end;
	set cc (drop = x z);
	function = "DRAW";
	x = x_coord;
	y = y_coord;
	/* Color depending on the sequence type */
	if group_type = "seq_x" then color = "&CX_SEQX.";
	if group_type = "seq_z" then color = "&CX_SEQZ.";
	if group_type = "stand" then color = "&CX_STD.";
	output;
run;



/* --- Strips showcasing sequences --- */

/* Writing the annomac table from data */
/* Each strip is a polygon delimited horizontally by the start and the end of a sequence and vertically by the O-E curve and the bottom of the graph */
/* The polygons start at their {left, bottom} point then end at their {right, bottom} point */
data strips (keep = hsys xsys ysys color x y function line style);
	format color $8. function $8. style $12.;
	retain hsys xsys ysys '5' line 1 style "msolid" lag_x_coord lag_y_coord;
	set cc (drop = x z);
	/* Strip color depending on the sequence type */
	if group_type = "seq_x" then color = "&CX_SEQX_L.";
	if group_type = "seq_z" then color = "&CX_SEQZ_L.";
	/* First procedure of a sequence */
	if group_type in ("seq_x" "seq_z") and group ne lag(group) then do;
		/* First point : {left, bottom} */
		function = "poly";
		x = lag_x_coord; /* The interval between the first procedure in a sequence and the procedure before it is considered a part of the sequence */
		y = 13;
		if x = . then x = 9; /* In case the sequence starts at the zero-point */
		output;
		/* Second point : {left, top} */
		function = "polycont";
		x = lag_x_coord;
		y = lag_y_coord;
		if x = . then do; /* In case the sequence starts at the zero-point */
			x = 9;
			y = 56;
		end;
		output;
	end;
	/* procedure within a sequence */
	if group_type in ("seq_x" "seq_z") and signal = " " then do;
		/* Points along the O-E curve : {*, top} */
		function = "polycont";
		x = x_coord;
		y = y_coord;
		output;
	end;
	/* Last procedure of a sequence */
	if signal ne " " then do;
		/* Second-last point : {right, top} */
		function = "polycont";
		x = x_coord;
		y = y_coord;
		output;
		/* Last point : {right, bottom} */
		function = "polycont";
		x = x_coord;
		y = 13;
		output;
	end;
	/* Retaining the coordinates for the next procedure */
	lag_x_coord = x_coord;
	lag_y_coord = y_coord;
run;

/* Adding the white lines that separate adjacent sequences */
data wlines (keep = hsys xsys ysys color x y function line style size);
	format color $8. function $8. style $12.;
	retain hsys xsys ysys '5' line 1 style "msolid" lag_x_coord 2;
	set cc (drop = x z);
	/* We draw a line if the last procedure and the current one belong in two different sequences */
	if group_type in ("seq_x" "seq_z") and lag(group_type) in ("seq_x" "seq_z") and group ne lag(group) then do;
		/* Start of the line */
		function = "MOVE";
		size = &LINESIZE. * 2;
		x = (x_coord + lag_x_coord) / 2;
		y = 99;
		color = "white";
		output;
		/* End of the line */
		function = "DRAW";
		size = &LINESIZE. * 2;
		x = (x_coord + lag_x_coord) / 2;
		y = 13;
		color = "white";
		output;
	end;
	/* Retaining the coordinates for the next procedure */
	lag_x_coord = x_coord;
run;



/* --- Circles displaying the O-E within sequences --- */

/* Calculating the coordinates of the circles */
data cc;
	set cc;
	/* Coordinates are stored on the last sequence of each procedure */
	if signal ne " " then do;
		coord_x_sig = (n + n_seq_start) / 2 / &N_MAX. * 90 + 9; /* Middle of the sequence */
		coord_y_sig = 21;
	end;
run;

/* Circles : writing the annomac table from data */
data circles (keep = hsys xsys ysys color x y function line style size angle rotate);
	format color $8. function $8. style $12.;
	retain hsys xsys ysys '5' line 1 style "psolid" function "pie" angle 360 rotate 360;
	set cc (drop = x z where = (coord_y_sig ne .));
	x = coord_x_sig;
	y = coord_y_sig;
	/* Outline of the circles (actually bigger circles) */
	if signal = "x" then color = "&CX_SEQX_L.";
	if signal = "z" then color = "&CX_SEQZ_L.";
	size = 5;
	output;
	/* Inside of the circles (white, smaller circles) */
	color = "white";
	size = 4;
	output;
run;

/* O-E values : writing the annomac table from data */
data oe_values (keep = hsys xsys ysys color x y function style size angle rotate text position);
	format color $8. function $8. style $12. text $39.;
	retain hsys xsys ysys '5' line 1 style "verdana" function "label" size 4 angle 0 rotate 0 position "+";
	set cc (drop = x z where = (coord_y_sig ne .));
	x = coord_x_sig;
	y = coord_y_sig;
	if group_type = "seq_x" then color = "&CX_SEQX.";
	if group_type = "seq_z" then color = "&CX_SEQZ.";
	text = compress(put(group_oe, signe.));
run;



/* --- Final annomac table --- */

/* Concatenating annomac tables, background to foreground */
data graph;
	set strips
		wlines
		circles
		oe_values
		axis
		curve;
run;





/* --------------------------------------- */
/* ---------- Graph file output ---------- */
/* --------------------------------------- */



filename pngname "&PNG_PATH.";
goptions device = png xpixels = &XPX. ypixels = &YPX. gsfmode = replace gsfname = pngname;
proc ganno annotate = graph;
run;
quit;
