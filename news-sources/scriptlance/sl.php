<?
	$HOSTNAME 	= '';
	$PORT		= '';
	$AN_SERVER	= 'an_google_chrome';

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

	if (count($argv) != 2) die ('USAGE: sl.php DATA. You also must provide hostname and port of an_sender instance in sl.php'."\n");

	//$argv[1] = utf8_encode($argv[1]);
	//$argv[2] = utf8_encode($argv[2]);
	//print_r($argv);

	$$AN_SERVER = $argv[1];
	$an_libnotify = "\"mutt\" \"New Scriptlance Project\"";
	$an_generic_receiver = json_encode(
			array ("service" => "mutt", "event" => "scriptlance", "data" =>
					array ("url" => $argv[1])
				)
			);

	do_post_request('http://'.$HOSTNAME.':'.$PORT, 
		$AN_SERVER.'='.urlencode($$AN_SERVER) . 
		'&an_generic_receiver='.urlencode($an_generic_receiver) .
		'&an_libnotify='.urlencode($an_libnotify)
	);
	//do_post_request('http://'.$HOSTNAME.':'.$PORT, 'a=АД');
