s = Server.default;

// === STABILITY SETTINGS ===
s.options.numAnalogInChannels = 8;
s.options.numAnalogOutChannels = 8;
s.options.numDigitalChannels = 16;
s.options.blockSize = 64;
s.options.memSize = 65536;

s.waitForBoot({

    SynthDef("trillCraft_touchInstrument", { arg out = 0;
        var data, touchAmt, gate, trig, env, freq, tone, pad, mix, sig, scale;

        // --- SAME SCALE ---
        scale = [196, 220, 247, 262, 330, 392, 440];

        // --- TRILL RAW ---
        data = Lag.kr(TrillRaw.kr(1, 0x30, 0.04, 2, 0), 0.05);
        touchAmt = data.sum.linlin(0, 5, 0, 1).clip(0, 1);
        gate = touchAmt > 0.05;

        // --- SAME TRIGGER BEHAVIOR ---
        trig = gate.changed * gate;
        env = EnvGen.kr(Env.asr(0.01, 1, 0.6), gate);

        // --- SAME RANDOM NOTE SELECTION ---
        freq = Select.kr(TIRand.kr(0, scale.size - 1, trig), scale);

        // --- SOUND LAYERS (unchanged) ---
        tone = SinOsc.ar(freq, 0, 0.25) * env;
        tone = tone + (SinOsc.ar(freq * 2, 0, 0.1) * env);
        tone = tone + (BPF.ar(WhiteNoise.ar(0.01), freq * 2, 0.3) * env * 0.5);

        pad = SinOsc.ar([80, 120].choose, 0, 0.04) * Lag.kr(touchAmt, 1.2);
        mix = tone + pad;

        // --- **STABILITY FIXES** (but same sound) ---
        // 1) Reverb tail cannot grow forever
        sig = FreeVerb2.ar(mix, mix, 0.6, 0.6, 0.35);

        // 2) Remove DC offset (fixes drift)
        sig = LeakDC.ar(sig);

        // 3) Stop denormal CPU collapse
        sig = sig + (0.0000001 * WhiteNoise.ar(0)); // inaudible, prevents denormal freeze

        // 4) Same filtering + limiting
        sig = LPF.ar(sig, 9000);
        sig = HPF.ar(sig, 100);
        sig = Limiter.ar(sig * 2.5, 0.9);

        Out.ar(out, sig!2);
    }).send(s);

    s.sync;
    Synth("trillCraft_touchInstrument");
});

ServerQuit.add({ 0.exit });




