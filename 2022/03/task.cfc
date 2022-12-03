component {

	function run() {
		var fileName = "input.txt";
		var ticks = getTickCount();
		partOne( fileName );
		partTwo( fileName );
		print.yellowLine( "Solved in #getTickCount() - ticks# ms" );
	}

	function example() {
		var fileName = "example.txt";
		partOne( fileName );
		partTwo( fileName );
	}

	function partOne( string fileName ) {
		// Open file
		var file = fileOpen( getDirectoryFromPath( getCurrentTemplatePath() ) & arguments.fileName );

		// Init
		var total = 0;

		// Process
		var line = "";
		while ( !fileIsEOF( file ) ) {
			line = fileReadLine( file );

			// Tokenize
			var items = tokenize( line );

			// Determine overlap
			var firstRucksack = items.slice( 1, items.len() / 2 );
			var secondRucksack = items.slice( items.len() / 2 + 1, items.len() / 2 );
			firstRucksack.retainAll( secondRucksack );

			// Use HashSet to eliminate duplicates
			items = createObject( "java", "java.util.HashSet" ).init( firstRucksack );

			// Calculate total
			total += arrayReduce(
				  items.toArray()
				, function( result, e ) {
					return arguments.result + $val( arguments.e );
				}
				, 0
			);
		}

		// Close file
		fileClose( file );

		// Done
		print.greenLine( "Part one : the sum of the priorities is #total#" );
	}

	function partTwo( string fileName ) {
		// Open file
		var file = fileOpen( getDirectoryFromPath( getCurrentTemplatePath() ) & arguments.fileName );

		// Init
		var total = 0;

		// Process
		var line = "";
		while ( !fileIsEOF( file ) ) {
			line = fileReadLine( file );

			// Tokenize
			var tokens = tokenize( line );

			// Initialize items
			var items = tokens.duplicate();
			for ( var i = 1; i <= 2 && !fileIsEOF( file ); i++ ) {
				line = fileReadLine( file );
				tokens = tokenize( line );
				items.retainAll( tokens );
			}

			// Use HashSet to eliminate duplicates
			items = createObject( "java", "java.util.HashSet" ).init( items );

			// Calculate total
			total += arrayReduce(
				  items.toArray()
				, function( result, e ) {
					return arguments.result + $val( arguments.e );
				}
				, 0
			);
		}

		// Close file
		fileClose( file );

		// Done
		print.greenLine( "Part two : the sum of the priorities is #total#" );
	}

	private array function tokenize( string line ) {
		var items = [];
		for ( var c = 1; c <= len( line ); c++ ) {
			items.append( mid( line, c, 1 ) );
		}
		return items;
	}

	private numeric function $val( required string token ) {
		return reFind( "[a-z]", arguments.token ) != 0 ? asc( arguments.token ) - 96 : asc( arguments.token ) - 38;
	}

}
