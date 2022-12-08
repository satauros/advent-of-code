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
		// Init
		var fs = readFileSystem( arguments.fileName );

		// Verbose
		preorderPrint( fs[ "/" ] );

		// Calculate sizes
		var totals = preorderSize( fs[ "/" ], 100000 );

		// Get total
		var total = totals.reduce( function( result, e ) {
			return arguments.result + arguments.e;
		}, 0 );

		// Verbose
		print.greenText( "Part one: the sum of the total sizes of directories with a total size of at most 100000 is " ).boldGreenLine( total );
	}

	function partTwo( required string fileName ) {
		// Init
		var fs = readFileSystem( arguments.fileName );

		// Get remaining size
		var remainingSize = 70000000 - calculateSize( fs[ "/" ] );

		// Use a sorted TreeSet
		var res = createObject( "java", "java.util.TreeSet" );

		// Get all directory sizes
		preorderTraverse( fs[ "/" ], function( n, l ) {
			if ( isDirectory( arguments.n ) ) {
				var size = calculateSize( arguments.n );
				if ( remainingSize + size >= 30000000 ) res.add( size );
			}
		} );

		// Get result
		res = arrayFirst( res );

		// Done
		print.greenText( "Part two: the size of the smallest directory that, if deleted, would free up enough space on the filesystem to run the update is " ).boldGreenLine( res );
	}

	function preorderPrint( required struct node ) {
		// Define toString function
		var $toString = function( node ) {
			return !isDirectory( arguments.node )
			 ? "#arguments.node.path# (file, size=#arguments.node.size#)"
			 : "#arguments.node.path# (dir)";
		};
		// Execute
		preorderTraverse( arguments.node, function( n, l ) {
			print.whiteLine( "#repeatString( "  ", arguments.l )#- #$toString( arguments.n )#" );
		} );
	}

	function preorderSize( required struct node, numeric limit = 100000 ) {
		var result = [];
		preorderTraverse( arguments.node, function( n, l ) {
			if ( isDirectory( arguments.n ) ) {
				var size = calculateSize( arguments.n );
				if ( size <= limit ) result.append( size );
			}
		} );
		return result;
	}

	function preorderTraverse( required struct node, any callback, numeric level = 0 ) {
		callback( arguments.node, arguments.level );
		if ( isDirectory( arguments.node ) ) {
			arguments.node.children.each( function( e ) {
				preorderTraverse( arguments.e, callback, level + 1 );
			} );
		}
	}

	function calculateSize( required struct node ) {
		// Recurse
		if ( isDirectory( arguments.node ) ) {
			return arguments.node.children.reduce( function( result, e ) {
				return arguments.result + calculateSize( arguments.e );
			}, 0 );
		}
		// Base
		return val( arguments.node.size );
	}

	function readFileSystem( required string fileName ) {
		// Open file
		var file = fileOpen( getDirectoryFromPath( getCurrentTemplatePath() ) & arguments.fileName );

		// Make sure 'cwd' is undefined
		var cwd = javacast( "null", "" );

		// Process
		var line = "";
		while ( !fileIsEOF( file ) ) {
			line = fileReadLine( file );
			// cd
			if ( listFirst( line, " " ) == "$" && listGetAt( line, 2, " " ) == "cd" ) {
				// Get directory
				var dir = listLast( line, " " );
				// fs root
				if ( !isDefined( "cwd" ) ) {
					cwd = {
						  "path": dir
						, "parent": {}
						, "children": []
						, "size": 0
					};
					cwd.parent = cwd;
					fs[ cwd.path ] = cwd;
				}
				// traverse up
				else if ( dir == ".." ) {
					cwd = cwd.parent;
				}
				// traverse down
				else {
					// Find child
					var idx = cwd.children.find( function( e ) {
						return arguments.e.path == dir;
					} );
					// Go to child
					cwd = cwd.children[ idx ];
				}
			}
			// file
			else if ( isNumeric( listFirst( line, " " ) ) ) {
				cwd.children.append( { "path": listLast( line, " " ), "parent": cwd, "size": listFirst( line, " " ) } );
			}
			// dir
			else if ( listFirst( line, " " ) == "dir" ) {
				cwd.children.append( { "path": listLast( line, " " ), "parent": cwd, "children": [] } );
			}
		}

		// Close file
		fileClose( file );
	}

	function isDirectory( required struct node ) {
		return arguments.node.keyExists( "children" );
	}

}
