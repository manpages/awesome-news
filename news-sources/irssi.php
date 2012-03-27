<?
	$HOSTNAME 	= 'memoricide.very.lv';
	$PORT		= '53318';
	$AN_SERVER	= 'an_generic_receiver';

	if (!function_exists('json_encode')) {
		function json_encode($data) {
			switch ($type = gettype($data)) {
				case 'NULL':
					return 'null';
				case 'boolean':
					return ($data ? 'true' : 'false');
				case 'integer':
				case 'double':
				case 'float':
					return $data;
				case 'string':
					return '"' . addslashes($data) . '"';
				case 'object':
					$data = get_object_vars($data);
				case 'array':
					$output_index_count = 0;
					$output_indexed = array();
					$output_associative = array();
					foreach ($data as $key => $value) {
						$output_indexed[] = json_encode($value);
						$output_associative[] = json_encode($key) . ':' . json_encode($value);
						if ($output_index_count !== NULL && $output_index_count++ !== $key) {
							$output_index_count = NULL;
						}
					}
					if ($output_index_count !== NULL) {
						return '[' . implode(',', $output_indexed) . ']';
					} else {
						return '{' . implode(',', $output_associative) . '}';
					}
				default:
					return ''; // Not supported
			}
		}
	}

	if (count($argv) != 3) die ('USAGE: php irssi.php CAT_ID CAT_NAME'."\n");

	$fp = fsockopen($HOSTNAME, $PORT);
	fwrite ($fp, json_encode(
		array(
			array ($AN_SERVER => "\"$argv[1]\" \"$argv[2]\"")
		)
	));
	fclose($fp);
