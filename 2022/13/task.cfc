component {

	variables.CONTINUE = 0;
	variables.NOTINORDER = 1;
	variables.INORDER = -1;
	variables.verbose = false;

	function run() {
		var fileName = "input.txt";
		var tickCount = getTickCount();
		partOne( fileName );
		partTwo( fileName );
		print.yellowLine( "Solved in #getTickCount() - tickcount# ms" );
	}

	function example() {
		var fileName = "example.txt";
		variables.verbose = true;
		partOne( fileName );
		variables.verbose = false;
		partTwo( fileName );
	}

	function partOne( required string fileName ) {
		// Get pairs
		var pairs = readPairs( arguments.fileName );

		// Process
		var sum = pairs.reduce( function( result, p, i ) {
			println( "== Pair #i# ==" );
			var res = cmp( deserializeJSON( arguments.p.first() ), deserializeJSON( arguments.p.last() ) );
			if ( res == variables.INORDER ) arguments.result = arguments.result + arguments.i;
			println();
			return arguments.result;
		}, 0 );

		// Done
		print.green( "Part one: the sum of the indices of the pairs that are in the right order is " ).yellowLine( sum );
	}

	function partTwo( required string fileName ) {
		// Get pairs
		var pairs = readPairs( arguments.fileName );

		// Convert to array
		pairs = pairs.reduce( function( result, p ) {
			arguments.result.append( arguments.p[ 1 ] );
			arguments.result.append( arguments.p[ 2 ] );
			return arguments.result;
		}, [] );

		// Add divider packets
		pairs.append( [ "[[2]]", "[[6]]" ], true );

		// Sort
		arraySort( pairs, function( one, two ) {
			return cmp( deserializeJSON( one ), deserializeJSON( two ) );
		} );

		// Calculate
		var res = pairs.find( "[[2]]" ) * pairs.find( "[[6]]" );

		// Done
		print.green( "Part two: the decoder key for the distress signal is " ).yellowLine( res );
	}

	function readPairs( required string fileName ) {
		// Open file
		var file = fileOpen( getDirectoryFromPath( getCurrentTemplatePath() ) & arguments.fileName );

		// Process
		var pairs = [];
		while ( !fileIsEOF( file ) ) {
			var line = fileReadLine( file );
			if ( len( trim( line ) ) == 0 ) continue;
			var pair = [ line ];
			if ( !fileIsEOF( file ) ) pair.append( fileReadLine( file ) );
			pairs.append( pair );
		}

		// Close file
		fileClose( file );

		// Done
		return pairs;
	}

	function println( string line = "", string method = "line" ) {
		if ( variables.verbose ) invoke( print, arguments.method, [ arguments.line ] );
	}

	function cmp( any left, any right, numeric level = 0 ) {
		// Verbose
		println( "#repeatString( " ", arguments.level * 2 )#- Compare #$toString( arguments.left )# vs #$toString( arguments.right )#" );

		/* If both values are integers, the lower integer should come first. If the left integer is lower than the
		 * right integer, the inputs are in the right order. If the left integer is higher than the right integer,
		 * the inputs are not in the right order. Otherwise, the inputs are the same integer; continue checking the
		 * next part of the input.
		 */
		if ( isNumeric( arguments.left ) && isNumeric( arguments.right ) ) {
			// left integer is lower than the right integer, right order
			if ( val( arguments.left ) < val( arguments.right ) ) {
				println( "#repeatString( " ", ( arguments.level + 1 ) * 2 )#- Left side is smaller, so inputs are in the right order" );
				return variables.INORDER;
			}
			// left integer is higher than the right integer, not the right order
			else if ( val( arguments.left ) > val( arguments.right ) ) {
				println( "#repeatString( " ", ( arguments.level + 1 ) * 2 )#- Right side is smaller, so inputs are not in the right order" );
				return variables.NOTINORDER;
			}
			// continue
			else return variables.CONTINUE;
		}
		/* If exactly one value is an integer, convert the integer to a list which contains that integer as its only
		 * value, then retry the comparison. For example, if comparing [0,0,0] and 2, convert the right value to [2] (a list
		 * containing 2); the result is then found by instead comparing [0,0,0] and [2].
		 */
		else if ( isNumeric( arguments.left ) && isArray( arguments.right ) ) {
			println( "#repeatString( " ", ( arguments.level + 1 ) * 2 )#- Mixed types; convert left to [#arguments.left#] and retry comparison" );
			return cmp( [ val( arguments.left ) ], arguments.right, arguments.level + 1 );
		}
		/* If exactly one value is an integer, convert the integer to a list which contains that integer as its only value,
		 * then retry the comparison. For example, if comparing [0,0,0] and 2, convert the right value to [2] (a list
		 * containing 2); the result is then found by instead comparing [0,0,0] and [2].
		 */
		else if ( isArray( arguments.left ) && isNumeric( arguments.right ) ) {
			println( "#repeatString( " ", ( arguments.level + 1 ) * 2 )#- Mixed types; convert right to [#arguments.right#] and retry comparison" );
			return cmp( arguments.left, [ val( arguments.right ) ], arguments.level + 1 );
		}
		/* If both values are lists, compare the first value of each list,
		 * then the second value, and so on. If the left list runs out of items first,
		 * the inputs are in the right order. If the right list runs out of items first,
		 * the inputs are not in the right order. If the lists are the same length and no
		 * comparison makes a decision about the order, continue checking the next part of the input.
		 */
		else if ( isArray( arguments.left ) && isArray( arguments.right ) ) {
			// Init
			var res = variables.CONTINUE;

			// Get count
			var count = min( arguments.left.len(), arguments.right.len() );

			// Process
			var i = 0;
			while ( ++i <= count && res == variables.CONTINUE ) {
				res = cmp( arguments.left[ i ], arguments.right[ i ], arguments.level + 1 );
			}

			// Continue checking next part of input
			if ( arguments.left.len() == arguments.right.len() && res == variables.CONTINUE ) {
				return variables.CONTINUE;
			}

			// Left runs out
			if ( i > arguments.left.len() && res == variables.CONTINUE ) {
				println( "#repeatString( " ", ( arguments.level + 1 ) * 2 )#- Left side ran out of items, so inputs are in the right order" );
				return variables.INORDER;
			}

			// Right runs out
			if ( i > right.len() && res == variables.CONTINUE ) {
				println( "#repeatString( " ", ( arguments.level + 1 ) * 2 )#- Right side ran out of items, so inputs are not in the right order" );
				return variables.NOTINORDER;
			}

			// Done
			return res;
		}

		// Default case
		return variables.CONTINUE;
	}

	function $toString( any value ) {
		// toString for arrays
		if ( isArray( arguments.value ) ) {
			return "[" & arguments.value.reduce( function( result, e ) {
				return listAppend( arguments.result, $toString( arguments.e ), "," );
			}, "" ) & "]";
		}

		// Default behavior
		return "#arguments.value#";
	}

}
