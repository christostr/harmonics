s.boot;
(
SynthDef(\Melody, {
	arg freq = 440, dur = 1, amp = 0.6;
	var env, sig;
	env = EnvGen.kr(Env.perc, doneAction: 2);
	sig = SinOsc.ar(freq) * env * amp;
	sig = FreeVerb.ar(sig, 0.8); //Reverb
	Out.ar([0, 1], sig);
}).add;
)

(
SynthDef(\Oscillator, {
	arg freq = 220, dur = 8, amp = 0.1;
	var env, sig;
	env = EnvGen.kr(Env.perc, doneAction: 2);
	sig = SinOsc.ar(freq) * env * amp;
	Out.ar([0, 1], sig);
}).add;
)


(

SynthDef(\Drone, {
	arg freq = 55, depth = 70, rate = 0.1, dur = 999, amp = 0.04;
	var sig;
	sig = SinOsc.ar(LFNoise1.kr(rate).range(0, 1) * depth + freq) * amp;
	Out.ar([0, 1], sig);
}).add;
)

(
s.record;
{
	inf.do {
		var root = (20..72).choose; //Random Note
		var scale = [0, 2, 3, 5, 7, 8, 11];
		var harMelody = scale.collect { |interval| root + interval };
		harMelody.do { |note|
			Synth(\Melody, [
				\freq, note.midicps,
				\dur, 0.8,
				\amp, 0.15
			]);
		};
		Synth(\Oscillator, [
			\freq, 110,
			\dur, 8,
			\amp, 0.07
		]);
		Synth(\Drone, [
			\freq, 55,
			\depth, 200,
			\rate, 0.1,
			\amp, 0.04
		]);
		0.8.wait;
	}
}.fork;
20.wait;
s.stopRecording;
)
s.meter;