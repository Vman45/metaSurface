declare name "compressorFaust";
declare version "0.0";
declare author "JOS, revised by RM";
declare description "Compressor demo application";

ma = library("maths.lib");
ba = library("basics.lib");
de = library("delays.lib");
si = library("signals.lib");
an = library("analyzers.lib");
fi = library("filters.lib");
os = library("oscillators.lib");
no = library("noises.lib");
ef = library("misceffects.lib");
co = library("compressors.lib");
ve = library("vaeffects.lib");
pf = library("phaflangers.lib");
re = library("reverbs.lib");
en = library("envelopes.lib");
//----------------------------`(dm.)compressor_mono`-------------------------
// Compressor demo application.
//
// #### Usage
//
// ```
// _: compressor_demo : _;
// ```
//------------------------------------------------------------

compressor = co.compressor_mono(ratio,threshold,attack,release) :*(makeupgain)
with{
	comp_group(x) = vgroup("COMPRESSOR [tooltip: Reference:
		http://en.wikipedia.org/wiki/Dynamic_range_compression]", x);

	meter_group(x)	= comp_group(hgroup("[0]", x));
	knob_group(x)  = comp_group(hgroup("[1]", x));

	ctl_group(x)  = knob_group(hgroup("[3] Compression Control", x));

	ratio = ctl_group(hslider("[0] Ratio [style:knob]
	[tooltip: A compression Ratio of N means that for each N dB increase in input
	signal level above Threshold, the output level goes up 1 dB]",
	5, 1, 20, 0.1));

	threshold = ctl_group(hslider("[1] Threshold [unit:dB] [style:knob]
	[tooltip: When the signal level exceeds the Threshold (in dB), its level
	is compressed according to the Ratio]",
	-30, -100, 10, 0.1));

	env_group(x)  = knob_group(hgroup("[4] Compression Response", x));

	attack = env_group(hslider("[1] Attack [unit:ms] [style:knob] [scale:log]
	[tooltip: Time constant in ms (1/e smoothing time) for the compression gain
	to approach (exponentially) a new lower target level (the compression
	`kicking in')]", 50, 1, 1000, 0.1)) : *(0.001) : max(1/ma.SR);

	release = env_group(hslider("[2] Release [unit:ms] [style: knob] [scale:log]
	[tooltip: Time constant in ms (1/e smoothing time) for the compression gain
	to approach (exponentially) a new higher target level (the compression
	'releasing')]", 500, 1, 1000, 0.1)) : *(0.001) : max(1/ma.SR);

	makeupgain = comp_group(hslider("[5] Makeup Gain [unit:dB]
	[tooltip: The compressed-signal output level is increased by this amount
	(in dB) to make up for the level lost due to compression]",
	1, -96, 96, 0.1)) : ba.db2linear;
};
process = _: compressor: _;
