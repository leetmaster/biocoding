s.boot;

m = NetAddr("127.0.0.1", 47120); // should be working with this ip and port-number ...
~oscResp = OSCresponder(~netAddr, '/toProcessing', { arg time, resp, msg; [time, msg].postln }).add;
//visualize serial ports
SerialPort.devices;
//open the serial port
~port =SerialPort.new(SerialPort.devices[1],9600);

//compute the data
(
~charArray=[];
~getValues=Routine({
	var ascii;
	{

		ascii = ~port.read.asAscii;
		if(ascii.isDecDigit,
			{~charArray = ~charArray.add(ascii)});

		if (ascii == $a ,{
			~luz= ~charArray.collect(_.digit).convertDigits;
		   ~charArray = [];
		});
		if (ascii == $b ,{
			~touch= ~charArray.collect(_.digit).convertDigits;
		   ~charArray = [];
		});
		if (ascii == $c ,{
			~hum= ~charArray.collect(_.digit).convertDigits;
		   ~charArray = [];
		});
	 0.1.wait;
	}.loop;
}).play;
)

//vizualize the data
(
Routine({
	{
		~touch.postln;
		~hum.postln;
		~luz.postln;
		0.1.wait;
	}.loop
}).play
)

//create synths
(
a = Pdef(\patron01,
	Pbind(
		\midinote, Pfunc({Scale.majorPentatonic.degrees.choose + ~touch.linlin(0,350, 48,60)}),
		\dur, Prand([0.5, 0.25, 1], inf),
		\amp, 0.5

	)
);
b = Pdef(\patron02,
	Pbind(
		\midinote, Pfunc({Scale.majorPentatonic.degrees.choose + ~luz.linlin(0,110,60,72)}),
		\dur, Prand([0.5, 0.25, 1], inf),
		\amp, 0.3
	)
	);

c = Pdef(\patron03,
	Pbind(
		\midinote, Pfunc({Scale.majorPentatonic.degrees.choose + ~hum.linlin(340,570,72,84)}),
		//\freq, Pfunc({~luz}.linlin(0,90,220,440)),
	    \dur, Prand([0.5, 0.25, 1], inf),
		\amp, 0.2

	)
);

// messages routine for visualization
r  = Routine({
	inf.do{

		m.sendMsg("/hum", ~hum.asFloat);
		~hum.postln;
		m.sendMsg("/luz", ~luz.asFloat);
		~luz.postln;
		m.sendMsg("/touch",~touch.asFloat);// send OSC message to P5
		~touch.postln;
		0.3.wait;
	}
}
);
)

// start synths

(
a.play;
b.play;
c.play;
r.play;
)

// stop synths
(
a.stop;
b.stop;
c.stop;
r.play;
)
