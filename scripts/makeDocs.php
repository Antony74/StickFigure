<?php

//
// javadoc.php - generates the StickFigure help
//
// The configuration settings in config.php will require attention before
// you are able to run this script successfully.
//
// usage:  php javadoc.php
//

include 'config.php';

$baseDir = realPath(dirname(__FILE__) . '/../') . DIRECTORY_SEPARATOR;

exec( $processingJavaPaths[0] . ' --force --sketch=' . $baseDir . $namesOfSketches[0] . ' --output=' . $baseDir . 'JavaDoc --build',
      $output,
      $nReturnCode);

if ($nReturnCode !== 0) {
    exit($nReturnCode);
}

$process = proc_open( 'javadoc -private ' . $baseDir . 'JavaDoc/source/' . $namesOfSketches[0] . '.java',
                      Array(),
                      $pipes,
                      $baseDir . 'JavaDoc/source/');

$nReturnCode = proc_close($process);

if ($nReturnCode !== 0) {
    exit($nReturnCode);
}

processClass("Vertex");
processClass("StickPuppet");
processClass("StickFigure");

function processClass($sName)
{
    global $baseDir, $namesOfSketches, $webBrowserPaths;

    $sFilename = $baseDir . 'JavaDoc/source/' . $namesOfSketches[0] . '.' . $sName . '.html';

    $sDoc = file_get_contents($sFilename);
    $sDoc = explode('<!-- ======== START OF CLASS DATA ======== -->', $sDoc)[1];
    $sDoc = explode('<!-- ========= END OF CLASS DATA ========= -->', $sDoc)[0];

    file_put_contents($sFilename, $sDoc);

//    $cmd = 'start "' . $webBrowserPaths[0] . '" ' . $baseDir . 'JavaDoc/source/' . $sName . '.html';
//    exec(str_replace('/', DIRECTORY_SEPARATOR, $cmd));
}

?>
