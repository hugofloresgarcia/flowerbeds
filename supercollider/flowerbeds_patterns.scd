~mainRhythm = [0.1, 0.2, 0.3, 0.2, 0.1];

//some chords to choose from

~cloudChord = [0, 2, 7, 14, 16, 21];

~openChord69 = [0, 4, 9, 14, 18];
~closedChord69 = [0, 12, 14, 16, 21];
~openChordmaj7 = [0, 7, 11, 16, 19];
~closedmaj7 = [0, 2, 4, 7, 11];

~chordPool = [~cloudChord, ~openChord69, ~closedChord69, ~openChordmaj7, ~closedmaj7];
~keyCenters = [36, 41];
// consonants are more rounded
// dissonance is less rounded
// add a second pattern in daisypat
// joy, blooming, springtime
// fm harmonic - inharmonic

 //dictionary of samples
// ~keyCenters = [36!8] ++ [32!4] ++ [43!4] ++ [34!2] ++ [39!1];

//-------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------

~cloudAmp = PatternProxy( (Pkey(\harmonic).reciprocal * 0.1););
~cloudDur = PatternProxy( Pseq([0.5]*2, inf));
~cloudHarmonics = PatternProxy(Pexprand(20, 40, inf).round);
~cloudModSpeed = PatternProxy(Pwhite(4, 8, inf));

~cloud4Chord = PatternProxy(Pseq((~cloudChord + 40).scramble, inf));
~cloud5Chord = PatternProxy(Pseq((~cloudChord + 33).scramble, inf));

(~cloud4 = Pbind(
	\instrument, \clouds,
	\addAction, 0,
	\group, ~cloudSource,
	\dur, ~cloudDur,
	\midinote, ~cloud4Chord,
	\harmonic, ~cloudHarmonics,
	\atk, Pwhite(1, 2, inf),
	\rel, Pwhite(3, 5, inf),
	\amp, ~cloudAmp,
	\pan, Pwhite(-0.8, 0.8, inf),
	\modspeed, ~cloudModSpeed,

	\drawOSC, Pfunc {m.sendMsg("/newSwirl", true);},
	\modOSC, Pfunc  {arg in; in[\modspeed]; m.sendMsg("/setSwirlSpeed", in[\modspeed]);}
););

(~cloud5 = Pbind(
	\instrument, \clouds,
	\addAction, 0,
	\group, ~cloudSource,
	\dur, ~cloudDur,
	\midinote, ~cloud5Chord,
	\harmonic, ~cloudHarmonics,
	\atk, Pwhite(1, 2, inf),
	\rel, Pwhite(3, 5, inf),
	\amp, ~cloudAmp,
	\pan, Pwhite(-0.8, 0.8, inf),
	\modspeed, ~cloudModSpeed,

	\drawOSC, Pfunc {m.sendMsg("/newSwirl", true);},
););

//-------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------

~tremRhythmicPattern = PatternProxy(Pseq(~mainRhythm*2), inf);
~tremCut = PatternProxy(Pwhite(0.125, 0.25));

~tremp = Pbind(
	\instrument, \aglitch,
	\group, ~cloudEffect,
	\addAction, 0,
	\dur, ~tremRhythmicPattern,
	// \group, ~cloudEffect,
	\speed, ~tremCut,
	\depth, 1,

	\sendBlip, Pfunc {arg in; m.sendMsg("/aGlitch", true, in[\speed]);},
);

//-------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------

~vineFreq = PatternProxy(Pexprand(10, 20, inf));
~vineMaxHarmonics = PatternProxy(Pexprand(1, 8, inf));
~vineAmp = PatternProxy(Pwhite(0.1, 0.2));
~vineDur = PatternProxy(Pwhite(0.3, 0.8, inf));
~vinePan = PatternProxy(Pwhite(-0.02, 0.02, inf));

~vineFunc = PatternProxy(Pfunc({arg in; m.sendMsg("/vine", 80)}));

(~vine = Pbind(
	\instrument, \vine,
	\dur, ~vineDur,
	\freq, ~vineFreq,
	\maxHarmonics, ~vineMaxHarmonics,
	\amp, ~vineAmp,
	\sinpan, ~vinePan,
	// \delta, ~vineDelta,

	\bla, Pfunc { arg in; m.sendMsg("/vine", 80) },
););

//-------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------

~coffeeStart = PatternProxy(Pwhite(0, ~coffee.numFrames, inf));
~coffeeLPF = PatternProxy(Pwhite(100, 20000, inf));
~coffeeHPF = PatternProxy(Pwhite(0, 14000, inf));
~coffeeAtk = PatternProxy(Pwhite(0.001, 0.1, inf));
~coffeeRel = PatternProxy(Pwhite(0.1, 1, inf));
~coffeeAmp = PatternProxy(Pwhite(0.009, 0.01, inf));
~coffeePan = PatternProxy(Pwhite(-1, 1, inf));
~coffeeDelay = PatternProxy(Pwhite(0, 1, inf));

(~coffeep = Pbind(
	\instrument, \playback,
	\dur, ~vineDur,
	\startPos, ~coffeeStart,
	\lpfcut, ~coffeeLPF,
	\hpfcut, ~coffeeHPF,
	\atk, ~coffeeAtk,
	\rel, ~coffeeRel,
	\amp, ~coffeeAmp,
	\pan, ~coffeePan,
	\delaytime, ~coffeeDelay,
	\bla, Pfunc { arg in; m.sendMsg("/vine", 80) }
););

//-------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------


~daisyRhythm = PatternProxy(Pseq(~mainRhythm*2, inf));
~daisyChord = PatternProxy(Pseq(~cloudChord + 33, inf));
~daisyHarmonic = PatternProxy(Pexprand(1, 3, inf).round);
~daisyAtk = PatternProxy(Pwhite(0.1, 0.3, inf));
~daisyRel =  PatternProxy(Pwhite(1, 3, inf));
~daisyAmp = PatternProxy(Pkey(\harmonic).reciprocal * 0.3);

/*(~daisypat = Pbind(
	\instrument, \daisy,
	//try different permutations of this
	\dur, ~daisyRhythm,
	\midinote,~daisyChord,
	\harmonic, ~daisyHarmonic,
	\atk, ~daisyAtk,
	\rel, ~daisyRel,
	\amp, ~daisyAmp,
	\pan, Pwhite(-0.8, 0.8, inf),

	\bla, Pfunc { arg in; m.sendMsg("/daisy", in[\harmonic], in[\amp], in[\pan]) },
);
);*/


~daisyIndex = PatternProxy(Pwhite(0, 0, inf));
~daisyRatio = PatternProxy(Pexprand(1, 1, inf).round);

(~daisypat = Pbind(
	\instrument, \fmsynth,
	//try different permutations of this
	\dur, ~daisyRhythm,
	\midinote,~daisyChord,
	\harmonic, ~daisyHarmonic,
	\atk, ~daisyAtk,
	\rel, ~daisyRel,
	\amp, ~daisyAmp,
	\pan, Pwhite(-0.8, 0.8, inf),

	\index, ~daisyIndex,
	\ratio, ~daisyRatio,

	\bla, Pfunc {
		arg in;
		if(in[\ratio].round - in[\ratio] != 0,{
			m.sendMsg("/lily", in[\harmonic], in[\amp], in[\pan], in[\index], in[\ratio]);
		},
		{
			m.sendMsg("/daisy", in[\harmonic], in[\amp], in[\pan], in[\index], in[\ratio]);
		});
	},
);
);

