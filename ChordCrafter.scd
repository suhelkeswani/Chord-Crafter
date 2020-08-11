/*CHORD CRAFTER, VERSION 1.0
by Suhel Keswani
powered by SuperCollider
Thanks for checking out my code, feel free to modify it how you like
I've done my best to outline what each chunk of code does with comments.
For questions or inquiry, you can reach me at suhelkeswani@gmail.com
*/

(
// EDITOR SETUP SHORTCUT: sets Cmd+period as shortcut to stop all MIDI sound (for testing as emergency stop shortcut)
CmdPeriod.add({(0..127).do{arg n; m.noteOff(0, n)}});
)

// ALL CODE BELOW
(

// create the new main window (called ~mainScreen)
~mainScreen = Window.new("Chord Crafter", Rect.new(Window.screenBounds.width/2 -350, Window.screenBounds.height/2 - 175, 700, 350), false)
.alwaysOnTop = (true);

~velocity = 60;

~velocitySlider = Slider.new(~mainScreen, Rect(205, 25, 200, 40))
.value_(60/127)
.action_({
	arg obj;
	~velocity = obj.value * 127;
	~velocityBox.value_(obj.value * 127);
});

~velocityBox = NumberBox(~mainScreen, Rect(415, 25, 80, 40))
.align_(\center)
.value_(60)
.clipLo_(0)
.clipHi_(127)
.font_(Font("Monaco", 20))
.decimals_(2)
.action_({
	arg obj;
	~velocitySlider.valueAction_(obj.value/127);
});

~about = Button.new(~mainScreen, Rect(575, 25, 100, 50))
.states_([["About", Color.black]])
.font_(Font("Monaco", 15))
.action_({
	arg obj;
	if (
		obj.value == 0, {
		//~infoScreen.front;
	};
	)
});

~tutorial = Button.new(~mainScreen, Rect(25, 25, 100, 50))
.states_([["Tutorial", Color.black]])
.font_(Font("Monaco", 15))
.action_({
	arg obj;
	if (
		obj.value == 0, {
		//~infoScreen.front;
	};
	)
});

~noteVelocity = StaticText(~mainScreen, Rect.new(250, 50, 200, 50))
.font_(Font("Monaco", 15))
.align_(\left)
.string_("Note Velocity");

~rootNote = PopUpMenu(~mainScreen, Rect.new(25, 100, 90, 50))
.items_(["A","A#/Bb","B","C","C#/Db","D","D#/Eb","E","F","F#/Gb","G","G#/Ab"])
.font_(Font("Monaco", 20))
.value_("3")
.allowsReselection_(true);

~rootNoteText = StaticText(~mainScreen, Rect.new(25, 135, 90, 50))
.font_(Font("Monaco", 15))
.align_(\center)
.string_("Root Note");

~octaveSelector = PopUpMenu(~mainScreen, Rect.new(45, 200, 50, 50))
.font_(Font("Monaco", 20))
.items_(["1", "2", "3", "4", "5", "6", "7", "8"])
.value_("3")
.allowsReselection_(true)
.action_({
	arg obj;
	case
	{(obj.item == "1").and(~inversionMenu.item != "")} {~inversionMenu.enabled_(false)}
	{obj.item == "8"}{~inversionMenu.enabled_(false)}
	{true}{~inversionMenu.enabled_(true)}
});

~octaveText = StaticText(~mainScreen, Rect.new(40, 245, 60, 50))
.font_(Font("Monaco", 15))
.align_(\center)
.string_("Octave");

~bottomText = StaticText(~mainScreen, Rect.new(25, 300, 650, 50))
.font_(Font("Monaco", 15))
.align_(\left)
.string_("Version 1.0                                     Built with SuperCollider");

~thirdNote = PopUpMenu(~mainScreen, Rect.new(137, 100, 75, 50))
.items_(["maj","min", "dom","dim", "sus2", "sus4", "aug"])
.font_(Font("Monaco", 20))
.value_("0")
.allowsReselection_(true)

// this selector controls the seventhNote selector options, ninthNote selector options, and eleventhNote selector options

.action_({
	arg obj;
	case
	{obj.item == "maj"} {~seventhNote.items_(["", "6", "7"]); ~ninthNote.items_(["", "9"]); ~eleventhNote.items_(["", "#11"])}
	{obj.item == "min"} {~seventhNote.items_(["", "6", "7", "7 b5", "maj7"]); ~ninthNote.items_(["", "9"]); ~eleventhNote.items_(["", "11"])}
	{obj.item == "dim"} {~seventhNote.items_(["", "7"]); ~ninthNote.items_(["", "9"]); ~eleventhNote.items_(["", "11"])}
	{obj.item == "dom"} {~seventhNote.items_(["7"]); ~ninthNote.items_(["", "b9", "9", "#9"]); ~eleventhNote.items_(["", "11", "#11"])}
	{obj.item == "sus2"} {~seventhNote.items_(["", "6", "7"]); ~ninthNote.items_(["", "9"]); ~eleventhNote.items_(["", "11"])}
	{obj.item == "sus4"} {~seventhNote.items_(["", "6", "7"]); ~ninthNote.items_(["", "9"]); ~eleventhNote.items_(["", "11"])}
	{obj.item == "aug"} {~seventhNote.items_(["", "6", "7", "maj7"]); ~ninthNote.items_(["", "9", "#9"]); ~eleventhNote.items_(["", "#11"])};
});

~thirdText = StaticText(~mainScreen, Rect.new(137, 135, 75, 50))
.font_(Font("Monaco", 15))
.align_(\center)
.string_("triad");

~seventhNote = PopUpMenu(~mainScreen, Rect.new(237, 100, 80, 50))
.items_(["", "6", "7"])
.font_(Font("Monaco", 20))
.value_("0")
.allowsReselection_(true)
.action_({
	arg obj;
	case
	{obj.item == ""} {~inversionMenu.items_(["", "first", "second"])}
	{obj.item != ""} {~inversionMenu.items_(["", "first", "second", "third"])};
});

~seventhText = StaticText(~mainScreen, Rect.new(237, 135,80, 50))
.font_(Font("Monaco", 15))
.align_(\center)
.string_("7th");

~ninthNote = PopUpMenu(~mainScreen, Rect.new(342, 100, 50, 50))
.items_(["", "9"])
.font_(Font("Monaco", 20))
.value_("0")
.allowsReselection_(true);

~ninthText = StaticText(~mainScreen, Rect.new(342, 135, 50, 50))
.font_(Font("Monaco", 15))
.align_(\center)
.string_("9th");

~eleventhNote = PopUpMenu(~mainScreen, Rect.new(417, 100, 65, 50))
.items_(["", "#11"])
.font_(Font("Monaco", 20))
.value_("0")
.allowsReselection_(true);

~eleventhText = StaticText(~mainScreen, Rect.new(412, 135, 75, 50))
.font_(Font("Monaco", 15))
.align_(\center)
.string_("11th");

~thirteenthNote = PopUpMenu(~mainScreen, Rect.new(504, 100, 50, 50))
.items_(["", "13"])
.font_(Font("Monaco", 20))
.value_("0")
.allowsReselection_(true);

~thirteenthText = StaticText(~mainScreen, Rect.new(504, 135, 50, 50))
.font_(Font("Monaco", 15))
.align_(\center)
.string_("13th");

~prevState = 0;
~inversionMenu = PopUpMenu(~mainScreen, Rect.new(575, 100, 100, 50))
.items_(["", "first", "second"])
.font_(Font("Monaco", 20))
.value_("0")
.allowsReselection_(true)
.action_({
	arg obj;
	// in the case of a state change from no inversion selected to inversion selected or vice versa, appropriatley add/subtract octave menu value
	case
	{~octaveSelector.item == "8"} {}
	{(~prevState == 0).and(obj.value != 0)} {~octaveSelector.value = ~octaveSelector.value + 1; ~prevState = 1}
	{~octaveSelector.item == "1"} {}
	{(~prevState == 1).and(obj.value == 0)} {~octaveSelector.value = ~octaveSelector.value - 1; ~prevState = 0};

});

~inversionText = StaticText(~mainScreen, Rect.new(575, 135, 100, 50))
.font_(Font("Monaco", 15))
.align_(\center)
.string_("inversion");

// chord array below stores midi note values for every note within the chord
~chord = Array.newClear(7);

/* DESIGNATED CHORD INDECES:
0: root
1: third
2: fifth
3: seventh (option)
4: ninth (optional)
5: eleventh (optional)
6: thirtheenth (optional)
*/

~randomButton = Button(~mainScreen, Rect.new(475, 200, 200, 100))
.font_(Font("Monaco", 20))
.string_("Play Random!")

//assigns random values for selectors
.action_({
	arg obj;
	if (
		obj.value == 0, {
		~octaveSelector.valueAction_(rrand(0, 7));
		~rootNote.valueAction_(rrand(0, 11));
		~thirdNote.valueAction_(rrand(0, 6));

		// set upper limits for the rest of the sliders based on what the third note is through dummy variables
		~seventhLimit;
		~ninthLimit;
		~eleventhLimit;
		~inversionLimit;
		case
			{~thirdNote.item == "maj"} {~seventhLimit =  2; ~ninthLimit = 1; ~eleventhLimit=1}
			{~thirdNote.item == "min"} {~seventhLimit = 4; ~ninthLimit = 1; ~eleventhLimit=1}
			{~thirdNote.item == "dom"} {~seventhLimit = 0; ~ninthLimit = 3; ~eleventhLimit=2}
			{~thirdNote.item == "dim"} {~seventhLimit = 1; ~ninthLimit = 1; ~eleventhLimit=1}
			{~thirdNote.item == "sus2"} {~seventhLimit = 2; ~ninthLimit = 1; ~eleventhLimit=1}
			{~thirdNote.item == "sus4"} {~seventhLimit = 2; ~ninthLimit = 1; ~eleventhLimit=1}
			{~thirdNote.item == "aug"} {~seventhLimit = 3; ~ninthLimit = 2; ~eleventhLimit=1};

		~seventhNote.valueAction_(rrand(0, ~seventhLimit));
		~ninthNote.valueAction_(rrand(0, ~ninthLimit));
		~eleventhNote.valueAction_(rrand(0, ~eleventhLimit));
		~thirteenthNote.valueAction_(rrand(0, 1));

		case
			{~seventhNote.item == ""} {~inversionLimit = 2}
			{~seventhNote.item != ""} {~inversionLimit = 3};

		case
			{~inversionMenu.enabled == true} {~inversionMenu.valueAction_(rrand(0, ~inversionLimit))}
			{~inversionMenu.enabled == false} {~inversionMenu.value_(0)};

		~velocitySlider.valueAction_(rrand(0.0, 1.0));

		// play the random chord after generating it
		~chordPlay.valueAction_("0");
		}
	);
});


~chordPlay = Button(~mainScreen, Rect.new(200, 200, 200, 100))
.font_(Font("Monaco", 20))
.string_("Play!")

// PLAY BUTTON ACTION: Upon Click, assemble chord array and run routine

.action_({
	arg obj;
	if (
		obj.value == 0, {

		// root note case table
			case
			{~rootNote.item == "A"} {~chord[0] = 12 * (~octaveSelector.value + 1 - 4) + 57}
			{~rootNote.item == "A#/Bb"} {~chord[0] = 12 * (~octaveSelector.value + 1 - 4) + 58}
			{~rootNote.item == "B"} {~chord[0] = 12 * (~octaveSelector.value + 1 - 4) + 59}
			{~rootNote.item == "C"} {~chord[0] = 12 * (~octaveSelector.value + 1 - 4) + 60 }
			{~rootNote.item == "C#/Db"} {~chord[0] = 12 * (~octaveSelector.value + 1 - 4) + 61}
			{~rootNote.item == "D"} {~chord[0] = 12 * (~octaveSelector.value + 1 - 4) + 62}
			{~rootNote.item == "D#/Eb"} {~chord[0] = 12 * (~octaveSelector.value + 1 - 4) + 63}
			{~rootNote.item == "E"} {~chord[0] = 12 * (~octaveSelector.value + 1 - 4) + 64}
			{~rootNote.item == "F"} {~chord[0] = 12 * (~octaveSelector.value + 1 - 4) + 65}
			{~rootNote.item == "F#/Gb"} {~chord[0] = 12 * (~octaveSelector.value + 1 - 4) + 66}
			{~rootNote.item == "G"} {~chord[0] = 12 * (~octaveSelector.value + 1 - 4) + 67}
			{~rootNote.item == "G#/Ab"} {~chord[0] = 12 * (~octaveSelector.value + 1 - 4) + 68};

		// acccount for inversions by subtracting an octave to build the chord correctly if inversion is selected
			case
			{~inversionMenu.item != ""}{~chord[0] = ~chord[0]-12};

		// third note case table (also sets fifth notes)
			case
			{~thirdNote.item == "maj"} {~chord[1] = ~chord[0] + 4; ~chord[2] = ~chord[0] + 7}
			{~thirdNote.item == "dom"} {~chord[1] = ~chord[0] + 4; ~chord[2] = ~chord[0] + 7}
			{~thirdNote.item == "min"} {~chord[1] = ~chord[0] + 3; ~chord[2] = ~chord[0] + 7}
			{~thirdNote.item == "dim"} {~chord[1] = ~chord[0] + 3; ~chord[2] = ~chord[0] + 6}
			{~thirdNote.item == "sus2"} {~chord[1] = ~chord[0] + 2; ~chord[2] = ~chord[0] + 7}
			{~thirdNote.item == "sus4"} {~chord[1] = ~chord[0] + 5; ~chord[2] = ~chord[0] + 7}
			{~thirdNote.item == "aug"} {~chord[1] = ~chord[0] + 4; ~chord[2] = ~chord[0] + 8};

		// seventh note case table
			case
			{~seventhNote.item == ""} {~chord[3] = nil}
			{~seventhNote.item == "6"} {~chord[3] = ~chord[0] + 9}
			{~seventhNote.item == "maj7"} {~chord[3] = ~chord[0] + 11}
			{~seventhNote.item == "7 b5"} {~chord[3] = ~chord[0] + 10; ~chord[1] = ~chord[0] + 6}
			{~thirdNote.item == "maj" && ~seventhNote.item == "7"} {~chord[3] = ~chord[0] + 11}
			{~thirdNote.item == "min" && ~seventhNote.item == "7"} {~chord[3] = ~chord[0] + 10}
			{~thirdNote.item == "dom" && ~seventhNote.item == "7"} {~chord[3] = ~chord[0] + 10}
			{~thirdNote.item == "dim" && ~seventhNote.item == "7"} {~chord[3] = ~chord[0] + 9}
			{~thirdNote.item == "sus2" && ~seventhNote.item == "7"} {~chord[3] = ~chord[0] + 11}
			{~thirdNote.item == "aug" && ~seventhNote.item == "7"} {~chord[3] = ~chord[0] + 10};

		// ninth note case table
			case
			{~ninthNote.item == ""} {~chord[4] = nil}
			{~ninthNote.item == "9"} {~chord[4] = ~chord[0] + 14}
			{~ninthNote.item == "b9"} {~chord[4] = ~chord[0] + 13}
			{~ninthNote.item == "#9"} {~chord[4] = ~chord[0] + 15};

		// eleventh note case table
			case
			{~eleventhNote.item == ""} {~chord[5] = nil}
			{~eleventhNote.item == "11"} {~chord[5] = ~chord[0] + 17}
			{~eleventhNote.item == "#11"} {~chord[5] = ~chord[0] + 18};

		// thirteenth note case table
			case
			{~thirteenthNote.item == ""} {~chord[6] = nil}
			{~thirteenthNote.item == "13"} {~chord[6] = ~chord[0] + 21};

		// chord inversion case table
			case
			{~inversionMenu.enabled == false} {}
			{~inversionMenu.item == ""} {}
			{~inversionMenu.item == "first"} {~chord[0] = ~chord[0] +12}
			{~inversionMenu.item == "second"} {~chord[0] = ~chord[0] +12; ~chord[1] = ~chord[1] + 12}
			{~inversionMenu.item == "third"} {~chord[0] = ~chord[0] +12; ~chord[1] = ~chord[1] + 12; ~chord[2] = ~chord[2] + 12};

		// you can see the array of MIDI note values in the post window if you'd like :D
			postln(~chord);
			postln(~velocity);

		// plays the chord
			r = Routine ( {
			~chord.do{
				arg nn;
					case
					{nn == nil} {}
					{nn > 127} {}
					{true} {m.noteOn(0, nn, ~velocity)};
			};
			5.wait;
			(0..127).do{arg n; m.noteOff(0, n, 100)};
			} ).play;

	};
	)
}
);

// create a new centered window for info screen (called ~infoScreen)
~infoScreen=Window.new("Chord Crafter", Rect.new(Window.screenBounds.width/2 - 300, Window.screenBounds.height/2 - 350, 600, 700), false)
.alwaysOnTop = true;

// info screen text
~infoScreenText1 = StaticText(~infoScreen, Rect.new(40, 50, 520, 100))
.font_(Font("Monaco", 20))
.align_(\center)
.string_("Chord Crafter is a Digital MIDI Instrument where you can explore the complex world of extended harmony by building your own chords.");

~infoScreenText2 = StaticText(~infoScreen, Rect.new(40, 125, 520, 200))
.font_(Font("Monaco", 20))
.align_(\center)
.string_("You can playback your chords by connecting this application as a MIDI input to your DAW such as GarageBand or Ableton.");

~infoScreenText2contd1 = StaticText(~infoScreen, Rect.new(40, 370, 520, 200))
.font_(Font("Monaco", 20))
.align_(\center)
.string_("Create and then select a new software instrument track in your DAW, where you can change the instrument output, adjust the tone quality, and record your chords.");

~infoScreenText2Cont2 = StaticText(~infoScreen, Rect.new(40, 240, 520, 200))
.font_(Font("Monaco", 20))
.align_(\center)
.string_("Be sure to enable your IAC Driver if on a Mac or use an internal MIDI transfer driver such as LoopBe if on Windows.");

~infoScreenText3 = StaticText(~infoScreen, Rect.new(65, 525, 500, 100))
.font_(Font("Monaco", 20))
.align_(\left)
.string_("Please Input your MIDI input Bus:");

//input box for MIDI Channel
~midiCh = 0;
~midiChInp = TextField(~infoScreen, Rect.new(475, 563, 50, 25))
.font_(Font("Monaco", 20))
.string_("1");


// press to continue button: takes MIDI channel input and sets
~pushToCont = Button(~infoScreen, Rect(235, 610, 150, 50))
.states_([["Continue", Color.black]])
.font_(Font("Monaco", 15))
.action_({
	arg obj;
	if (
		obj.value == 0, {
		~infoScreen.close;
		~midiCh = ~midiChInp.string.asInteger-1;

		// initializes MIDI and channels. Subtraction by one is necessary bc channels start at zero while Bus starts at 1
		MIDIClient.init;

		MIDIClient.destinations;
		m = MIDIOut.new(~midiCh);

		m.latency_(0);

		~mainScreen.front;
	};
	)
}
);

// create a new centered window for start screen (called l)
l=Window.new("Chord Crafter", Rect.new(Window.screenBounds.width/2 -200, Window.screenBounds.height/2 - 200, 400, 400),false);
l.front;
l.alwaysOnTop =  true;

// start screen text
~titleScreenBox = StaticText(l, Rect.new(50, 50, 300, 100))
.string_("Chord Crafter")
.font_(Font("Monaco" , 35))
.align_(\center);

~titleDescr = StaticText(l, Rect(50, 150, 300, 100))
.string_("Powered by SuperCollider Ver 1.0")
.font_(Font("Monaco", 20))
.align_(\center);

//push to start button closes windown + opens info screen
~pushToStart = Button(l, Rect(150, 275, 100, 50))
.states_([["Start!", Color.black]])
.font_(Font("Monaco", 15))
.action_({
	arg obj;
	if (
		obj.value == 0, {
		l.close;
		~infoScreen.front;
	};
	)
}
);
)
