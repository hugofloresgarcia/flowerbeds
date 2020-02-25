//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////    PART  ONE     /////////////////////////////////////////
/////////////////////////////////  //////////  SELF  ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////                                 _,-._                                     /////////////
/////////////                                / \_/ \                                    /////////////
////////////                                 >-(_)-<                                    /////hjw/////
////////////                                 \_/ \_/                                    /////////////
////////////                                   `-'                                      /////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////

//make sure you run flowerbeds_instrumentation and THEN flowerbeds_patterns
s.record;
//clear fbo if needed
m.sendMsg("/clearfbo");
// start the clouds
(
~cloud5EVENT = ~cloud4.play;
~cloud4EVENT = ~cloud5.play;
m.sendMsg("/drawSwirl", true);
)

//do this five times
//slowly decrease harmonics from  to 1
//slowly decrease mod speed from 4 to 0
//slowly increase amplitude from 0.1 to 0.4
//increse self size gradually

(
~cloudAmp.source = (Pkey(\harmonic).reciprocal * 0.1);
 ~cloudHarmonics.source = (Pexprand(40, 80).round);
 ~cloudModSpeed.source = Pwhite(4, 8);

/*~cloudModSpeed.source = Pwhite(0.025, 0.1);
~cloudHarmonics.source = (Pexprand(1, 2).round);*/

~cloud5Chord.source = Pseq((~cloudChord + 40).scramble, inf);
~cloud4Chord.source = Pseq((~cloudChord + 33).scramble, inf);

Routine({10.do({
	m.sendMsg("/slightSwirlIncrease", 1);
	2.wait;
})}).play;
)

///////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////

//start the tremevent and vines event

(
~vineFreqsArray = [[10, 20], [20, 40], [40, 80]];
~vineMaxHarmonicsArray = [4, 8, 16];
~vineDursArray = [[0.05, 0.1], [0.025, 0.05], [0.01, 0.025]];
~vinePansArray = [0.4, 0.8, 1];
~vineAmpsArray = [0.3, 0.4, 0.5];
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

		10.wait;
	});
	"vines have taken over".postln;
	5.wait;
});
);

(
~coffeeLPFArray = [[200, 400], [400, 4000], [10000, 20000]];
~coffeeHPFArray = [[800, 400], [400, 200], [0, 50]];
~coffeePansArray = [0.4, 0.8, 1];
~coffeeAmpsArray = [0.3, 0.4, 0.5];

~coffeeTask =  Task({
	~coffeeEVENT = ~coffeep.play;
	3.do({
		arg count;
		"coffee appears".postln;
		"iteration number ".post; count.postln;

		~coffeeLPF.source = Pwhite(~coffeeLPFArray.at(count).at(0), ~coffeeLPFArray.at(count).at(1), inf);
		~coffeeHPF.source = Pwhite(~coffeeHPFArray.at(count).at(0), ~coffeeHPFArray.at(count).at(1), inf);
		~coffeePan.source = Pwhite(~coffeePansArray.at(count)*(-1), ~coffeePansArray.at(count));
		~coffeeAmp.source = Pwhite(0.01, 0.005, inf);

		10.wait;
	});
	"coffee has taken over".postln;
	5.wait;
});
)

(~vineTremTask = Task({
	~trempEVENT = ~tremp.play;
	~tremSpeeds = [8, 4, 2, 1, 1/2];
	~tremCutArray = [[0.125, 0.25], [0.25, 0.5], [0.5, 1], [1, 2], [2, 4]];
	"trem event has started".postln;

	/// the vines task
	~vinesTask.play;
	~coffeeTask.play; /////////?TEMP

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

	~decreaseAmpArray = [0.3, 0.2, 0.075];
	~trempEVENT.stop;

	~decreaseAmpArray.do({
		arg count;
		"decreasing amplitude".postln;
		"iteration number".post; count.postln;

		~cloudAmp.source = (Pkey(\harmonic).reciprocal.squared * ~decreaseAmpArray.at(count));
		2.wait;
	});
});
)

~vineTremTask.start;


///////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////

//the chord has converged here and is at a satisfying place, lets mess with the chord and the keys for a bit
(
~cloud5Chord.source = Pseq((~chordPool.choose + ~keyCenters.choose).scramble, inf);
~cloud4Chord.source = Pseq((~chordPool.choose + ~keyCenters.choose).scramble, inf);
)

//fade the clouds out, and increase the sparity of the vines
//cloud amplitude --------> 0.1 to virtually nothing
//vine amp ---------------> 0.4 to a bit louder
//maxHarmonics -----------> [1, 16] to [150, 200]
//delta should go --------> 0 back to 2

(
~cloudAmp.source = (Pkey(\harmonic).reciprocal * 0.1);

~vineAmp.source = Pwhite(0.5, 0.5);                 //DECREASE
~vineMaxHarmonics.source = Pexprand(1, 40, inf);   //go up
~vineDur.source = Pwhite(0.01, 0.02);              //MULTIPLES OF TEN

//coffee
~coffeeLPF.source  = Pwhite(100, 4000, inf);      ///BE CAREFUL WITH THIS
~coffeeAmp.source  = Pwhite(0.01, 0.005, inf);     /// down to (0.001, 0.005)
)

//once the cloud has faded out and the visuals have reached a satisfying color, stop drawing it. vines too


(
~endmvmtone = Task({
	~cloud4EVENT.stop;
	~cloud5EVENT.stop;
	~vineEVENT.stop;
	~coffeeEVENT.stop;
	m.sendMsg("/stopvine");
	m.sendMsg("/stopSwirls");
	m.sendMsg("/drawSwirl", false);
	1.wait;
	m.sendMsg("/drawBlack");
});
)
//stop everything
~endmvmtone.start;


///////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////     PART  TWO     ///////////////////////////////////////
/////////////////////////////////////////////////  OTHERS  //////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////
////////////                            _                                                 ////////////
////////////                           _(_)_                          wWWWw   _           ////////////
////////////                 @@@@       (_)@(_)   vVVVv     _     @@@@  (___) _(_)_       ////////////
////////////                @@()@@ wWWWw  (_)\    (___)   _(_)_  @@()@@   Y  (_)@(_)      ////////////
////////////                 @@@@  (___)     `|/    Y    (_)@(_)  @@@@   \|/   (_)\       ////////////
////////////                  /      Y       \|    \|/    /(_)    \|      |/      |       ////////////
////////////               \ |     \ |/       | / \ | /  \|/       |/    \|      \|/      ////////////
////////////               \\|//   \\|///  \\\|//\\\|/// \|///  \\\|//  \\|//  \\\|//     ////////////
////////////////////////////////////////////////////jgs///////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////

//start the daisy event
///////////////////daisies//////////////////////
//start out really sparse, harmonics < 10
//increase density, start atk[0.1, 1.5] and rel[1, 3]
//change harmonic structure
//keep increasing density
//dry the notes out
//density at an insane level
//decrease density til it fades away
//wait
//come back with full intensity
///////////////////////////////////////////////

~daisyEVENT = ~daisypat.play;

//////////// GO UP //////////////
(
~daisyRhythm.source = Pseq(~mainRhythm, inf);
~daisyChord.source = Pseq((~chordPool.choose + ~keyCenters.choose), inf);
~daisyHarmonic.source =Pexprand(1, 3, inf).round;
~daisyAtk.source = Pwhite(0.1, 0.5, inf);
~daisyRel.source =  Pwhite(1, 3, inf);
~daisyAmp.source = Pkey((\harmonic).reciprocal.squared) * 0.01;

~daisyIndex.source = Pwhite(0, 0, inf);  //keep this conservative. dont go past 1
~daisyRatio.source = Pexprand(1, 1, inf).round;

)

////////// SPARSE, UNTIL FULL STOP ///////////////

(
~daisyRhythm.source = Pseq(~mainRhythm*2, inf); //2
~daisyChord.source = Pseq((~chordPool.choose + ~keyCenters.choose), inf);
~daisyHarmonic.source =Pexprand(1, 30, inf).round;
~daisyAtk.source = Pwhite(0.005, 0.01, inf); // 0.005, 0.01
~daisyRel.source =  Pwhite(0.02, 0.01, inf); // 0.02, 0.01
~daisyAmp.source = Pkey((\harmonic).reciprocal.squared) * 0.04;

~daisyIndex.source = Pwhite(0, 0, inf);
~daisyRatio.source = Pexprand(1, 1, inf).round; // go irrational when it's full

m.sendMsg("/drawBlack");
)

m.sendMsg("/drawBlack");

//////////// BACK UP //////////////

(
~daisyRhythm.source = Pseq(~mainRhythm/10, inf); // /10
~daisyChord.source = Pseq((~cloudChord + 33), inf);
~daisyHarmonic.source =Pexprand(1, 40, inf).round; // 40
~daisyAtk.source = Pwhite(0.001, 0.003, inf); // 0.001, 0.003
~daisyRel.source =  Pwhite(0.1, 0.2, inf);
~daisyAmp.source = Pkey((\harmonic).reciprocal.squared) * 0.02;

~daisyIndex.source = Pwhite(0, 0, inf);  //keep this conservative
~daisyRatio.source = Pexprand(1, 1, inf).round;
)


///////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////      PART  THREE     ///////////////////////////////////////
////////////////////////////////////////////////  ALL OF US  ///////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////
////////////                        ,            __ \/ __                                  ////////////
////////////                    /\^/`\          /o \{}/ o\                                 ////////////
////////////                   | \/   |         \   ()   /                                 ////////////
////////////                   | |    |          `> /\ <`   ,,,                            ////////////
////////////                   \ \    /  @@@@    (o/\/\o)  {{{}}                 _ _       ////////////
////////////                    '\\//'  @@()@@  _ )    (    ~Y~       @@@@     _{ ' }_     ////////////
////////////                      ||     @@@@ _(_)_   wWWWw .oOOo.   @@()@@   { `.!.` }    ////////////
////////////                      ||     ,/  (_)@(_)  (___) OO()OO    @@@@  _ ',_/Y\_,'    ////////////
////////////                      ||  ,\ | /)  (_)\     Y   'OOOO',,,(\|/ _(_)_ {_,_}      ////////////
////////////                  |\  ||  |\\|// vVVVv`|/@@@@    _ \/{{}}}\| (_)@(_)  |  ,,,   ////////////
////////////                  | | ||  | |;,,,(___) |@@()@@ _(_)_| ~Y~ wWWWw(_)\ (\| {{{}}  ////////////
////////////                  | | || / / {{}}} Y  \| @@@@ (_)#(_) \|  (___)   |  \| /~Y~   ////////////
////////////                   \ \||/ /\\|~Y~ \|/  | \ \/  /(_) |/ |/   Y    \|/  |//\|/   ////////////
////////////               jgs\ `\\//`,.\|/|//.|/\\|/\\|,\|/ //\|/\|.\\\| // \|\\ |/,\|/   ////////////
////////////               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^  ////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////
(
~cloud5EVENT = ~cloud4.play;
~cloud5EVENT = ~cloud5.play;
m.sendMsg("/drawSwirl", true);
m.sendMsg("/darkSwirl", true);
)
(
~cloudAmp.source = (Pkey(\harmonic).reciprocal * 0.2); //start 0.2, go up to 0.4
~cloudHarmonics.source = (Pexprand(20, 40).round);   //start [20,40], go down to [1, 10]
~cloudModSpeed.source = Pwhite(4, 8);  //start at [4, 8], go down to [1,2]

/*~cloudModSpeed.source = Pwhite(0.025, 0.1);
~cloudHarmonics.source = (Pexprand(1, 2).round);*/

~cloud5Chord.source = Pseq((~cloudChord + 33).scramble, inf); //detune this in a very unpleasing way
~cloud4Chord.source = Pseq((~cloudChord + 33).scramble, inf);

Routine({10.do({
	m.sendMsg("/slightSwirlIncrease", 1);
	2.wait;
})}).play;
)

///////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////

(
~vineFreqsArray = [[40, 80], [40, 80], [40, 120]];
~vineMaxHarmonicsArray = [16, 20, 30];
~vineDursArray = [ [0.01, 0.05], [0.01, 0.03]];
~vinePansArray = [0.5, 0.8, 1];
~vineAmpsArray = [0.3, 0.5, 0.7];
~vineDepthsArray = [160, 120, 80];
~vinesTask =  Task({
	~vineEVENT = ~vine.play;
	3.do({
		arg count;
		"vine number ".post; count.postln;

		~vineFreq.source = 	Pexprand(~vineFreqsArray.foldAt(count).at(0), ~vineFreqsArray.foldAt(count).at(1), inf);
		~vineMaxHarmonics.source = Pexprand(1, ~vineMaxHarmonicsArray.foldAt(count), inf);
		~vineDur.source = Pwhite(~vineDursArray.foldAt(count).foldAt(0), ~vineDursArray.foldAt(count).at(1), inf);

		~vineAmp.source = Pwhite(~vineAmpsArray.foldAt(count), ~vineAmpsArray.foldAt(count)+0.05);
		~vinePan.source = Pwhite(~vinePansArray.foldAt(count)*(-1), ~vinePansArray.foldAt(count), inf);
		~vineFunc.source = Pfunc({arg in; m.sendMsg("/vine", ~vineDepthsArray.at(count))});

		10.wait;
	});
	"vines have taken over".postln;
	5.wait;
});
);
(
~coffeeLPFArray = [[200, 400], [400, 4000], [15000, 20000]];
~coffeeHPFArray = [[800, 400], [400, 200], [0, 50]];
~coffeePansArray = [0.4, 0.8, 1];

~coffeeTask =  Task({
	~coffeeEVENT = ~coffeep.play;
	3.do({
		arg count;
		"coffee appears".postln;
		"iteration number ".post; count.postln;

		~coffeeLPF.source = Pwhite(~coffeeLPFArray.at(count).at(0), ~coffeeLPFArray.at(count).at(1), inf);
		~coffeeHPF.source = Pwhite(~coffeeHPFArray.at(count).at(0), ~coffeeHPFArray.at(count).at(1), inf);
		~coffeePan.source = Pwhite(~coffeePansArray.at(count)*(-1), ~coffeePansArray.at(count));
		~coffeeAmp.source = Pwhite(0.01, 0.005, inf);

		10.wait;
	});
	"coffee has taken over".postln;
	5.wait;
});
);

///////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////
(
~vinesTask.start;
~coffeeTask.start;
)
///////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////
//back to happy
(
m.sendMsg("/darkSwirl", false);
~cloud5Chord.source = Pseq((~cloudChord + 40), inf);
~cloud4Chord.source = Pseq((~cloudChord + 33), inf);
)
///////////////////////////////////////////////////////////////////////////////////////////////////////////

(
~cloudAmp.source = (Pkey(\harmonic).reciprocal * 0.3); //bring this down from 0.4 to 0.1

~vineAmp.source = Pwhite(0.7, 0.8);                  //keep this up
~vineMaxHarmonics.source = Pexprand(1, 40, inf);

~coffeeLPF.source  = Pwhite(100, 4000, inf);
)



////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////       PART FOUR      ///////////////////////////////////////
///////////////////////////////////////   EMANCIPATION   //////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
////////////                                  __     __                                    ////////
////////////                                .'  `...'  `.                                  ////////
////////////                              __|     |     |__                                ////////
////////////                            .'    \   .   /    `.                              ////////
////////////                            |      ./###\.      |                              ////////
////////////                             >---- |#####| ----<                               ////////
////////////                            |      `\###/'      |                              ////////
////////////                            `.__ /    .    \ __.'                              ////////
////////////                                |     |     |                                   ////////
////////////                                `.___.^.___.'                                  ////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

(
~fboTask = Task({
	~cloudAmp.source = (Pkey(\harmonic).reciprocal * 0.0); //turn off the cloud
	~daisyAmp.source = Pkey((\harmonic).reciprocal.squared) * 0.00; //turn off the daisies

	Array.interpolation(200, 0.5, 15).do({
		arg item, count;

		m.sendMsg("/clearfbo");
		Synth(\blip);
		item.reciprocal.wait;
		item.reciprocal.postln;
	});
	m.sendMsg("/stopDrawing", true);
	~vineEVENT.stop;
	~coffeeEVENT.stop;
});
)

~fboTask.play;
