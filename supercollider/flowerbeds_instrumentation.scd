
//-------------------------------------------------------------------------------------
// THE FLOWERS THAT SPORADICALLY POP UP
//-------------------------------------------------------------------------------------
// GROUPS
//-------------------------------------------------------------------------------------
~cloudSource = Group.new();
~cloudEffect = Group.new(target: ~cloudSource, addAction: \addAfter);

~vineSource = Group.new();
~vineEffect = Group.new(target: ~vineSource, addAction: \addAfter);

m = NetAddr("localhost", 57123);

//-------------------------------------------------------------------------------------
// THE FLOWERS THAT SPORADICALLY POP UP
//-------------------------------------------------------------------------------------
// CLOUDS
//-------------------------------------------------------------------------------------

(
SynthDef.new(
	name: \clouds,
	ugenGraphFunc: {
		arg freq = 440, modspeed = 1, atk = 0.005, rel=0.3, amp=1, pan=0;
		var sig, env, freqmod, filterctl;
		freqmod = SinOsc.kr(
			freq: modspeed,
			mul: freq/40,
			add: freq);
		sig = LFTri.ar(
			freq: freqmod);
		env = EnvGen.kr(
			envelope: Env.sine(dur: rel),
			doneAction: 2);
		sig = Pan2 .ar(
			in: sig,
			pos: pan,
			level: amp);
		filterctl = XLine.kr(1000, 20000, rel);
		sig = LPF.ar(
			in: sig,
			freq: filterctl);
		sig = sig * env*0.3;
		Out.ar(0, sig);
}).add;
);

SynthDef(name: \aglitch,
	ugenGraphFunc: {
		arg speed, depth;
		var in, cutwave, lag, env;
		in = In.ar(
			bus: 0, numChannels: 2);
		cutwave = LFPulse.ar(
			freq: speed,
			width: 0.95,
			mul: depth);
		env = EnvGen.ar(
			envelope: Env.new([1, 0.001, 1], [0.01, 0.01], curve: 'sin'),
			doneAction: 2);
		lag = Lag.ar(
			in: env).range(0,1);
		ReplaceOut.ar(
			bus: 0,
			channelsArray: env * in *0.3);
}).add;


//-------------------------------------------------------------------------------------
// THE FLOWERS THAT SPORADICALLY POP UP
//-------------------------------------------------------------------------------------
// VINES
//-------------------------------------------------------------------------------------

(
SynthDef(
	name: \vine,
	ugenGraphFunc: {
		arg freq = 100, amp = 0.5, rel = 0.02, maxHarmonics = 40, sinpan = 1;
		var noise, blip, env, pan, sinosc, x, rev, del, mix;
		noise = LFNoise1.ar(
			freq: 2,
			mul: freq * 0.01,
			add: freq);
		blip = Blip.ar(
			freq: noise,
			numharm: Rand(20, maxHarmonics));
		env = EnvGen.ar(
			envelope: Env.perc(
				attackTime:0.008,
				releaseTime: rel),
			doneAction: 2);
		x = blip * env;
		pan = Pan2.ar(
			in: x,
			pos: PinkNoise.kr(mul: sinpan));
		del = CombN.ar(
			in: pan,
			maxdelaytime: 0.05,
			delaytime: 0.01);
		rev = FreeVerb.ar(
			in: del*SinOsc.ar(200);,
			mix: 0.5,
			room: 0.5);
		mix = Mix.ar([rev, pan]);
		Out.ar(0, mix*amp*0.3);
	}
).add;
);

//-------------------------------------------------------------------------------------
// THE FLOWERS THAT RANDOMLY POP UP
//-------------------------------------------------------------------------------------
// DAISIES (CIRCLES)
//-------------------------------------------------------------------------------------

(
SynthDef.new(
	name: \daisy,
	ugenGraphFunc: {
		arg freq = 440, atk = 0.005, rel=0.3, amp=1, pan=0;
		var sig, env, freqdev;
		sig = SinOsc.ar(
			freq: freq + (PinkNoise.kr()*10*freq/440);
		);
		env = EnvGen.kr(
			envelope: Env.new(
				levels: [0, 1, 0],
				times: [atk, rel],
				curve: [1, -1]),
			doneAction: 2);
		sig = Pan2 .ar(
			in: sig,
			pos: pan,
			level: amp);
		sig = sig * env;


		Out.ar(0, sig *0.05);
}).add;
);

//-------------------------------------------------------------------------------------
// THE FLOWERS THAT RANDOMLY POP UP
//-------------------------------------------------------------------------------------
// BLIP
//-------------------------------------------------------------------------------------

(SynthDef(
	name: \blip,
	ugenGraphFunc: {
		arg amp = 1;
		var blip, env, pan1, pan2, sig, delay, panpos, mix;
		blip = Pulse.ar(
			freq: Rand(200, 800),
			width: PinkNoise.kr(0.5, 0.5));
		 blip = blip;
		env = EnvGen.ar(
			envelope: Env.perc(0.001, 0.1, 1,-10);,
			doneAction: 2);

		sig = blip * env;

		panpos = LFNoise0.ar(freq: 10);

		pan1 = Pan2.ar(
			in: sig,
			pos: panpos);
		Out.ar(0, pan1 * amp);
	}
).add;);

