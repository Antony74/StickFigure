<?php

//
// makeJSSketches.php - generates in-browser (ProcessingJS) versions of sketches
//
// The configuration settings in config.php will require attention before
// you are able to run this script successfully.
//
// usage:  php makeJSSketches.php
//

include_once 'config.php';

function endsWith( $str, $sub ) {
   return ( substr( $str, strlen( $str ) - strlen( $sub ) ) === $sub );
}

//
// Build sketch
//

$baseDir = realPath(dirname(__FILE__) . '/../') . DIRECTORY_SEPARATOR;

for ($nSketch = 0; $nSketch < count($namesOfSketches); ++$nSketch) {

    $sketchName = $namesOfSketches[$nSketch];
    $inputDir = $baseDir . $sketchName . '/';
    $outputFilename = $baseDir . 'docs/' . $sketchName . '/' . $sketchName . '.pde';

    $dir = scandir($inputDir);

    $arrContents = Array();

    for ($n = 0; $n < count($dir); ++$n)
    {
        $sFile = $inputDir . $dir[$n];

        if (endsWith($sFile, '.pde')) {
            echo($sFile . "\n");

            $pde = file_get_contents($sFile);
            array_push($arrContents, $pde);
        }
    }

    echo($outputFilename . "\n");
    file_put_contents($outputFilename, implode("\n\n", $arrContents));
}

?>

