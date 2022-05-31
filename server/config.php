<?php
#the passwd will be used when a client connected to the server
#you should change the passwd when using it
$password='n2nsync';

#you should write the IP ADDR allowed to use the SYNC in this ARRAY
$allowip=array(
    "192.168.0.1",
    "127.0.0.1",
    "10.0.0.1",
    "111.111.111.112"
);

#This is an alternative if the IP used by the client to access the Servers does not match the actual IP
#In this way, the client can attach an IP address to the POST for IP address authentication
if(isset($_POST['ip'])){
$ip=$_POST['ip'];
};

$federation=array(
    "111.111.111.111:5974",
    "111.111.111.112:5974",
    "111.111.111.113:5974"
);
?>