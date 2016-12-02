<?php

//
// makeDocs.php - generates the StickFigure help and in-browser (ProcessingJS) versions of sketches
//
// The configuration settings in config.php will require attention before
// you are able to run this script successfully.
//
// usage:  php makeDocs.php
//

include 'config.php';
include 'makeJSSketches.php';

//
// Build sketch
//

$baseDir = realPath(dirname(__FILE__) . '/../') . DIRECTORY_SEPARATOR;
$sketchName = $namesOfSketches[0];
$sketchDir = $baseDir . $sketchName . DIRECTORY_SEPARATOR;

exec( $processingJavaPaths[0] . ' --force --sketch=' . $sketchDir . ' --output=' . $sketchDir . '/build --build',
      $output,
      $nReturnCode);

if ($nReturnCode !== 0) {
    exit($nReturnCode);
}

$classPath = dirname($processingJavaPaths[0]) . '/core/library/core.jar';

//
// getLine
//

function getLine($lines, $nLine, $needle) {

    while($nLine < count($lines)) {
        
        if ($lines[$nLine] === $needle) {
            return $nLine;
        }

        ++$nLine;
    }

    exit("Expected line not found");
} 

//
// Break the just the three StickFigure.pde classes
//

$javaFilename = $sketchDir . 'build/source/' . $sketchName . '.java';

$java = file_get_contents($javaFilename);

$lines = explode("\n", $java); 

$nStart = getLine($lines, 0, '/**');
$nEnd = getLine($lines, $nStart, '};');
$nEnd = getLine($lines, $nEnd + 1, '};');
$nEnd = getLine($lines, $nEnd + 1, '};');

$lines = array_slice($lines, $nStart, $nEnd - $nStart + 1);
$java = "import java.util.ArrayList;\n"
      . "import processing.core.PVector;\n"
      . implode("\n", $lines);

file_put_contents($javaFilename, $java);

exec( 'javadoc -cp ' . $classPath . ' -notimestamp -private -nodeprecatedlist -nohelp -noqualifier all -d ../docs ' . $javaFilename,
      $output,
      $nReturnCode);

//
// Remove the string "(package private)" from all generated html files
// Everything in Processing is public
//

$dir = scandir('../docs');

for ($n = 0; $n < count($dir); ++$n)
{
    $sFile = '../docs/' . $dir[$n];

    if (endsWith($sFile, '.html')) {
        echo($sFile . "\n");

        $html = file_get_contents($sFile);
        $html = str_replace("(package private) ", "", $html);
        file_put_contents($sFile, $html);
    }
}

?>
