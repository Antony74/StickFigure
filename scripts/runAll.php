<?php

//
// runAll.php
//
// Build and run all sketches in various flavors of Processing so that
// (once the computer stops whirring and catches up with itself) we can
// easily see if it is working in all contexts.
//
// The configuration settings in config.php will require attention before
// you are able to run this script successfully.
//
// usage:  php runAll.php
//

include 'config.php';
include 'makeJSSketches.php';

//
// Check all copies of StickFigure.pde are the same
//

$arrStickFigure = Array();

for ($nSketch = 0; $nSketch < count($namesOfSketches); ++$nSketch) {

	$sketchName = $namesOfSketches[$nSketch];
	$path = $baseDir . $sketchName . '/StickFigure.pde';

	$code = file_get_contents($path);

	array_push($arrStickFigure, $code);

	if ($nSketch) {
		if ($arrStickFigure[0] !== $code) {
			exit($path . ' differs.  Please reintegrate?');
		}
	}
}


//
// Run all Java sketches
//

$baseDir = realPath(dirname(__FILE__) . '/../') . DIRECTORY_SEPARATOR;

for ($nVersion = 0; $nVersion < count($processingJavaPaths); ++$nVersion) {

	for ($nSketch = 0; $nSketch < count($namesOfSketches); ++$nSketch) {

		$sketchName = $namesOfSketches[$nSketch];
		$sketchDir = $baseDir . $sketchName . DIRECTORY_SEPARATOR;

		pclose(popen('start ' . $processingJavaPaths[$nVersion] . ' --force --sketch=' . $sketchDir . ' --output=' . $sketchDir . '/build' . $nVersion . ' --run',
			  'r'));
	}
}

//
// Run all ProcessingJS sketches
//

