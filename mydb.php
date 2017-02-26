
<?php

   //Specifying the database parameteres.

   $dbhost = 'localhost';
   $dbuser = 'root';
   $dbpass = 'root';
   $dbname = 'facultyInfo';

   //Connecting to the database.

   $conn = mysqli_connect($dbhost, $dbuser, $dbpass, $dbname);

   //Returning connection error.

   if(! $conn )
   {
     die('Could not connect: ' . mysql_error());
   }

   //Sql query request parameter.

   $sql = $_REQUEST["q"];

   //Executing the query.

   $result = mysqli_query($conn, $sql);

   //Preparing the result.

   $string = "<table>";
   $fields = $result->fetch_fields();
   $string .= '<tr>';
   foreach ($fields as $val){
      $string .= '<th>' . $val->name . '</th>';
   }
   $string .= '</tr>';
   while($row = mysqli_fetch_array($result)){
      $string .= '<tr>';
      foreach ($fields as $val){
        $string .= '<td>' . $row[$val->name] . '</td>';
      }
     $string .= '</tr>';
   }
   $string .= "</table>";

   //Passing the result to the client.

   echo $string;

   //Closing the databse connection.
   
   mysql_close($conn);
?>
