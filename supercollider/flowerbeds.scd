m = NetAddr("localhost",  57121);
n = NetAddr("localhost", 57122);


//-------------------------------------------------------------------------------------
// THE SWIRLING FLOWER AT THE CENTER
//-------------------------------------------------------------------------------------
(SynthDef(
	name: \centerSwirl,
	ugenGraphFunc: {
		arg midinote = 35, amp = 0.15, cutoff = 400, panpos = 0;
		var osc, filter, pan, sig, freqmod, ampmod;
		ampmod = SinOsc.kr(
			freq: 2,
			mul: 0.02,
			add: -0.02);
		freqmod = SinOsc.kr(
			freq: 0.3);
		osc = LFTri.ar(
			freq: midinote.midicps + freqmod);
		filter = LPF.ar(
			in: osc,
			freq: cutoff);
		pan = Pan2.ar(
			in: filter,
			pos: panpos);
		sig = pan * (amp);
		Out.ar(0, sig);
	}
).add;)

//start the centerSwirl
(~swirl = Synth(\centerSwirl);
m.sendMsg("/drawSwirl", true);
~changeSwirlSizeFunc.value(0.5)
)

//invert swirl colors
// WARNING THIS FUCKS EVERYTHING UP BUT IT ALSO LOOKS KINDA COOL
(m.sendMsg("/clearfbo", true);)


//increase centerSwirlsize + amplitude
//this needs a more continuous way of changing amplitude
(~changeSwirlSizeFunc = {
arg newAmplitude = 0.7;
m.sendMsg("/changeSwirlSize", 0.7 );
~swirl.set(\amp, newAmplitude);
~swirl.set(\cutoff, newAmplitude.linexp(0.0001, 1, 200, 1000));})

~changeSwirlSizeFunc.value(1);

//stop the centerSwirl
(~swirl.free;
m.sendMsg("/drawSwirl", false);)

(SynthDef(
	name: \blip,
	ugenGraphFunc: {
		arg amp = 0.3;
		var blip, env, pan1, pan2, sig, delay, panpos, mix;
		blip = Pulse.ar(
			freq: 400,
			width: 0.5);
		env = EnvGen.ar(
			envelope: Env.perc(0.01, 0.05);,
			doneAction: 2);

		sig = blip * env;

		panpos = LFNoise0.ar(freq: 10);

		pan1 = Pan2.ar(
			in: sig,
			pos: panpos);
		Out.ar(0, pan1 * amp);
	}
).add;)

OSCdef.new(\unstable, { arg msg; Synth(\blip);}, '/blip');

//-------------------------------------------------------------------------------------
// THE FLOWERS THAT RANDOMLY POP UP
//-------------------------------------------------------------------------------------
// DAISIES (CIRCLES)
//-------------------------------------------------------------------------------------

(
SynthDef.new(
	name: \sine,
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


		Out.ar(0, sig);
}).add;
)

//vibrato at 17 hz

(~sinepat = Pbind(
	\instrument, \sine,
	//try different permutations of this
	\dur, Pseq([0.1, 0.2, 0.3, 0.2, 0.1], inf),
	\midinote, Pseq([60, 64, 67, 60].scramble -12, inf),
	\harmonic, Pexprand(1, 2, inf).round,
	\atk, Pwhite(0.001, 0.003, inf),
	\rel, Pwhite(0.05, 0.05, inf),
	\amp, Pkey(\harmonic).reciprocal * 0.3,
	\pan, Pwhite(-0.8, 0.8, inf),

	\bla, Pfunc { arg in; m.sendMsg("/daisy", in[\harmonic], in[\amp], in[\pan]) },
);

p = Pdef(
	\sinepat, ~sinepat
).play;
)

m.sendMsg("/setMaxNumFlowers", 2);

//-------------------------------------------------------------------------------------
// THE FLOWERS THAT RANDOMLY POP UP
//-------------------------------------------------------------------------------------
// LILIES (TRIANGLE SHAPE)
//-------------------------------------------------------------------------------------
(
SynthDef.new(
	name: \lily,
	ugenGraphFunc: {
		arg freq = 440, atk = 0.005, rel=0.3, amp=1, pan=0;
		var sig, env, noise;
		sig = LFTri.ar(freq);
		//sig = sig + sig*PinkNoise.ar(0.0025);
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

		sig = sig * env ;
		sig = Mix.ar([sig * env]);


		Out.ar(0, sig);
}).add;
)

(~lilypat = Pbind(
	\instrument, \lily,
	//try different permutations of this
	\dur, Pseq([0.1, 0.2, 0.3, 0.2, 0.1].scramble, inf),
	\midinote, 40,
	\harmonic, Pexprand(1, 40, inf).round,
	\atk, Pwhite(0.001, 0.01, inf),
	\rel, Pwhite(0.05, 0.1, inf),
	\amp, Pkey(\harmonic).reciprocal * 0.5,
	\pan, Pwhite(-0.8, 0.8, inf),

	\bla, Pfunc { arg in; m.sendMsg("/lily", in[\harmonic], in[\amp], in[\pan]) },
);

p = Pdef(
	\lilypat, ~lilypat,
).play;
)
p.stop;

