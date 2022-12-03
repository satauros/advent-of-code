component {

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

	function partOne( required string fileName ) {
		// Get elves
		var elves = getElves( arguments.fileName );

		// Get total
		var legolas = elves.first();

		// Part one
		print.greenLine( "Part one : the elf with the most calories is carrying a total of #legolas.calories# calories" );
	}

	function partTwo( required string fileName ) {
		// Get elves
		var elves = getElves( arguments.fileName );

		// Calculate top three
		var total = elves
			.slice( 1, 3 )
			.reduce( function( result, e ) {
				return arguments.result + arguments.e.calories;
			}, 0 );

		// Part two
		print.greenLine( "Part two : the top three elves are carrying a total of #total# calories" );
	}

	private array function getElves( required string fileName ) {
		// Init
		var elves = [];

		// Open file
		var file = fileOpen( getDirectoryFromPath( getCurrentTemplatePath() ) & arguments.fileName );

		// Current elf
		var currentElf = { "number": 1, "calories": 0 };

		// Process
		var line = "";
		while ( !fileIsEOF( file ) ) {
			// Read line
			line = fileReadLine( file );

			// Get calories
			var calories = val( line );

			// Add
			currentElf.calories += calories;

			// Move on to the next elf
			if ( calories == 0 || fileIsEOF( file ) ) {
				elves.append( currentElf );
				currentElf = { "number": currentElf.number + 1, "calories": calories };
			}
		}

		// Close file
		fileClose( file );

		// Sort descending
		return elves = elves.sort( function( one, two ) {
			return arguments.one.calories > arguments.two.calories ? -1 : ( arguments.one.calories < arguments.two.calories ? 1 : 0 );
		} );
	}

}
