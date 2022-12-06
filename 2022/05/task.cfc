component {

	function run() {
		var fileName = "input.txt";
		var tickCount = getTickCount();
		partOne( fileName );
		partTwo( fileName );
		print.yellowLine( "Solved in #getTickCount() - tickcount# ms" );
	}

	function example() {
		var fileName = "example.txt";
		partOne( fileName );
		partTwo( fileName );
	}

	function partOne( required string fileName ) {
		// Open file
		var file = fileOpen( getDirectoryFromPath( getCurrentTemplatePath() ) & arguments.fileName );

		// Init
		var stacks = getInitialState( file );

		// Process
		while ( !fileIsEOF( file ) ) {
			line = fileReadLine( file );

			// Get parameters
			var num = listGetAt( line, 2, " " );
			var src = listGetAt( line, 4, " " );
			var dst = listGetAt( line, 6, " " );

			// Move
			for ( var i = 1; i <= num; i++ ) {
				var box = stacks[ src ].shift();
				stacks[ dst ].unshift( box );
			}
		}

		// Close file
		fileClose( file );

		// Done
		print.greenLine( "Part one: #peek( stacks )#" );
	}

	function partTwo( required string fileName ) {
		// Open file
		var file = fileOpen( getDirectoryFromPath( getCurrentTemplatePath() ) & arguments.fileName );

		// Init
		var stacks = getInitialState( file );

		// Process
		var line = "";
		while ( !fileIsEOF( file ) ) {
			line = fileReadLine( file );

			// Get parameters
			var num = listGetAt( line, 2, " " );
			var src = listGetAt( line, 4, " " );
			var dst = listGetAt( line, 6, " " );

			// Move
			for ( var i = num; i >= 1; i-- ) {
				var box = stacks[ src ][ i ];
				stacks[ src ].deleteAt( i );
				stacks[ dst ].prepend( box );
			}
		}

		// Close file
		fileClose( file );

		// Done
		print.greenLine( "Part two: #peek( stacks )#" );
	}

	private array function getInitialState( required any file ) {
		// Init
		var stacks = arrayNew( 2 );

		// Process
		var line = "null";
		while ( !fileIsEOF( file ) && len( trim( line ) ) != 0 ) {
			line = fileReadLine( file );
			if ( find( "[", line ) != 0 ) {
				var matches = reFindNoCase(
					  "(\s{3}|\[[A-Z]\])\s?"
					, line
					, 1
					, true
					, "all"
				);
				for ( var i = 1; i <= matches.len(); i++ ) {
					if ( len( trim( matches[ i ].match[ 2 ] ) ) ) stacks[ i ].append( matches[ i ].match[ 2 ] );
				}
			}
		}

		// Done
		return stacks;
	}

	private string function peek( required array stacks ) {
		return arguments.stacks.reduce( function( result, e ) {
			return arguments.result & mid( arguments.e.first(), 2, 1 );
		}, "" );
	}

}
