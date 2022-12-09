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
		// Get input
		var forest = measure( arguments.fileName );

		// Calculate
		var count = len( forest ) + 2 * ( len( forest ) - 1 ) + ( len( forest ) - 2 );
		for ( var i = 2; i <= len( forest ) - 1; i++ ) {
			for ( var j = 2; j <= len( forest[ i ] ) - 1; j++ ) {
				if ( visible( forest, i, j ) ) count++;
			}
		}

		// Done
		print.greenLine( "Part one: #count# trees are visible" );
	}

	function partTwo( required string fileName ) {
		// Get input
		var forest = measure( arguments.fileName );

		// Use Java's TreeSet (sorted + unique)
		var scores = createObject( "java", "java.util.TreeSet" );

		// Calculate
		var count = len( forest ) + 2 * ( len( forest ) - 1 ) + ( len( forest ) - 2 );
		for ( var i = 1; i <= len( forest ); i++ ) {
			for ( var j = 1; j <= len( forest[ i ] ); j++ ) {
				scores.add( score( forest, i, j ) );
			}
		}

		// Done
		print.greenLine( "Part two: #arrayLast( scores.toArray() )# is the highest scenic score" );
	}

	function visible( required array f, required numeric r, required numeric c ) {
		// Not visible by default
		var result = false;

		// Line of sight - left
		var j = 1;
		while ( !result && j < c && f[ r ][ j ] < f[ r ][ c ] ) j++;
		if ( j == c ) result = true;

		// Line of sight - top
		var i = 1;
		while ( !result && i < r && f[ i ][ c ] < f[ r ][ c ] ) i++;
		if ( i == r ) result = true;

		// Line of sight - right
		j = c + 1;
		while ( !result && j <= len( f[ r ] ) && f[ r ][ j ] < f[ r ][ c ] ) j++;
		if ( j > len( f[ r ] ) ) result = true;

		// Line of sight - bottom
		i = r + 1;
		while ( !result && i <= len( f ) && f[ i ][ c ] < f[ r ][ c ] ) i++;
		if ( i > len( f ) ) result = true;

		// Done
		return result;
	}

	function score( required array f, required numeric r, required numeric c ) {
		// Score top
		var topScore = 0;
		for ( var i = r - 1; i >= 1; i -= 1 ) {
      topScore++;
      if( f[i][c] >= f[r][c] ) break;
		}

    // Score left
		var leftScore = 0;
		for ( var j = c - 1; j >= 1; j -= 1 ) {
      leftScore++;
      if( f[r][j] >= f[r][c] ) break;
		}

		// Score bottom
		var bottomScore = 0;
		for ( var i = r + 1; i <= len( f ); i += 1 ) {
      bottomScore++;
      if( f[i][c] >= f[r][c] ) break;
		}

    // Score right
		var rightScore = 0;
		for ( var j = c + 1; j <= len( f[ r ] ); j += 1 ) {
      rightScore++;
      if( f[r][j] >= f[r][c] ) break;
		}

    // Verbose
    if( len( f ) <= 10) {
      print.blueText( "#f[ r ][ c ]# (" );
      print.redText( "#topScore#,#leftScore#,#bottomScore#,#rightScore#" );
      print.blueText( ") " );
	    if ( c == len( f[ r ] ) ) print.line();
	    if ( c == len( f[ r ] ) && r == len( f ) ) print.line();
    }

		// Done
		return leftScore * topScore * rightScore * bottomScore;
	}

	function measure( required string fileName ) {
		// Open file
		var file = fileOpen( getDirectoryFromPath( getCurrentTemplatePath() ) & arguments.fileName );

		// Init
		var forest = arrayNew( 2 );

		// Process
		while ( !fileIsEOF( file ) ) {
			line = fileReadLine( file );

			// Get tree measurements
			var trees = [];
			for ( var i = 1; i <= len( line ); i++ ) {
				trees.append( mid( line, i, 1 ) );
			}

			// Add results
			forest.append( trees );
		}

		// Close file
		fileClose( file );

		// Done
		return forest;
	}

}
