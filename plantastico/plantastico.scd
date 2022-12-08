s.boot;

//visualize serial ports
SerialPort.devices;
//open the serial port
//~port =SerialPort.new("/dev/tty.usbmodem1411",9600);
~port =SerialPort.new(SerialPort.devices[1],9600);
//~port =SerialPort.new(SerialPort.devices[3],9600);
//corre el sample
~ruta = "/Users/rbn/biocoding/Samples/"
m = NetAddr.new("127.0.0.1", 47120);    // create the NetAddr
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
	// 0.1.wait;
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

//Create synths
(
~pluck = Buffer.read(s, ~ruta ++ "heavy 0.wav");
SynthDef(\pluck, {
	arg freq=1, amp=1;
	var sig;
	sig=PlayBuf.ar(2, ~pluck,
		BufRateScale.kr(~pluck)*freq,
		doneAction:2);
	Out.ar(0,sig);
}).add;
~string = Buffer.read(s, ~ruta ++ "beep (3).wav");
SynthDef(\string, {
	arg freq=1, amp=1;
	var sig;
	sig=PlayBuf.ar(2, ~string,
		BufRateScale.kr(~string)*freq,
		doneAction:2);
	Out.ar(0,sig);
}).add;
~snare = Buffer.read(s, ~ruta ++ "1_tamborine.wav");
SynthDef(\snare, {
	arg freq=1, amp=1;
	var sig;
	sig=PlayBuf.ar(2, ~snare,
		BufRateScale.kr(~snare)*freq,
		doneAction:2);
	Out.ar(0,sig);
}).add
)

(
d = Pdef(\instrumento01,
Pbind(
	\instrument,\pluck,
	\freq,Pfunc({
		[0,2,4,5,7].choose.midiratio
		+ ~hum.linlin(450,570,0,3);
	}),
	\amp,0.5,
	\dur,Prand([0.5, 1, 0.25], inf)
)
);

e = Pdef(\instrumento02,
Pbind(
	\instrument,\string,
	\freq,Pfunc({
		[0,2,4,5,7].choose.midiratio
			+ ~luz.linlin(100,575,1,5);
	}),
	\amp,0.3,
		\dur,Prand([0.5, 1, 0.25], inf)
)
);

f = Pdef(\instrumento03,
Pbind(
	\instrument,\snare,
	\freq,Pfunc({
		[0,2,4,5,7].choose.midiratio
		+ ~touch.linlin(0,100, 0,1);
	}),
	\amp,0.2,
	\dur,Prand([0.5, 1, 0.25], inf)
)
);

r  = Routine({
	inf.do{

		m.sendMsg("/hum", ~hum.asFloat);
		~hum.postln;
		m.sendMsg("/luz", ~luz.asFloat);
		~luz.postln;
		m.sendMsg("/touch",~touch.asFloat);// send OSC message to P5
		~touch.postln;
		0.5.wait;
	}
}
);
)

//play synths
(
d.play;
e.play;
f.play;
r.play;
)

//stop synths
(
d.stop;
e.stop;
f.stop;
r.stop;
)





