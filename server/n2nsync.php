<?php
/**
 * This tool is used to synchronize two or more configuration files of N2N Federation
 * You need to install PHP first: 
 * 
 * apt install php php-cli
 * or
 * yum install php php-cli
 * 
 * In order to use you should:  php -S 0.0.0.0:25900 /n2nsync/server/n2nsync.php
 * 
 * Version 0.1
 * Auth    EchoNoch
 */
$type=$_POST['type'];
$passwd=$_POST['passwd'];
$ip=$_SERVER ['REMOTE_ADDR'];
require(__DIR__ .'/config.php');

if($passwd!=$password){
    http_response_code(503);
    exit('PASSWORD ERROR');
}

if (!in_array($ip, $allowip)) {
    http_response_code(403);
    exit('IP ADDR NOT ALLOWED');
}

if(!isset($type)){
    http_response_code(504);
    exit('BAD REQUEST');
}

if($type=='config'){
if( file_exists(__DIR__ .'/config') ){
http_response_code(200);
$config = file_get_contents(__DIR__ .'/config');
echo $config . "\n" ;

$count=count($federation);
for($i=0;$i<$count;$i++){
    $config_data=$federation[$i];
    $config_para=explode(":",$config_data);
    if($ip!=$config_para[0]){
    echo '-l='.$config_data."\n";
    }
}
}else{
    http_response_code(404);
    exit("File do not exist!");
}
}

if($type=='list'){
    if( file_exists(__DIR__ .'/list') ){
    http_response_code(200);
    $config = file_get_contents(__DIR__ .'/list');
    echo $config . "\n" ;
    }else{
        http_response_code(404);
        exit("File do not exist!");
    }
}

if($type=='ping'){
    http_response_code(200);
    echo "pong";
}
?>