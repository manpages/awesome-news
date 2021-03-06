<?
	$HOSTNAME 	= ''; //the hostname of an_sender
	$PORT		= ''; //the port of an_sender (see yaws.conf)
	$AN_SERVER	= 'an_libnotify';

	function do_post_request($url, $data, $optional_headers = null)
	{
		//echo "doing psot to $url with $data";
		$params = array('http' => array(
			'method' => 'POST',
			'content' => $data
		));
		if ($optional_headers!== null) {
			$params['http']['header'] = $optional_headers;
		}
		$ctx = stream_context_create($params);
		$fp = @fopen($url, 'rb', false, $ctx);
		if (!$fp) {
			throw new Exception("Problem with $url, $php_errormsg");
		}
		$response = @stream_get_contents($fp);
		if ($response === false) {
			throw new Exception("Problem reading data from $url, $php_errormsg");
		}
		return $response;
	} 

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

	if (count($argv) != 3 || !$HOSTNAME || !$PORT) die ('USAGE: php irssi.php SUMMARY DATA. You also must configure awesome-news sender hostname and port in irssi.php.'."\n");

	//$argv[1] = utf8_encode($argv[1]);
	//$argv[2] = utf8_encode($argv[2]);
	//print_r($argv);

	$esc[1] = str_replace('"', '\"', $argv[1]);
	$esc[2] = str_replace('"', '\"', $argv[2]);

	$$AN_SERVER = "\"$esc[1]\" \"$esc[2]\"";
	$an_generic_receiver = json_encode(
			array ("service" => "irssi", "event" => "highlight", "data" =>
					array ("summary" => $argv[1], "text" => $argv[2])
				)
			);

	do_post_request('http://'.$HOSTNAME.':'.$PORT, 
		$AN_SERVER.'='.urlencode($$AN_SERVER) . 
		'&an_generic_receiver='.urlencode($an_generic_receiver) .
		'&an_random='.urlencode(time())
	);
	//do_post_request('http://'.$HOSTNAME.':'.$PORT, 'a=АД');
