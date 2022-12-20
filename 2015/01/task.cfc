component {

	function solve( string fileName ) {
		// Get input
		var input = fileRead( getDirectoryFromPath( getCurrentTemplatePath() ) & arguments.fileName );

		// Tracker
		var basement = "";

		// Process
		var floor = 0;
		for ( var i = 1; i <= len( input ); i++ ) {
			var char = mid( input, i, 1 );
			floor = char == "(" ? floor + 1 : floor - 1;
			if ( floor == -1 && len( trim( basement ) ) == 0 ) basement = i;
		}

		// Done
		print.greenLine( "Santa arrived at floor #floor#" );
		print.greenLine( "Santa entered the basement first at position #basement#" );
	}

	function run() {
		solve( "input.txt" );
	}

	function example() {
		solve( "example.txt" );
	}

}
