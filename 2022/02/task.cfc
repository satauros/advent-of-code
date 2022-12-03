component {

	// Define shape scores
	variables[ "X" ] = 1;
	variables[ "Y" ] = 2;
	variables[ "Z" ] = 3;

	// Define game scores
	variables[ "WIN" ] = 6;
	variables[ "DRAW" ] = 3;
	variables[ "LOSS" ] = 0;

	// Part one scoring chart
	variables[ "outcomeScores" ] = {
		  "A X": variables.X + variables.DRAW // Rock vs Rock
		, "A Y": variables.Y + variables.WIN // Rock vs Paper
		, "A Z": variables.Z + variables.LOSS // Rock vs Scissors
		, "B X": variables.X + variables.LOSS // Paper vs Rock
		, "B Y": variables.Y + variables.DRAW // Paper vs Paper
		, "B Z": variables.Z + variables.WIN // Paper vs Scissors
		, "C X": variables.X + variables.WIN // Scissors vs Rock
		, "C Y": variables.Y + variables.LOSS // Scissors vs Paper
		, "C Z": variables.Z + variables.DRAW // Scissors vs Scissors
	};

	// Part two scoring chart
	variables[ "alternativeOutcomeScores" ] = {
		  "A X": variables.Z + variables.LOSS // Rock vs Scissors
		, "A Y": variables.X + variables.DRAW // Rock vs Rock
		, "A Z": variables.Y + variables.WIN // Rock vs Paper
		, "B X": variables.X + variables.LOSS // Paper vs Rock
		, "B Y": variables.Y + variables.DRAW // Paper vs Paper
		, "B Z": variables.Z + variables.WIN // Paper vs Scissors
		, "C X": variables.Y + variables.LOSS // Scissors vs Paper
		, "C Y": variables.Z + variables.DRAW // Scissors vs Scissors
		, "C Z": variables.X + variables.WIN // Scissors vs Rock
	};

	function run() {
		var fileName = "input.txt";
		var tickCount = getTickCount();
		partOne( fileName );
		partTwo( fileName );
		print.yellowLine( "Solved in #getTickCount() - tickCount# ms" );
	}

	function example() {
		var fileName = "example.txt";
		partOne( fileName );
		partTwo( fileName );
	}

	function partOne( string fileName ) {
		// Get score
		var score = play( arguments.fileName, variables.outcomeScores );

		// Done
		print.greenLine( "Part one : your total score according to the strategy guide is #score#" );
	}

	function partTwo( required string fileName ) {
		// Get score
		var score = play( arguments.fileName, variables.alternativeOutcomeScores );

		// Done
		print.greenLine( "Part two : your total score according to the strategy guide is #score#" );
	}

	private numeric function play( required string fileName, required struct scoringChart ) {
		// Open file
		var file = fileOpen( getDirectoryFromPath( getCurrentTemplatePath() ) & arguments.fileName );

		// Init
		var score = 0;

		// Process
		var line = "";
		while ( !fileIsEOF( file ) ) {
			line = fileReadLine( file );
			score += arguments.scoringChart[ line ];
		}

		// Close file
		fileClose( file );

		// Done
		return score;
	}

}
