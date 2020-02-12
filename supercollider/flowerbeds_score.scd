///////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////        ONE         ////////////////////////////////////
/////////////////////////////////////////////////////////  SELF  //////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////

~mainRhythm = [0.1, 0.2, 0.3, 0.2, 0.1];
~tremRhythmicPattern = PatternProxy(Pseq(~mainRhythm*2), inf);


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////       PART ONE   /////////////////////////////////////////////
////////////////////////////////////////// AN INCREASINGLY DENSE CLOUDS OF LOW NOTES///////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
(m = NetAddr("localhost", 57123);

~cloudChord = [0, 2, 7, 14, 16, 21];
~cloudAmp = PatternProxy( Pkey(\harmonic).reciprocal.squared * 0.1);
~cloudDur = PatternProxy( Pseq([0.5]*2, inf));
~cloudHarmonics = PatternProxy(Pexprand(1, 1, inf).round);
~cloudModSpeed = PatternProxy(Pwhite(2, 4, inf));

~tremCut = PatternProxy(Pwhite(0.125, 0.25));

~cloud4Chord = PatternProxy(Pseq((~cloudChord + 40).scramble, inf));
~cloud5Chord = PatternProxy(Pseq((~cloudChord + 33).scramble, inf));

//toplap.org

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

~tremp = Pbind(
	\instrument, \aglitch,
	\group, ~cloudEffect,
	\addAction, 0,
	\dur, ~tremRhythmicPattern,
	// \group, ~cloudEffect,
	\speed, ~tremCut,
	\depth, 0.5,

	\sendBlip, Pfunc {arg in; m.sendMsg("/aGlitch", true, in[\speed]);},
);


~partOneTask = Task({
	~cloud5EVENT = ~cloud4.play;
	~cloud5EVENT = ~cloud5.play;
	m.sendMsg("/drawSwirl", true);

	~cloudAmpsArray  = [0.1, 0.2, 0.3, 0.4, 0.4];
	~cloudHarmsArray = [20, 10, 5, 3, 1];
	~cloudModSpeedsArray = [[2, 4], [1, 2], [0.5, 1], [0.25, 0.5], [0, 0.0125]];

	~tremCutArray = [[0.125, 0.25], [0.25, 0.5], [0.5, 1], [1, 2], [2, 4]];
	~waitTimesArray   = 10!5;

	5.do({
		arg count;
		"iteration number ".post; count.postln;

		~cloudAmp.source = (Pkey(\harmonic).reciprocal.squared * ~cloudAmpsArray.at(count));
		~cloudHarmonics.source = (Pexprand(1, 	~cloudHarmsArray.at(count), inf).round);
		~cloudModSpeed.source = Pwhite(~cloudModSpeedsArray.at(count).at(0), ~cloudModSpeedsArray.at(count).at(1));

		~cloud5Chord.source = Pseq((~cloudChord + 33).scramble, inf);
		~cloud4Chord.source = Pseq((~cloudChord + 40).scramble, inf);

		~waitTimesArray.at(count).wait;

		Routine({10.do({
			m.sendMsg("/slightSwirlIncrease", 1);
			2.wait;
		})}).play;
	});

	2.wait;

	~trempEVENT = ~tremp.play;
	~tremSpeeds = [8, 4, 2, 1, 1/2];
	"trem event has started".postln;

	/// the vines task
	~vinesTask.play;

	5.do({
		arg count;
		"iteration number ".post; count.postln;

		~tremCut.source = Pwhite(~tremCutArray.at(count).at(0), ~tremCutArray.at(count).at(1));
		~mainRhythmicPattern.source = Pseq(~mainRhythm * ~tremSpeeds.at(count), inf);

		2.wait;
		Routine({10.do({
			m.sendMsg("/slightSwirlIncrease", -1);
			1.wait;
		})}).play;
		});
	~trempEVENT.stop;

	5.wait;
	~cloud5Chord.source = Pseq((~cloudChord + 34).scramble, inf);
	~cloud4Chord.source = Pseq((~cloudChord + 41).scramble, inf);
	5.wait;
	~cloud5Chord.source = Pseq((~cloudChord + 33).scramble, inf);
	~cloud4Chord.source = Pseq((~cloudChord + 40).scramble, inf);

	// m.sendMsg("/drawSwirl", false);
	~decreaseAmpArray = [0.3, 0.2, 0.075];
	~trempEVENT.stop;

	~decreaseAmpArray.do({
		arg count;
		"decreasing amplitude".postln;
		"iteration number".post; count.postln;

		~cloudAmp.source = (Pkey(\harmonic).reciprocal.squared * ~decreaseAmpArray.at(count));
		2.wait;
	});

});)

////////////////////////////////////////////////////
///SOME LIVE CODING HERE
////////////////////////////////////////////////
//slowly fade flower away
//increase vine amplitude
//increase number of max harmonics and move the range up top
//start making the vines more and more sparse over time
//then, bring the others in

m.sendMsg("/clearfbo");
s.plotTree

~partOneTask.play;
~partOneTask.stop;

~cloudAmp.source = (Pkey(\harmonic).reciprocal.squared * 0.00);
~vineAmp.source = Pwhite(0.05, 0.03);
~vineMaxHarmonics.source = Pexprand(80, 100, inf);
~vineDur.source = Pwhite(0.03, 0.04, inf);




////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////       PART TWO   /////////////////////////////////////////////
//////////////////////////////////////////////     VINES START CREEPING UP     ///////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//morphology of both sounds
//less wavy until it settles down
// from wavy to dotted
// needs more morphology,
//youre introducing new sounds, but not developing the old ones,
//the sounds need stories
//and you need to connect the video more with the audio,
//you should make the thing actually actually swirl

(
~vineFreq = PatternProxy(Pexprand(10, 20, inf));
~vineMaxHarmonics = PatternProxy(Pexprand(1, 8, inf));
~vineAmp = PatternProxy(Pwhite(0.1, 0.2));
~vineDur = PatternProxy(Pwhite(0.04, 0.08, inf));
~vinePan = PatternProxy(Pwhite(-0.02, 0.02, inf));
~vineDelta = PatternProxy(Pwhite(0, 0.01));

~vineFunc = PatternProxy(Pfunc({arg in; m.sendMsg("/vine", 80)}));

(~vine = Pbind(
	\instrument, \vine,
	\dur, ~vineDur,
	\freq, ~vineFreq,
	\maxHarmonics, ~vineMaxHarmonics,
	\amp, ~vineAmp,
	\sinpan, ~vinePan,
	\delta, ~vineDelta,

	\bla, Pfunc { arg in; m.sendMsg("/vine", 80) },
););


~vineFreqsArray = [[10, 20], [20, 40], [40, 80]];
~vineMaxHarmonicsArray = [4, 8, 16];
~vineDursArray = [[0.08, 0.16], [0.16, 0.32], [0.32, 0.64]].reverse/4;
~vinePansArray = [0.4, 0.8, 1];
~vineAmpsArray = [0.1, 0.15, 0.2];
~vineDepthsArray = [160, 120, 80];

~vinesTask =  Task({
	~vineEVENT = ~vine.play;
	3.do({
		arg count;
		"vines appear".postln;
		"iteration number ".post; count.postln;

		~vineFreq.source = 	Pexprand(~vineFreqsArray.foldAt(count).at(0), ~vineFreqsArray.foldAt(count).at(1), inf);
		~vineMaxHarmonics.source = Pexprand(1, ~vineMaxHarmonicsArray.foldAt(count), inf);
		~vineDur.source = Pwhite(~vineDursArray.foldAt(count).foldAt(0), ~vineDursArray.foldAt(count).at(1), inf);

		~vineAmp.source = Pwhite(~vineAmpsArray.foldAt(count), ~vineAmpsArray.foldAt(count)+0.05);
		~vinePan.source = Pwhite(~vinePansArray.foldAt(count)*(-1), ~vinePansArray.foldAt(count), inf);
		~vineFunc.source = Pfunc({arg in; m.sendMsg("/vine", ~vineDepthsArray.at(count))});

		5.wait;
	});
	"vines have taken over".postln;
	5.wait;
});
);

~vineEVENT.stop;
m.sendMsg("/stopvine");
~vinesTask.play;


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////       PART THREE      /////////////////////////////////////////////
////////////////////////////////////////////////    GLITCH OUT   /////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
(
~fboTask = Task({
	Array.interpolation(200, 0.5, 15).do({
		arg item, count;

		m.sendMsg("/clearfbo");
		Synth(\blip);
		item.reciprocal.wait;
		item.reciprocal.postln;
	});
	m.sendMsg("/stopDrawing", true);
	~vineEVENT.stop;
});
)



~fboTask.play;
~fboTask.stop;

