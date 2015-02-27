<?php
require './PHPMailer-master/PHPMailerAutoload.php';
// Here we get all the information from the fields sent over by the form.

$mail = new PHPMailer;
$mail->isSMTP();                                      // Set mailer to use SMTP
$mail->Host = 'smtp.gmail.com';  // Specify main and backup SMTP servers
$mail->SMTPAuth = true;
$mail->Username = 'ospreydronecompany@gmail.com';                 // SMTP username
$mail->Password = 'thedixichix';                           // SMTP password
$mail->SMTPSecure = 'tls';                            // Enable TLS encryption, `ssl` also accepted
$mail->Port = 587;                                    // TCP port to connect to

$mail->From = 'ospreydronecompany@gmail.com';
$mail->FromName = 'Osprey Drones';
$mail->addAddress('ospreydronecompany@gmail.com', 'Osprey Drones');     // Add a recipient

$mail->isHTML(true);                                  // Set email format to HTML

$mail->Subject = $subject;
$mail->Body    = $message;

if(!$mail->send()) {
    error_log('Message could not be sent.');
    error_log('Mailer Error: ' . $mail->ErrorInfo);
} else {
    error_log('Message has been sent');
}
?>